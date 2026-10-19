# 参与贡献

## 问题与讨论

- 报缺陷、提需求：<https://github.com/LingmoOS/lingmo-control-center/issues>。请写清复现步骤、期望结果与实际结果，并附上系统版本与 `dde-control-center --version` 的输出。
- 提交代码：向 `main` 分支发起 PR，地址 <https://github.com/LingmoOS/lingmo-control-center/pulls>。

## 代码风格

- 沿用仓库根目录的 `.clang-format` 与 `.editorconfig`，提交前格式化改动过的文件。
- **不要在一个 PR 里混入无关的格式化**：整文件重排、换行或空格风格变更会把真正的改动淹掉；需要整理格式时单独开一个只做格式化的 PR。
- 一个 PR 只做一件事，修缺陷与重构分开提，便于评审。

## 新增插件

按 README 第 3 节「插件架构」的步骤做：

1. 建 `src/plugin-foo/CMakeLists.txt`，写 `dcc_install_plugin(NAME ${FOO_NAME})`；需要 C++ 后端时再加 `add_library(... MODULE ...)` 与 `TARGET`。
2. 写 `qml/Foo.qml`（模块对象）与 `qml/FooMain.qml`（主对象）。
3. 在顶层 `CMakeLists.txt` 的插件列表里加 `add_subdirectory(src/plugin-foo)`。
4. 用户可见字符串用 `qsTr()`（QML）或 `tr()`（C++），随后更新 `translations/`。

不要绕过 `dcc_install_plugin` 手工写安装规则。完整可构建的示例见 `examples/plugin-example/`（`-DBUILD_EXAMPLES=ON`）。

## 翻译

翻译文件的命名、放置与 Weblate 流程见 [docs/TRANSLATING.md](docs/TRANSLATING.md)。

## 许可证

提交的代码按 [README](README.md) 第 5 节授权，即 `GPL-3.0-or-later`。引入其它许可证的代码或素材时，在文件头标注 SPDX 标识，并把许可证文本放进 `LICENSES/`。
