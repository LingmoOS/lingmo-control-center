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
)

target_link_libraries(${Accessibility_Name} PRIVATE
    ${Accessibility_Libraries}
)

dcc_install_plugin(NAME ${Accessibility_Name} TARGET ${Accessibility_Name})
