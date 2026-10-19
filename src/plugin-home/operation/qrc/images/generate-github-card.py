#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
# SPDX-License-Identifier: GPL-3.0-or-later
"""生成主页「项目主页」卡片的背景图。

卡片在 QML 里的逻辑尺寸是 360x158（HomeView.qml 的 projectCard.implicitHeight），
这里按 2 倍出图（640x320），由 Image 的 PreserveAspectCrop 缩放/裁切。

内容：暗色渐变底 + 右上角蓝色光晕 + 淡网格 + 三条 git 分支线（带提交点）。
全部是装饰，卡片上的文字由 QML 画，方便翻译。

用法：
    python3 generate-github-card.py
依赖：Pillow
"""
import math
import os

from PIL import Image, ImageDraw, ImageFilter

WIDTH, HEIGHT = 640, 320
# 卡片在 QML 里 radius 是 8px，图片会被 Stretch 到卡片大小，按最窄的卡片宽度
# 反算，这里留 28px 的圆角，缩到屏幕上约 9px，刚好盖住卡片自己的圆角
CORNER_RADIUS = 28
HERE = os.path.dirname(os.path.abspath(__file__))
OUTPUT = os.path.join(HERE, "home-github.png")

# 调色板：GitHub 暗色主题附近的一套颜色
BG_TOP = (13, 17, 23)
BG_BOTTOM = (20, 28, 40)
GLOW = (31, 111, 235)
GRID = (255, 255, 255, 10)
BRANCH_MAIN = (88, 166, 255)
BRANCH_SIDE = (63, 185, 80)
BRANCH_ALT = (188, 140, 255)


def vertical_gradient(size, top, bottom):
    width, height = size
    grad = Image.new("RGB", (1, height))
    px = grad.load()
    for y in range(height):
        t = y / max(1, height - 1)
        px[0, y] = tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
    return grad.resize(size, Image.BILINEAR)


def radial_glow(size, center, radius, color, max_alpha):
    width, height = size
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    px = layer.load()
    cx, cy = center
    for y in range(height):
        for x in range(width):
            d = math.hypot(x - cx, y - cy) / radius
            if d >= 1.0:
                continue
            alpha = int(max_alpha * (1.0 - d) ** 2)
            if alpha > 0:
                px[x, y] = (color[0], color[1], color[2], alpha)
    return layer


def draw_grid(draw, size, step, color):
    width, height = size
    for x in range(0, width + step, step):
        draw.line([(x, 0), (x, height)], fill=color, width=1)
    for y in range(0, height + step, step):
        draw.line([(0, y), (width, y)], fill=color, width=1)


def bezier(p0, p1, p2, p3, steps=180):
    points = []
    for i in range(steps + 1):
        t = i / steps
        mt = 1 - t
        x = mt ** 3 * p0[0] + 3 * mt ** 2 * t * p1[0] + 3 * mt * t ** 2 * p2[0] + t ** 3 * p3[0]
        y = mt ** 3 * p0[1] + 3 * mt ** 2 * t * p1[1] + 3 * mt * t ** 2 * p2[1] + t ** 3 * p3[1]
        points.append((x, y))
    return points


def draw_branch(layer, curve, color, width=4, dots=()):
    draw = ImageDraw.Draw(layer)
    draw.line(curve, fill=color + (170,), width=width, joint="curve")
    for cx, cy, r in dots:
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=color + (235,))


def main():
    base = vertical_gradient((WIDTH, HEIGHT), BG_TOP, BG_BOTTOM).convert("RGBA")

    glow = radial_glow((WIDTH, HEIGHT), (int(WIDTH * 0.80), int(HEIGHT * 0.10)), WIDTH * 0.62, GLOW, 120)
    glow = glow.filter(ImageFilter.GaussianBlur(18))
    base = Image.alpha_composite(base, glow)

    grid_layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    draw_grid(ImageDraw.Draw(grid_layer), (WIDTH, HEIGHT), 24, GRID)
    base = Image.alpha_composite(base, grid_layer)

    branches = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    # 主线：从左下角外侧起，向右上斜穿；左下角（文字区）保持干净，不放提交点
    main_curve = bezier((-40, HEIGHT - 18), (150, HEIGHT - 60), (330, 96), (WIDTH - 24, 64))
    draw_branch(branches, main_curve, BRANCH_MAIN, width=4,
                dots=[(WIDTH - 24, 64, 7), (330, 96, 6)])
    # 分支：从主线分出，向右下再并回右上
    side_curve = bezier((250, 116), (330, 150), (330, 232), (WIDTH - 96, 236))
    draw_branch(branches, side_curve, BRANCH_SIDE, width=3,
                dots=[(250, 116, 5), (WIDTH - 96, 236, 5)])
    merge_curve = bezier((WIDTH - 96, 236), (WIDTH - 56, 236), (WIDTH - 44, 190), (WIDTH - 30, 148))
    draw_branch(branches, merge_curve, BRANCH_SIDE, width=3, dots=[(WIDTH - 30, 148, 5)])

    alt_curve = bezier((150, 54), (240, 54), (270, 92), (330, 96))
    draw_branch(branches, alt_curve, BRANCH_ALT, width=3, dots=[(150, 54, 5)])

    branches = branches.filter(ImageFilter.GaussianBlur(0.6))
    base = Image.alpha_composite(base, branches)

    # 圆角：卡片本身是圆角矩形，图片铺满整张卡，四角交给 alpha 处理
    mask = Image.new("L", (WIDTH, HEIGHT), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, WIDTH - 1, HEIGHT - 1], radius=CORNER_RADIUS, fill=255
    )
    base.putalpha(mask)

    base.save(OUTPUT, "PNG")
    print("written", OUTPUT, base.size, base.mode)


if __name__ == "__main__":
    main()

