cmake_minimum_required(VERSION 3.23)
project(luasql C)
set(PACKAGE_NAME ${PROJECT_NAME})

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

find_package(Lua REQUIRED)

add_library(${PROJECT_NAME} src/luasql.c src/luasql.h)
add_library(${PACKAGE_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${LUA_INCLUDE_DIR}>)
target_link_libraries(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${LUA_LIBRARIES}>)

if(BUILD_SHARED_LIBS)
    if(WIN32)
        # https://github.com/lua/lua/blob/v5.4.0/luaconf.h#L222
        set(suffix .dll)
    else()
        # https://github.com/lua/lua/blob/v5.4.0/luaconf.h#L242
        set(suffix .so)
    endif()
    set_target_properties(${PROJECT_NAME} PROPERTIES
        PREFIX "" SUFFIX ${suffix}
        DEFINE_SYMBOL ""
    )
endif()

if(NOT DEFINED WITH_ODBC)
    find_package(ODBC)
elseif(WITH_ODBC)
    find_package(ODBC REQUIRED)
endif()

if(TARGET ODBC::ODBC)
    target_sources(${PROJECT_NAME} PRIVATE src/ls_odbc.c src/odbc.def)
    target_link_libraries(${PROJECT_NAME} PRIVATE ODBC::ODBC)
endif()

if(NOT DEFINED WITH_SQLite3)
    find_package(SQLite3)
elseif(WITH_SQLite3)
    find_package(SQLite3 REQUIRED)
endif()

if(TARGET SQLite::SQLite3)
    target_sources(${PROJECT_NAME} PRIVATE src/ls_sqlite3.c src/sqlite3.def)
    target_link_libraries(${PROJECT_NAME} PRIVATE SQLite::SQLite3)
endif()

if(NOT DEFINED WITH_PostgreSQL)
    find_package(PostgreSQL)
elseif(WITH_PostgreSQL)
    find_package(PostgreSQL REQUIRED)
endif()

if(TARGET PostgreSQL::PostgreSQL)
    target_sources(${PROJECT_NAME} PRIVATE src/ls_postgres.c src/postgres.def)
    target_link_libraries(${PROJECT_NAME} PRIVATE PostgreSQL::PostgreSQL)
endif()

if(NOT DEFINED WITH_MySQL)
    find_package(MySQL)
elseif(WITH_MySQL)
    find_package(MySQL REQUIRED)
endif()

if(TARGET MySQL::MySQL)
    target_sources(${PROJECT_NAME} PRIVATE src/ls_mysql.c src/mysql.def)
    target_link_libraries(${PROJECT_NAME} PRIVATE MySQL::MySQL)
endif()

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME} EXPORT ${PACKAGE_NAME}-config)
install(EXPORT ${PACKAGE_NAME}-config
    NAMESPACE ${PACKAGE_NAME}::
    DESTINATION ${CMAKE_INSTALL_DATADIR}/${PACKAGE_NAME}
)
