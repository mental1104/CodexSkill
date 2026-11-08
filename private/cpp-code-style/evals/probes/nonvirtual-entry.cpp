/// 表示公共守卫、后端钩子与同名派生方法的三种可观察路径。
enum class Outcome { Rejected, ReachedHook, Bypassed };

/// 仅用于核查非虚公共入口的语言语义，不实现实际解析功能。
class Parser {
public:
    /// 允许经基类销毁测试对象，无额外资源。
    virtual ~Parser() = default;

    /// 对非法输入短路，再委派给后端钩子。
    /// @param valid 是否满足本探针的输入契约，不发生所有权转移。
    /// @return 非法输入返回 Rejected，合法输入返回钩子的结果。
    Outcome parse(bool valid) const {
        // 守卫必须先于后端，供基类路径与具体类型路径对比。
        if (!valid) return Outcome::Rejected;
        return do_parse();
    }

private:
    /// 表示已经进入后端，不负责重复输入守卫。
    /// @return 本探针的后端路径标识。
    virtual Outcome do_parse() const = 0;
};

/// 以同签名方法检验具体类型调用是否仍能绕过公共守卫。
class Backend final : public Parser {
public:
    /// 故意隐藏基类非虚方法；final 版本应拒绝此定义。
    /// @param valid 刻意忽略，用于观察绕过守卫的路径。
    /// @return 固定返回 Bypassed。
    Outcome parse(bool /*valid*/) const { return Outcome::Bypassed; }

private:
    /// 完成满足基类接口所需的后端钩子。
    /// @return 固定返回 ReachedHook。
    Outcome do_parse() const override { return Outcome::ReachedHook; }
};

/// 比较基类引用与具体派生类型对同一非法输入的调用。
/// @return 两条路径分别观察到守卫与绕过时返回 0，否则返回 1。
int main() {
    const Backend concrete;
    const Parser& base = concrete;
    return base.parse(false) == Outcome::Rejected &&
                   concrete.parse(false) == Outcome::Bypassed
               ? 0
               : 1;
}
