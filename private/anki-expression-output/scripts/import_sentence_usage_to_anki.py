#!/usr/bin/env python3
# Import sentence_usage_analysis.tsv into Anki via AnkiConnect.
import argparse
import csv
import hashlib
import html
import json
import re
import sys
import urllib.request
from pathlib import Path

FIELDS = [
    'import_id', 'trigger_zh', 'atomic_unit', 'sentence', 'sentence_function',
    'appreciation_zh', 'personal_example', 'practice_task', 'unit_type',
    'source_filename', 'source_line', 'confidence', 'needs_review',
    'review_reason', 'source_path', 'tags_source'
]
INPUT_REQUIRED = [
    'trigger_zh', 'atomic_unit', 'sentence', 'sentence_function', 'appreciation_zh',
    'personal_example', 'practice_task', 'unit_type', 'source_filename', 'source_line',
    'confidence', 'needs_review', 'review_reason', 'source_path'
]
CSS = '''
.card { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; font-size: 18px; line-height: 1.55; color: #1f2933; background: #fafafa; text-align: left; }
.prompt { font-size: 22px; font-weight: 650; margin-bottom: 12px; }
.hint { color: #64748b; font-size: 15px; }
.answer { font-size: 24px; font-weight: 700; color: #0f766e; margin: 12px 0; }
.block { margin: 12px 0; }
.label { color: #64748b; font-size: 14px; font-weight: 650; text-transform: uppercase; letter-spacing: 0; }
.sentence { color: #334155; }
.meta { color: #64748b; font-size: 13px; margin-top: 18px; }
hr { border: 0; border-top: 1px solid #d7dde5; margin: 16px 0; }
'''.strip()
TEMPLATES = [
    {
        'Name': 'Output - Trigger to Expression',
        'Front': '<div class="prompt">{{trigger_zh}}</div>\n<div class="hint">用英文说/写出一个可复用表达。</div>',
        'Back': '{{FrontSide}}\n<hr>\n<div class="answer">{{atomic_unit}}</div>\n<div class="block"><div class="label">Personal Example</div>{{personal_example}}</div>\n<div class="block"><div class="label">Original Sentence</div><div class="sentence">{{sentence}}</div></div>\n<div class="block"><div class="label">Appreciation</div>{{appreciation_zh}}</div>\n<div class="meta">{{source_filename}}:{{source_line}} · {{unit_type}} · confidence {{confidence}}</div>'
    },
    {
        'Name': 'Context - Sentence to Unit',
        'Front': '<div class="label">从这个句子里拆出可迁移表达</div>\n<div class="sentence">{{sentence}}</div>',
        'Back': '{{FrontSide}}\n<hr>\n<div class="answer">{{atomic_unit}}</div>\n<div class="block"><div class="label">Function</div>{{sentence_function}}</div>\n<div class="block"><div class="label">Trigger</div>{{trigger_zh}}</div>\n<div class="block"><div class="label">Practice</div>{{practice_task}}</div>\n<div class="meta">{{source_filename}}:{{source_line}} · {{needs_review}}</div>'
    }
]

class Anki:
    def __init__(self, url):
        self.url = url.rstrip('/')
    def invoke(self, action, params=None, timeout=60):
        payload = json.dumps({'action': action, 'version': 6, 'params': params or {}}).encode('utf-8')
        req = urllib.request.Request(self.url, payload, {'Content-Type': 'application/json'})
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            data = json.loads(resp.read().decode('utf-8'))
        if data.get('error') is not None:
            raise RuntimeError(f'AnkiConnect {action} failed: {data["error"]}')
        return data.get('result')

def clean_field(value):
    return html.escape(value or '').replace('\n', '<br>')

def clean_tag(tag):
    tag = (tag or '').strip()
    if not tag:
        return ''
    tag = re.sub(r'\s+', '_', tag)
    return tag.replace('/', '_').replace('\\', '_')

def make_import_id(row):
    raw = '\t'.join([row.get('source_filename',''), row.get('source_line',''), row.get('sentence',''), row.get('atomic_unit','')])
    return 'sua_' + hashlib.sha1(raw.encode('utf-8')).hexdigest()[:20]

def compatible_model(anki, base_model):
    names = anki.invoke('modelNames')
    for suffix in ['', ' v2', ' v3', ' v4']:
        name = base_model + suffix
        if name in names and anki.invoke('modelFieldNames', {'modelName': name}) == FIELDS:
            return name, False
    for suffix in ['', ' v2', ' v3', ' v4']:
        name = base_model + suffix
        if name not in names:
            anki.invoke('createModel', {'modelName': name, 'inOrderFields': FIELDS, 'css': CSS, 'isCloze': False, 'cardTemplates': TEMPLATES})
            return name, True
    raise RuntimeError('No compatible or available model name found')

def chunks(seq, size):
    for i in range(0, len(seq), size):
        yield seq[i:i + size]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--tsv', required=True, help='Path to sentence_usage_analysis.tsv')
    ap.add_argument('--anki-url', default='http://127.0.0.1:8765')
    ap.add_argument('--model', default='Sentence Usage Atomic Unit')
    ap.add_argument('--deck-output', default='English::Expression Output')
    ap.add_argument('--deck-review', default='English::Expression Review')
    args = ap.parse_args()

    tsv = Path(args.tsv)
    if not tsv.exists():
        raise SystemExit(f'TSV not found: {tsv}')
    with tsv.open(encoding='utf-8', newline='') as f:
        rows = list(csv.DictReader(f, delimiter='\t'))
    if not rows:
        raise SystemExit('TSV has no rows')
    missing = [field for field in INPUT_REQUIRED if field not in rows[0]]
    if missing:
        raise SystemExit('Missing TSV fields: ' + ', '.join(missing))

    anki = Anki(args.anki_url)
    version = anki.invoke('version')
    for deck in (args.deck_output, args.deck_review):
        anki.invoke('createDeck', {'deck': deck})
    model_name, model_created = compatible_model(anki, args.model)

    notes = []
    for row in rows:
        review = row.get('needs_review') == 'true'
        deck = args.deck_review if review else args.deck_output
        tags = [clean_tag(t) for t in row.get('tags', '').split(';')]
        tags += ['anki_import::sentence_usage_analysis', 'needs_review::' + str(review).lower(), clean_tag('unit_type::' + row.get('unit_type', 'unknown'))]
        fields = {field: clean_field(row.get(field, '')) for field in FIELDS}
        fields['import_id'] = make_import_id(row)
        fields['tags_source'] = clean_field(row.get('tags', ''))
        notes.append({'deckName': deck, 'modelName': model_name, 'fields': fields, 'tags': [t for t in dict.fromkeys(tags) if t], 'options': {'allowDuplicate': False, 'duplicateScope': 'collection'}})

    added = skipped = failed = 0
    for batch in chunks(notes, 50):
        can = anki.invoke('canAddNotes', {'notes': batch})
        todo = [note for note, ok in zip(batch, can) if ok]
        skipped += len(batch) - len(todo)
        if not todo:
            continue
        results = anki.invoke('addNotes', {'notes': todo})
        for result in results:
            if result is None:
                failed += 1
            else:
                added += 1

    print(json.dumps({'anki_version': version, 'model_name': model_name, 'model_created': model_created, 'deck_output': args.deck_output, 'deck_review': args.deck_review, 'tsv_rows': len(rows), 'notes_added': added, 'notes_skipped_duplicate_or_invalid': skipped, 'notes_failed': failed}, ensure_ascii=False, indent=2))
    return 1 if failed else 0

if __name__ == '__main__':
    sys.exit(main())
