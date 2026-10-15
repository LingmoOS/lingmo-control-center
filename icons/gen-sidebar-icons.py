#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""修正版：颜色放在 <g> 上（路径继承），线宽用 Tabler 原生 2；纯黑白无底色"""
import os, re, urllib.request

R = "/home/lingmo/dde/lingmo-control-center"
OUT = f"{R}/icons/sidebar"
SCRIPT = f"{R}/icons/gen-sidebar-icons.py"
BASE = "https://raw.githubusercontent.com/tabler/tabler-icons/main/icons/outline/{}.svg"

ICONS = {
    "home": ["home"], "system": ["settings"], "device": ["devices"], "network": ["wifi"],
    "personalization": ["palette"], "apps": ["apps"], "accounts": ["user-circle"],
    "notification": ["bell"], "keyboardAndMouse": ["keyboard"], "timeAndLanguage": ["clock"],
    "accessibility": ["accessible"], "privacy": ["shield-lock"],
    "power": ["battery-charging"], "update": ["refresh"],
}
VARIANTS = {"light": "#1A1A1A", "dark": "#FFFFFF", "selected": "#FFFFFF"}

def fetch(name):
    with urllib.request.urlopen(BASE.format(name), timeout=30) as r:
        return r.read().decode("utf-8")

def make(svg, color):
    body = re.sub(r"<!--.*?-->", "", svg, flags=re.S).strip()
    inner = re.search(r"<svg[^>]*>(.*)</svg>", body, re.S).group(1).strip()
    # 逐条路径统一颜色（防止个别 stroke 覆盖）
    inner = inner.replace("currentColor", color)
    inner = re.sub(r'\bstroke="(?!none)[^"]*"', f'stroke="{color}"', inner)
    inner = re.sub(r'\bfill="(?!none)[^"]*"', f'fill="{color}"', inner)
    # 关键：颜色与线宽放在 <g> 上，路径继承（Tabler 原生在根 <svg> 上）
    return ('<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
            'viewBox="0 0 24 24" fill="none">\n'
            f'  <g stroke="{color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">\n'
            f'    {inner}\n  </g>\n</svg>\n')

def main():
    os.makedirs(OUT, exist_ok=True)
    for dde, cands in ICONS.items():
        svg = None; used = None
        for c in cands:
            try:
                svg = fetch(c); used = c; break
            except Exception:
                pass
        if not svg:
            print(f"  ✗ {dde} 取不到"); continue
        for suffix, color in VARIANTS.items():
            open(os.path.join(OUT, f"{dde}-{suffix}.svg"), "w", encoding="utf-8", newline="\n").write(make(svg, color))
        print(f"  ✓ {dde:<18} <- tabler/{used:<18} 纯黑白 3 变体")
    # 生成脚本入库
    src = open(__file__, encoding="utf-8").read()
    open(SCRIPT, "w", encoding="utf-8", newline="\n").write(src)
    print(f"\n  共 {len(os.listdir(OUT))} 个 SVG")
    # 自检：颜色是否写入
    t = open(os.path.join(OUT, "home-light.svg"), encoding="utf-8").read()
    print("  自检 home-light 含 stroke=\"#1A1A1A\":", 'stroke="#1A1A1A"' in t)
    t2 = open(os.path.join(OUT, "home-dark.svg"), encoding="utf-8").read()
    print("  自检 home-dark  含 stroke=\"#FFFFFF\":", 'stroke="#FFFFFF"' in t2)

if __name__ == "__main__":
    main()
