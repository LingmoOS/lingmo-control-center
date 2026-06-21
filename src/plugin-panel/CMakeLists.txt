cmake_minimum_required(VERSION 3.18)

set(PLUGIN_NAME panel)

file(GLOB_RECURSE Panel_Plugin_SRCS
    "operation/*.cpp"
    "operation/*.hpp"
    "operation/*.h"
)

add_library(${PLUGIN_NAME} MODULE
    ${Panel_Plugin_SRCS}
)

target_link_libraries(${PLUGIN_NAME} PRIVATE
    ${DCC_FRAME_Library}
    ${DTK_NS}::Gui
)

dcc_install_plugin(NAME ${PLUGIN_NAME} TARGET ${PLUGIN_NAME})
