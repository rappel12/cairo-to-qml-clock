cmake_minimum_required(VERSION 3.16)
project(cairo-qml-clock VERSION 0.2.0)

set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup()

set(QML_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share/cairo-qml-clock")
configure_file(config.h.in config.h @ONLY)

qt_add_executable(cairo-qml-clock main.cpp)
target_include_directories(cairo-qml-clock PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(cairo-qml-clock PRIVATE Qt6::Quick)

install(TARGETS cairo-qml-clock DESTINATION bin)
