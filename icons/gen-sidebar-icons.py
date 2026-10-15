#!/usr/bin/env python3
# 侧栏图标生成脚本：从 Tabler Icons (MIT) 取单色 SVG，重新着色为黑/白三态变体。
# 生成的 SVG 位于 icons/sidebar/，安装到 /usr/share/dde-control-center/icons/sidebar/。
import os, re, urllib.request

R = "/home/lingmo/dde/lingmo-control-center"
OUT = f"{R}/icons/sidebar"
SCRIPT_OUT = f"{R}/icons/gen-sidebar-icons.py"
BASE = "https://raw.githubusercontent.com/tabler/tabler-icons/main/icons/outline/{}.svg"

ICONS = {
    "home":             ["home"],
    "system":           ["settings"],
    "device":           ["devices"],
    "network":          ["wifi"],
    "personalization":  ["palette"],
    "apps":             ["apps"],
    "accounts":         ["user-circle"],
    "notification":     ["bell"],
    "keyboardAndMouse": ["keyboard"],
    "timeAndLanguage":  ["clock"],
    "accessibility":    ["accessible"],
    "privacy":          ["shield-lock"],
    "power":            ["battery-charging"],
    "update":           ["refresh"],
}

VARIANTS = {          # 后缀: 颜色
    "light":    "#1A1A1A",   # 亮色主题：黑
    "dark":     "#FFFFFF",   # 暗色主题：白
    "selected": "#FFFFFF",   # 选中：恒白
}

def fetch(name):
    with urllib.request.urlopen(BASE.format(name), timeout=30) as r:
        return r.read().decode("utf-8")

def make(svg, color):
    body = re.sub(r"<!--.*?-->", "", svg, flags=re.S).strip()
    m = re.search(r"<svg[^>]*>(.*)</svg>", body, re.S)
    inner = m.group(1).strip()
    inner = inner.replace("currentColor", color)
    inner = re.sub(r'stroke="(?!none)[^"]*"', f'stroke="{color}"', inner)
    inner = re.sub(r'fill="(?!none)[^"]*"', f'fill="{color}"', inner)
    head = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">'
    g = f'  <g stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">\n    {inner}\n  </g>'
    return f"{head}\n{g}\n</svg>\n"

def main():
    os.makedirs(OUT, exist_ok=True)
    src = {}
    for dde, cands in ICONS.items():
        for c in cands:
            try:
                src[dde] = (c, fetch(c)); break
            except Exception as e:
                print(f"  · {dde}/{c} 失败: {type(e).__name__}")
    for dde, (tabler_name, svg) in src.items():
        for suffix, color in VARIANTS.items():
            open(os.path.join(OUT, f"{dde}-{suffix}.svg"), "w", encoding="utf-8", newline="\n").write(make(svg, color))
        print(f"  ✓ {dde:<18} <- tabler/{tabler_name:<18} 黑白 3 变体")
    # 生成脚本入库（记录对上游 SVG 的修改）
    me = open(__file__, encoding="utf-8").read()
    open(SCRIPT_OUT, "w", encoding="utf-8", newline="\n").write(
        "#!/usr/bin/env python3\n"
        "# 侧栏图标生成脚本：从 Tabler Icons (MIT) 取单色 SVG，重新着色为黑/白三态变体。\n"
        "# 生成的 SVG 位于 icons/sidebar/，安装到 /usr/share/dde-control-center/icons/sidebar/。\n"
        + me.split('"""', 2)[2].lstrip("\n"))
    print(f"\n  文件: {len(os.listdir(OUT))} 个 SVG")
    print(f"  生成脚本: {SCRIPT_OUT}")
    print(f"  底色块已移除 -> 纯黑/白单色 ✅")

if __name__ == "__main__":
    main()
