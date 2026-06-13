#!/usr/bin/env python3
# Update Sentence Usage Atomic Unit templates for front answer entry and ChatGPT copy.
import argparse
import difflib
import json
import re
import urllib.request
from datetime import datetime
from pathlib import Path

REQUIRED_FIELDS = ['import_id', 'trigger_zh', 'atomic_unit', 'personal_example', 'sentence', 'appreciation_zh']

class Anki:
    def __init__(self, url):
        self.url = url.rstrip('/')
    def invoke(self, action, params=None, timeout=60):
        payload = json.dumps({'action': action, 'version': 6, 'params': params or {}}).encode('utf-8')
        req = urllib.request.Request(self.url, payload, {'Content-Type': 'application/json'})
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            data = json.loads(resp.read().decode('utf-8'))
        if data.get('error') is not None:
            raise RuntimeError(f'{action}: {data["error"]}')
        return data.get('result')

def fenced(lang, text):
    return f'```{lang}\n{text}\n```'

def render_backup(title, model, fields, templates, css):
    lines = [f'# {title}', '', '## Note Type', '', model, '', '## Fields', '']
    lines.extend(f'- {field}' for field in fields)
    lines.extend(['', '## Styling', '', fenced('css', css), ''])
    for i, (name, tmpl) in enumerate(templates.items(), 1):
        lines.extend([f'## Card {i}: {name}', '', '### Front Template', '', fenced('html', tmpl.get('Front', tmpl.get('qfmt', ''))), '', '### Back Template', '', fenced('html', tmpl.get('Back', tmpl.get('afmt', ''))), ''])
    return '\n'.join(lines).rstrip() + '\n'

def build_front_block(key):
    return f'''
<div class="answer-entry-panel">
  <div class="answer-entry-label">My answer</div>
  <textarea id="sua-my-answer" class="answer-entry-box" placeholder="Type your answer here before showing the back." oninput="try{{localStorage.setItem('{key}', this.value);}}catch(e){{}}" onclick="try{{if(!this.dataset.loaded){{this.value=localStorage.getItem('{key}')||this.value;this.dataset.loaded='1';}}}}catch(e){{}}" onfocus="try{{if(!this.dataset.loaded){{this.value=localStorage.getItem('{key}')||this.value;this.dataset.loaded='1';}}}}catch(e){{}}"></textarea>
  <div class="answer-entry-hint">Saved locally for this card copy only. It does not change the note.</div>
  <img alt="" class="answer-cache-reset" src="anki-sua-clear://{{{{text:import_id}}}}" onerror="try{{var el=document.getElementById('sua-my-answer'); if(!el || !el.value){{localStorage.setItem('{key}','');}}}}catch(e){{}} this.onerror=null;">
</div>
'''.strip()

def build_copy_block(key):
    rest = '''trigger_zh:\n{{text:trigger_zh}}\n\natomic_unit:\n{{text:atomic_unit}}\n\npersonal_example:\n{{text:personal_example}}\n\nsentence:\n{{text:sentence}}\n\nappreciation_zh:\n{{text:appreciation_zh}}'''
    full = '''my_answer:\n\ntrigger_zh:\n{{text:trigger_zh}}\n\natomic_unit:\n{{text:atomic_unit}}\n\npersonal_example:\n{{text:personal_example}}\n\nsentence:\n{{text:sentence}}\n\nappreciation_zh:\n{{text:appreciation_zh}}'''
    js = (
        "(function(btn){"
        "var root=btn.parentNode;var payload=root.querySelector('.copy-payload-manual');var rest=root.querySelector('.copy-payload-rest');var status=root.querySelector('.copy-status');var details=root.querySelector('.copy-manual');"
        f"var key='{key}';var nl=String.fromCharCode(10);"
        "function set(t){if(status){status.textContent=t;}}"
        "function refreshPayload(){var answer='';try{answer=localStorage.getItem(key)||'';}catch(e){answer='';}if(payload){payload.value='my_answer:'+nl+answer+nl+nl+(rest?rest.value:'');}}"
        "function reveal(){refreshPayload();if(details){details.setAttribute('open','open');}if(payload){payload.focus();payload.select();if(payload.setSelectionRange){payload.setSelectionRange(0,payload.value.length);}}}"
        "function execCopy(text){var temp=document.createElement('textarea');temp.value=text;temp.setAttribute('readonly','readonly');temp.style.position='fixed';temp.style.left='0';temp.style.top='0';temp.style.width='2em';temp.style.height='2em';temp.style.padding='0';temp.style.border='0';temp.style.outline='0';temp.style.boxShadow='none';temp.style.background='transparent';temp.style.opacity='0.01';document.body.appendChild(temp);temp.focus();temp.select();if(temp.setSelectionRange){temp.setSelectionRange(0,temp.value.length);}var ok=false;try{ok=document.execCommand&&document.execCommand('copy');}catch(e){ok=false;}document.body.removeChild(temp);return ok;}"
        "function fail(){reveal();set('Copy failed. Text selected below; press Ctrl+C / Cmd+C.');}"
        "refreshPayload();var text=payload?payload.value:'';try{if(navigator.clipboard&&navigator.clipboard.writeText){navigator.clipboard.writeText(text).then(function(){set('Copied.');}).catch(function(){if(execCopy(text)){set('Copied.');}else{fail();}});return;}}catch(e){}if(execCopy(text)){set('Copied.');}else{fail();}"
        "})(this);return false;"
    )
    return f'''
<div class="copy-panel">
  <a id="copy-card-info" class="copy-button" href="#" onclick="{js}">Copy for ChatGPT</a>
  <span class="copy-status" aria-live="polite">Ready.</span>
  <textarea class="copy-payload-rest" readonly>{rest}</textarea>
  <details class="copy-manual">
    <summary>Manual copy text</summary>
    <textarea class="copy-payload-manual" readonly onclick="this.focus(); this.select(); if (this.setSelectionRange) this.setSelectionRange(0, this.value.length);">{full}</textarea>
  </details>
</div>
'''.strip()

CSS_BLOCK = '''
.answer-entry-panel { margin-top: 18px; padding-top: 14px; border-top: 1px solid #d7dde5; }
.answer-entry-label { color: #64748b; font-size: 14px; font-weight: 650; text-transform: uppercase; letter-spacing: 0; margin-bottom: 6px; }
.answer-entry-box { box-sizing: border-box; width: 100%; min-height: 110px; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; color: #111827; background: #ffffff; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; font-size: 17px; line-height: 1.45; }
.answer-entry-hint { margin-top: 6px; color: #64748b; font-size: 13px; }
.answer-cache-reset { display: none; }
.copy-panel { margin-top: 18px; padding-top: 14px; border-top: 1px solid #d7dde5; }
.copy-button { display: inline-block; appearance: none; border: 1px solid #0f766e; border-radius: 6px; background: #0f766e; color: #ffffff !important; font-size: 16px; font-weight: 650; line-height: 1.2; padding: 10px 14px; text-decoration: none; }
.copy-button:active { background: #115e59; }
.copy-status { display: inline-block; min-height: 20px; margin-left: 10px; color: #64748b; font-size: 14px; vertical-align: middle; }
.copy-payload-rest { position: absolute; left: -9999px; top: auto; width: 1px; height: 1px; opacity: 0; }
.copy-manual { margin-top: 10px; color: #64748b; font-size: 14px; }
.copy-manual summary { cursor: pointer; }
.copy-payload, .copy-payload-manual { box-sizing: border-box; width: 100%; min-height: 220px; margin-top: 10px; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; opacity: 1; color: #111827; background: #ffffff; font-family: ui-monospace, SFMono-Regular, Consolas, "Liberation Mono", monospace; font-size: 14px; line-height: 1.45; white-space: pre-wrap; }
'''.strip()

def remove_class_blocks(css):
    for cls in ['answer-entry-panel','answer-entry-label','answer-entry-box','answer-entry-hint','answer-cache-reset','copy-panel','copy-button','copy-status','copy-payload','copy-payload-visible','copy-manual','copy-payload-rest']:
        css = re.sub(r'\n?\.' + re.escape(cls) + r'(?:\s+summary)?\s*\{.*?\}\s*', '\n', css, flags=re.S)
    return css

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--anki-url', default='http://127.0.0.1:8765')
    ap.add_argument('--model', default='Sentence Usage Atomic Unit')
    ap.add_argument('--template', default='Output - Trigger to Expression')
    ap.add_argument('--backup-dir', default='anki_template_backups')
    args = ap.parse_args()

    anki = Anki(args.anki_url)
    if args.model not in anki.invoke('modelNames'):
        raise SystemExit(f'Missing note type: {args.model}')
    fields = anki.invoke('modelFieldNames', {'modelName': args.model})
    missing = [field for field in REQUIRED_FIELDS if field not in fields]
    if missing:
        raise SystemExit('Missing required fields: ' + ', '.join(missing))
    templates = anki.invoke('modelTemplates', {'modelName': args.model})
    if args.template not in templates:
        raise SystemExit(f'Missing card template: {args.template}')
    css = anki.invoke('modelStyling', {'modelName': args.model}).get('css', '')

    backup_dir = Path(args.backup_dir)
    backup_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    stem = args.model.replace(' ', '_')
    before_path = backup_dir / f'anki_template_backup_{stem}_{stamp}.md'
    after_path = backup_dir / f'anki_template_after_{stem}_{stamp}.md'
    diff_path = backup_dir / f'anki_template_diff_{stem}_{stamp}.diff'
    before = render_backup(f'{args.model} Template Backup', args.model, fields, templates, css)
    before_path.write_text(before, encoding='utf-8')

    key = 'sua_my_answer_{{text:import_id}}'
    target = templates[args.template]
    front = re.sub(r'\n?<div class="answer-entry-panel">.*?</div>\s*', '', target.get('Front', target.get('qfmt','')), flags=re.S)
    target['Front'] = front.rstrip() + '\n\n' + build_front_block(key) + '\n'
    if 'qfmt' in target:
        target['qfmt'] = target['Front']
    back = target.get('Back', target.get('afmt',''))
    start = back.find('<div class="copy-panel">')
    if start != -1:
        back = back[:start].rstrip()
    target['Back'] = back.rstrip() + '\n\n' + build_copy_block(key) + '\n'
    if 'afmt' in target:
        target['afmt'] = target['Back']

    new_css = remove_class_blocks(css).rstrip() + '\n\n' + CSS_BLOCK + '\n'
    anki.invoke('updateModelTemplates', {'model': {'name': args.model, 'templates': templates}})
    anki.invoke('updateModelStyling', {'model': {'name': args.model, 'css': new_css}})

    final_templates = anki.invoke('modelTemplates', {'modelName': args.model})
    final_css = anki.invoke('modelStyling', {'modelName': args.model}).get('css', '')
    after = render_backup(f'{args.model} Template After', args.model, fields, final_templates, final_css)
    after_path.write_text(after, encoding='utf-8')
    diff_path.write_text(''.join(difflib.unified_diff(before.splitlines(True), after.splitlines(True), fromfile=str(before_path), tofile=str(after_path))), encoding='utf-8')

    print(json.dumps({'status': 'updated', 'model': args.model, 'template': args.template, 'front_has_atomic_unit': 'atomic_unit' in final_templates[args.template].get('Front',''), 'front_has_answer_box': 'sua-my-answer' in final_templates[args.template].get('Front',''), 'back_reads_saved_answer': 'localStorage.getItem' in final_templates[args.template].get('Back',''), 'backup_file': str(before_path), 'after_file': str(after_path), 'diff_file': str(diff_path)}, ensure_ascii=False, indent=2))

if __name__ == '__main__':
    main()
