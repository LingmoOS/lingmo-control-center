# Lingmo 控制中心

Lingmo OS 的系统设置中心，使用 Qt 6 与 QML 编写。主程序提供窗口、侧栏导航、搜索和插件装载；每个设置页是一个插件，可以独立构建、独立安装。插件是一份 Qt QML 模块，可以只含 QML，也可以带一个 C++ 后端，通过 `DccFactory` 把数据对象导出给 QML 使用。

- 代码仓库：<https://github.com/LingmoOS/lingmo-control-center>
- 许可证：GPL-3.0-or-later，全文见 [LICENSE](LICENSE)
- 插件接口说明：`docs/v25-dcc-interface.zh_CN.md`

## 目录结构

| 路径 | 内容 |
| --- | --- |
| `CMakeLists.txt` | 顶层构建脚本；依赖查找、安装目录、插件列表（`add_subdirectory(src/plugin-*)`）都在这里 |
| `src/dde-control-center/` | 主程序、`DccObject`/`DccManager`/`DccPluginLoader` 等框架代码，以及 QML 模块 `org.deepin.dcc` |
| `src/plugin-*/` | 功能插件，一个目录一个插件 |
| `src/shared-utils/` | 插件共用的工具代码（`DCCLocale` 等） |
| `include/` | 公共头文件，主要是 `dccfactory.h` |
| `misc/` | 插件 CMake 宏、desktop/D-Bus/systemd 模板、翻译脚本、配置文件 |
| `translations/` | 主程序翻译（`*.ts`），另有 `translations/desktop/` 存放桌面条目的翻译 |
| `docs/` | 插件接口文档，`BUILD_DOCS=ON` 时由 Doxygen 生成 |
| `examples/plugin-example/` | 外部插件示例，同时演示 `find_package(DdeControlCenter)` 的用法 |
| `icons/sidebar/` | 侧栏图标（Tabler，MIT） |
| `debian/`、`archlinux/`、`rpm/` | 打包文件 |

## 1. 功能与插件

| 插件目录 | QML 模块 | 功能 |
| --- | --- | --- |
| `src/plugin-home` | `home` | 主页：常用设置的入口卡片 |
| `src/plugin-system` | `system` | “系统”分组项，本身不含设置页 |
| `src/plugin-commoninfo` | `commonInfo` | 启动菜单（GRUB）、开发者选项 |
| `src/plugin-display` | `display` | 显示：分辨率、缩放、屏幕排列、超时 |
| `src/plugin-sound` | `sound` | 声音：输出/输入设备、音量、音效、设备管理 |
| `src/plugin-datetime` | `datetime` | 时间日期、时区、语言与区域格式 |
| `src/plugin-device` | `device` | “蓝牙和其它设备”分组项，本身不含设置页 |
| `src/plugin-bluetooth` | `blueTooth` | 蓝牙适配器与设备 |
| `src/plugin-touchscreen` | `touchscreen` | 触摸屏映射 |
| `src/plugin-wacom` | `wacom` | 数位板 |
| `src/plugin-keyboard` | `keyboard` | 键盘布局、重复速率、快捷键 |
| `src/plugin-mouse` | `mouse` | 鼠标与触控板：指针速度、自然滚动、手势 |
| `src/plugin-personalization` | `personalization` | 主题、图标、字体、壁纸、窗口效果 |
| `src/plugin-dock` | `dock` | 桌面与任务栏：位置、大小、插件区域 |
| `src/plugin-panel` | `panel` | 经典任务栏；顶层构建脚本中未启用 |
| `src/plugin-accessibility` | `accessibility` | 无障碍选项 |
| `src/plugin-notification` | `notification` | 通知与免打扰时段 |
| `src/plugin-power` | `power` | 电源计划、电池、计划关机 |
| `src/plugin-accounts` | `accounts` | 账户、头像、密码、登录方式 |
| `src/plugin-authentication` | `authentication` | 生物识别：指纹、人脸、虹膜 |
| `src/plugin-defaultapp` | `defaultapp` | 默认应用 |
| `src/plugin-systeminfo` | `systemInfo` | 关于本机、最终用户许可协议、隐私政策、用户体验计划 |
| `src/plugin-privacy` | `privacy` | 摄像头、文件与文件夹的访问权限 |
| `src/plugin-deepinid` | `deepinid` | 云账号登录与同步；默认不编译 |

侧栏是一棵 `DccObject` 树：`parentName` 为 `"root"` 的对象是顶层项，`parentName` 指向分组（如 `system`、`device`、`personalization`、`apps`）的对象挂在对应分组下，同层顺序由 `weight` 决定。`system` 与 `device` 两个分组插件先于其它插件加载（`src/dde-control-center/pluginmanager.cpp:163`）。

`plugin-system`、`plugin-device` 只有 QML，没有 C++ 后端；其余插件各有一个 `MODULE` 库作为后端。

## 2. 构建

### 依赖

完整列表见 `debian/control` 的 `Build-Depends` 与 `Depends`，主要分为：

- 构建工具：`cmake`（顶层声明 3.18，`misc/DdeControlCenterPluginMacros.cmake:1` 要求 3.23）、`pkg-config`、`extra-cmake-modules`、C++17 编译器；`doxygen` 只在 `BUILD_DOCS=ON` 时需要。
- Qt 6：`qt6-base-dev`、`qt6-declarative-dev`、`qt6-tools-dev`（提供 `lrelease`）、`qt6-multimedia-dev`、`qt6-wayland-dev`、`libqt6svg6`。Qt 6.10 及以上还会查找 GuiPrivate、QmlModelsPrivate、QuickPrivate、WaylandClientPrivate（`CMakeLists.txt:11-13,183-185`），需要对应的私有开发包；`debian/control` 目前列了 `qt6-base-private-dev`、`qt6-declarative-private-dev` 与 `qt6-wayland-private-dev`。
- DTK6：`libdtk6core-dev`、`libdtk6gui-dev`（≥ 6.0.21）、`libdtkcommon-dev`；运行时需要 `libdtk6declarative`。
- 其它：`libpolkit-qt6-1-dev`、`libsystemd-dev`、`libwayland-dev`、`wlr-protocols`、`treeland-protocols`（≥ 0.4.1）、`libicu-dev`、`libssl-dev`、`libgtest-dev`、`libdpkg-dev`、`libdareader-dev`、`libdeepin-pw-check-dev`、`libdde-shell-dev`、`deepin-gettext-tools`。

`libgtest-dev` 是必需项：顶层脚本无条件执行 `find_package(GTest REQUIRED)`（`CMakeLists.txt:186`），即使不构建测试也要装。

### 编译与安装

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
sudo cmake --install build
```

安装前缀默认是 `/usr`（`CMakeLists.txt:117-119`），可用 `-DCMAKE_INSTALL_PREFIX=...` 或 `DESTDIR` 改写。安装后可运行 `dde-control-center --show`；`--toggle` 切换显示与隐藏，`-h` 列出全部参数。

`Release` 配置在 configure 阶段会调用 `misc/translate_generation.sh` 和 `misc/translate_ts2desktop.sh`：前者用 `lrelease` 把 `translations/*.ts` 编译成 `.qm`，后者用 `deepin-desktop-ts-convert` 更新 desktop 条目的翻译。两个脚本失败时 CMake 不会中断，但 `.qm` 会缺失或为空，发布构建前需要确认工具可用。`Debug` 配置不做这一步，插件和 `.qm` 直接从构建目录读取（`CMakeLists.txt:140-143`），因此可以直接运行 `build/bin/dde-control-center`，此时插件位于 `build/lib/dde-control-center/plugins_v1.1`。

### 构建选项

| 选项 | 默认 | 作用 |
| --- | --- | --- |
| `DISABLE_AUTHENTICATION` | `OFF` | 不构建 `plugin-authentication` |
| `DISABLE_PRIVACY_PLUGIN` | `OFF` | 不构建 `plugin-privacy` |
| `DISABLE_DEEPIN_ID` | `ON` | 不构建 `plugin-deepinid` |
| `Enable_TreelandSupport` | `ON` | 为个性化、鼠标插件生成 Treeland 协议代码，需要 `treeland-protocols` |
| `BUILD_DOCS` | `OFF` | 构建 `docs/`，生成 Doxygen 文档 |
| `BUILD_TESTING` | `OFF` | 进入 `tests/`；该目录目前只有占位内容，尚未接入用例 |
| `BUILD_EXAMPLES` | `OFF` | 构建 `examples/plugin-example` |
| `ENABLE_ASAN` | `OFF` | `Debug` 下启用 AddressSanitizer |

其余选项与默认值见 `CMakeLists.txt:3-56`。

### 安装布局

以默认前缀 `/usr`、`libdir` 为 `/usr/lib` 为例：

| 路径 | 内容 |
| --- | --- |
| `/usr/bin/dde-control-center` | 主程序 |
| `/usr/lib/dde-control-center/plugins_v1.1/<module>/` | 插件：`qmldir`、QML 模块库、可选的 `<module>.so` |
| `/usr/lib/libdde-control-center.so*` | 框架库 |
| `/usr/include/dde-control-center/*.h` | 公共头文件 |
| `/usr/lib/cmake/DdeControlCenter/` | `find_package(DdeControlCenter)` 的配置文件与插件 CMake 宏 |
| `/usr/share/dde-control-center/translations/v1.1/*.qm` | 运行时装载的翻译 |
| `/usr/share/dde-control-center/icons/sidebar/*.svg` | 侧栏图标 |
| `/usr/share/applications/org.deepin.dde.control-center.desktop` | 桌面条目 |
| `/usr/share/dbus-1/services/org.deepin.dde.ControlCenter1.service` | D-Bus 激活 |
| `/usr/lib/systemd/user/org.deepin.dde.control-center.service` | 用户级 systemd 单元 |
| `/usr/share/metainfo/org.deepin.dde.controlcenter.metainfo.xml` | AppStream 元数据 |

此外还会安装 `dde-grand-search` 的 searcher 配置，以及 `misc/deepin-debug-config/`、`misc/deepin-log-config/` 下的调试与日志配置（`src/dde-control-center/CMakeLists.txt:142-150`）。

### 打包

```bash
sudo apt build-dep .
dpkg-buildpackage -uc -us -nc -b
```

`debian/` 产出三个二进制包：`dde-control-center`、`dde-control-center-dev`、`dde-control-center-doc`（`debian/control:44,69,79`）。主二进制包的包名仍为 `dde-control-center`，安装路径与文件名也沿用它，改名会破坏既有依赖关系。

`archlinux/PKGBUILD` 与 `rpm/velora-control-center.spec` 是另外两套打包文件，按各发行版的约定维护。

## 3. 插件架构

### 目录约定

一个插件对应 `src/plugin-<name>/`：

```
src/plugin-foo/
├── CMakeLists.txt      # set(FOO_NAME foo) + dcc_install_plugin(...)
├── qml/
│   ├── Foo.qml         # 模块对象，只负责侧栏条目
│   ├── FooMain.qml     # 主对象，页面树写在这里
│   └── *.qml           # 其它页面、对话框
└── operation/          # 可选的 C++ 后端
```

插件名只允许字母和数字（`misc/DdeControlCenterPluginMacros.cmake:23-25`），同时也是 QML 模块名与安装目录名，区分大小写（如 `systemInfo`、`blueTooth`）。QML 文件名必须首字母大写；`main.qml` 已废弃，出现时构建直接报错（`misc/DdeControlCenterPluginMacros.cmake:47-54`）。

### `<Name>.qml` 与 `<Name>Main.qml`

插件加载分两步，两步拿到的 QML 上下文不同：

| 文件 | 加载方式 | 可见的对象 | 职责 |
| --- | --- | --- | --- |
| `<Name>.qml` | `loadModule()`，`component.loadFromModule(<module>, <Name>)`，无额外上下文属性 | 只有 QML 内置对象 | 模块对象：`name`、`parentName`、`displayName`、`icon`、`weight`，即侧栏条目 |
| `<Name>Main.qml` | `loadMain()`，`component.loadFromModule(<module>, <Name>Main)`，注入上下文属性 `dccData`、`dccModule` | `dccData`：插件 C++ 后端的 `create()` 返回值；`dccModule`：模块对象 | 主对象：页面树、数据绑定、对话框 |

`dccData` 只挂在主对象的上下文里（`src/dde-control-center/dccpluginloader.cpp:383`），模块对象里没有它；在 `<Name>.qml` 中访问 `dccData` 会得到 `undefined`。纯分组插件（`device`、`system`）没有 C++ 后端，`dccData` 为空，只需要在 `<Name>Main.qml` 里放一个空的 `DccObject`。

v1.1 的加载器无条件要求 `<Name>Main.qml` 存在：`updateType()` 检测到插件目录含 `qmldir` 后同时置上 `T_HasModule | T_HasMain`，`loadMain()` 找不到 `<Name>Main` 类型就报 `Module "<module>" contains no named "<Name>Main"` 并进入 `MainObjError`（`src/dde-control-center/dccpluginloader.cpp:147-166,355-399`）。因此纯分组插件也必须有主对象文件。

### `dcc_install_plugin`

`dcc_install_plugin(NAME <module> [TARGET <target>])` 展开为 `dcc_build_plugin()` 加安装规则（`misc/DdeControlCenterPluginMacros.cmake:16-101`）：

- 用 `qt_add_qml_module()` 创建 URI 为 `<module>`、版本 1.0 的 QML 模块，输出到 `build/lib/dde-control-center/plugins_v1.1/<module>/`。
- 收集 `qml/` 下的 `.qml`、`.js`、`.dci`、`.svg`、`.png` 等文件作为模块资源。
- 安装 QML 模块库与 `qmldir` 到 `${CMAKE_INSTALL_LIBDIR}/dde-control-center/plugins_v1.1/<module>/`。
- 传了 `TARGET` 时，把该目标按 `MODULE` 库编译（`PREFIX ""`、`OUTPUT_NAME <module>`），输出 `<module>.so` 到同一目录并一并安装。
- 传了 `TARGET` 时还会把 `DCC_FACTORY_CLASS` 加入 AUTOMOC 扫描，避免 moc 警告。

安装目录由 `CMakeLists.txt:128-150` 决定：`DCC_PLUGINS_DIR` 为 `plugins_v1.1`，安装到 `${CMAKE_INSTALL_LIBDIR}/dde-control-center/`。

### 装载路径与顺序

- 启动时扫描 `${DefaultModuleDirectory}/plugins_v1.1` 与 `plugins_v1.0`（`src/dde-control-center/main.cpp:49-55`），前者为当前格式。
- 目录路径包含 `_v1.1` 时按 v1.1 解析，包含 `_v1.0` 时按 v1.0 解析（`src/dde-control-center/pluginmanager.cpp:171-178`）。
- v1.1 插件目录必须有 `qmldir`，加载器据此把上级目录加入 QML import path，再按模块名加载类型。
- `dde-control-center --spec <dir>` 改为只从指定目录加载插件，用于调试未安装的插件；其余命令行参数见 `--help`（`src/dde-control-center/main.cpp:99-120,219-222`）。
- 单个插件的流程是：`loadMetaData()` → `loadModule()` → `loadData()`（`QPluginLoader` 加载 `<module>.so`，校验 IID `org.deepin.dde.dcc-factory/v1.0`）→ `createData()`（得到 `dccData`）→ `loadMain()`，对象树合并进主窗口（`src/dde-control-center/pluginmanager.cpp:95-140`）。

### C++ 后端

后端是一个 `MODULE` 库，在实现文件里用 `DCC_FACTORY_CLASS(<类名>)` 注册工厂（`include/dccfactory.h:28-42`）：

```cpp
class FooInteraction : public QObject
{
    Q_OBJECT
    // 导出为 dccData 的属性、槽
};

DCC_FACTORY_CLASS(FooInteraction)
```

`DccFactory::create()` 返回的对象就是 `dccData`；`DccFactory::dccObject()` 可以额外返回一个由插件自行加载的 `DccObject`，用于不通过 `<Name>Main.qml` 组织界面的插件（`include/dccfactory.h:19-23`）。

### 新增插件

1. 建 `src/plugin-foo/CMakeLists.txt`，设置插件名 `foo`，写 `dcc_install_plugin(NAME ${FOO_NAME})`；需要后端时再加 `add_library(... MODULE ...)` 与 `TARGET`。
2. 写 `qml/Foo.qml`：模块对象，至少给 `name`、`parentName`、`displayName`。
3. 写 `qml/FooMain.qml`：主对象；没有页面时放空的 `DccObject`。
4. 在顶层 `CMakeLists.txt` 的插件列表里加 `add_subdirectory(src/plugin-foo)`。
5. 用户可见字符串一律用 `qsTr()`（QML）或 `tr()`（C++），随后更新 `translations/`。

`examples/plugin-example/` 是一个可构建的完整示例，构建时加 `-DBUILD_EXAMPLES=ON`。它演示了 `find_package(DdeControlCenter REQUIRED)`、链接 `Dde::Control-Center`、`dcc_install_plugin()` 与 `dcc_handle_plugin_translation()` 的写法（`examples/plugin-example/CMakeLists.txt:1-28`）。

## 4. 翻译

翻译文件的命名、放置与 Weblate 流程见 [docs/TRANSLATING.md](docs/TRANSLATING.md)。

### 文件与命名

- 主程序翻译统一放在 `translations/dde-control-center_<locale>.ts`，目前共 91 份。
- `<locale>` 使用 Qt 的 locale 名：`<language>` 或 `<language>_<TERRITORY>`，如 `zh_CN`、`pt_BR`、`af_ZA`。现有文件中 70 份是裸语言代码，21 份带地区代码。
- 文件内 `<TS language="...">` 必须与文件名一致，缺少该属性时 Qt 与 Weblate 都无法判断文件对应的语言。目前 `dde-control-center_en.ts` 与 `dde-control-center_nb_NO.ts` 缺该属性。
- 同一语言只保留一份文件：已经有地区变体（`pt_BR`）时不要再加裸语言代码（`pt`）。仓库中 `pt`/`pt_BR` 目前各有一份，新增语言请遵守这条约定，避免同一语言出现两份互相覆盖的文件。
- `translations/desktop/*.ts` 存放桌面条目（`.desktop`）的翻译，由 `misc/translate_ts2desktop.sh` 在 configure 阶段写回 desktop 文件，不要手工改 desktop 里的翻译行。

### 编译与装载

`Release` 配置在 configure 阶段执行 `misc/translate_generation.sh`：进入 `translations/`，对每个 `.ts` 调用 `lrelease`，输出同名 `.qm` 到 `build/src/dde-control-center/`，随后安装到 `/usr/share/dde-control-center/translations/v1.1/`。运行时不直接读 `.ts`，而是由 `DccManager::installTranslator()` 按当前 locale 从该目录装载 `.qm`（`src/dde-control-center/dccmanager.cpp:118-124`）。

`.ts` 由 `qt_add_translations()` 处理，`lupdate` 参数固定为 `-no-obsolete -no-ui-lines -locations none`（`misc/DdeControlCenterPluginMacros.cmake:156-160`）：文件里不保留 `<location>` 行，过期条目会被删除。手工编辑时不要添加 `<location>`。

### 新增语言

1. 复制一份现有 `.ts` 为 `translations/dde-control-center_<locale>.ts`。
2. 把 `<TS language="...">` 改成新的 locale。
3. 保留 `context`/`name`/`source` 与 `comment` 原文，只填 `translation`；未翻译的条保留 `type="unfinished"`。
4. 构建一次，确认同名 `.qm` 被生成并安装；不要提交 `.qm`。

### 通过 Weblate 翻译

翻译不需要写代码，也不需要改 C++ 或 QML。Weblate 项目页地址待补充（项目在 Weblate 建立后填入本节）；仓库是公开的自由软件项目（GPL-3.0-or-later），满足 Weblate 免费托管（Libre）的前提。

- 只翻译 `translations/dde-control-center_<locale>.ts`，不要新建平行目录，也不要手工合并文件。
- 源字符串、`context` 与 `comment` 不要改写；如需修改源字符串，先改 QML/C++ 再让工具重新生成。
- 同一语言不要同时保留裸语言代码与地区代码两份文件。
- 翻译以 Weblate 的提交为准，评审在 Weblate 内完成，不需要在 GitHub 另开 PR。

## 5. 许可证

本项目以 **GNU General Public License v3.0 or later**（`GPL-3.0-or-later`）发布。

- 许可证全文：根目录 [LICENSE](LICENSE)（GPL v3 文本）；仓库没有单独的 `COPYING` 文件，其它许可证文本以文件名形式放在 `LICENSES/`。
- 各源码与 QML 文件头使用 SPDX 标识，主体为 `GPL-3.0-or-later`；个别文件不同，例如 `src/plugin-keyboard/qml/KeySequenceDisplay.qml` 为 `LGPL-3.0-or-later`，以文件头为准。
- 侧栏图标 `icons/sidebar/` 来自 Tabler Icons，按 MIT 许可使用，详见 `debian/copyright`。
- `misc/org.deepin.dde.controlcenter.metainfo.xml` 的元数据许可为 `CC0-1.0`。
- 第三方许可证文本放在 `LICENSES/`：`GPL-3.0-or-later.txt`、`LGPL-3.0-or-later.txt`、`MIT.txt`、`CC0-1.0.txt`、`CC-BY-4.0.txt`。

提交的代码默认按 `GPL-3.0-or-later` 授权。引入其它许可证的代码或素材时，需要在文件头标注 SPDX 标识，并把许可证文本加入 `LICENSES/`。

## 6. 参与贡献

提 issue、提 PR 与代码风格的约定见 [CONTRIBUTING.md](CONTRIBUTING.md)。

- 问题报告：<https://github.com/LingmoOS/lingmo-control-center/issues>
- 代码提交：<https://github.com/LingmoOS/lingmo-control-center/pulls>
- 讨论：<https://github.com/orgs/LingmoOS/discussions>

提交前的约定：

- 代码风格由 `.clang-format` 与 `.editorconfig` 定义，提交前格式化改动的文件。
- 一个 PR 只做一件事；修 bug 与重构分开，便于评审。
- 新增或修改用户可见字符串后，同步更新 `translations/`（见第 4 节）。
- 新增插件的目录、命名与安装方式遵循第 3 节；不要绕过 `dcc_install_plugin` 手工写安装规则。
- 贡献按第 5 节的许可证授权。
