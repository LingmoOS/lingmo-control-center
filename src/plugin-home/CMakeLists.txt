cmake_minimum_required(VERSION 3.18)
set(Plugin_Name home)
file(GLOB_RECURSE plugin_home_SRCS
    "operation/*.cpp"
    "operation/*.h"
)

add_library(${Plugin_Name} MODULE
    ${plugin_home_SRCS}
)

set(Plugin_Libraries
    ${DCC_FRAME_Library}
    ${QT_NS}::Core     # QObject / QString / QFile
    ${QT_NS}::Gui      # 与其它插件保持一致（QML 模块构建需要）
)

target_link_libraries(${Plugin_Name} PRIVATE
    ${Plugin_Libraries}
)

dcc_install_plugin(NAME ${Plugin_Name} TARGET ${Plugin_Name})
