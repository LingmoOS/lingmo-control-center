cmake_minimum_required(VERSION 3.18)
set(Accessibility_Name accessibility)
file(GLOB_RECURSE accessibility_SRCS
    "operation/*.cpp"
    "operation/*.h"
)

add_library(${Accessibility_Name} MODULE
    ${accessibility_SRCS}
)

set(Accessibility_Libraries
    ${DCC_FRAME_Library}
    ${QT_NS}::Core     # QObject / QProcess / QString
    ${QT_NS}::Gui      # 与其它插件保持一致（QML 模块构建需要）
)

target_link_libraries(${Accessibility_Name} PRIVATE
    ${Accessibility_Libraries}
)

dcc_install_plugin(NAME ${Accessibility_Name} TARGET ${Accessibility_Name})
