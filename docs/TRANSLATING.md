# 翻译

## 文件位置

- 主程序与插件的翻译：`translations/dde-control-center_<locale>.ts`。
- 桌面条目（`.desktop`）的翻译：`translations/desktop/*.ts`，由 `misc/translate_ts2desktop.sh` 在 configure 阶段写回 desktop 文件；不要手工改 desktop 里的翻译行。

## 命名约定

- `<locale>` 统一写成 `language_TERRITORY`，如 `zh_CN`、`af_ZA`、`am_ET`。
- 同一个语言不要同时保留裸语言码与带地区码两份文件：已经有 `pt_BR` 就不要再加 `pt`，两份文件会互相覆盖。
- 文件内 `<TS language="...">` 必须与文件名里的 locale 一致；缺这个属性时，Qt 与 Weblate 都判断不出文件对应哪种语言。

## 不要改的内容

- 不改 `source`、`context`/`name` 与 `comment`：翻译以它们为键，改了就对不上代码里的字符串。需要改源字符串时先改 QML/C++，再由 `lupdate` 重新生成。
- 只填 `translation`，未翻译的条目保留 `type="unfinished"`。
- 不要手工加 `<location>` 行：`lupdate` 以 `-locations none` 运行。

## 编译与装载

`Release` 配置在 configure 阶段调用 `misc/translate_generation.sh`，对每个 `.ts` 调用 `lrelease` 生成同名 `.qm`，安装到 `/usr/share/dde-control-center/translations/v1.1/`；运行时不直接读 `.ts`。不要提交 `.qm`。

## 通过 Weblate 翻译

Weblate 项目入口：待补充（项目建立后在此填写地址）。

- 只翻译 `translations/dde-control-center_<locale>.ts`，不要新建平行目录，也不要手工合并文件。
- 评审在 Weblate 内完成，不需要在 GitHub 另开 PR。
- 以 Weblate 的提交为准，不要本地改完再提 PR。
