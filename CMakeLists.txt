cmake_minimum_required(VERSION 3.16)
project(cairo-qml-clock VERSION 0.2.0)

set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup()

qt_add_executable(cairo-qml-clock main.cpp)
target_link_libraries(cairo-qml-clock PRIVATE Qt6::Quick)

install(TARGETS cairo-qml-clock DESTINATION bin)
