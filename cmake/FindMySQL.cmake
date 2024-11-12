find_package(PkgConfig QUIET)
pkg_check_modules(PC_MySQL QUIET mysqlclient libmariadb)

find_path(MySQL_INCLUDE_DIR
  NAMES mysql.h
  PATHS ${PC_MySQL_INCLUDE_DIRS}
  PATH_SUFFIXES mysql
)

find_library(MySQL_LIBRARY_RELEASE
  NAMES mysqlclient mariadb
  PATHS ${PC_MySQL_LIBRARY_DIRS}
)

include(SelectLibraryConfigurations)
select_library_configurations(MySQL)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MySQL
  REQUIRED_VARS
    MySQL_INCLUDE_DIR
    MySQL_LIBRARY
)

if(MySQL_FOUND)
    set(MySQL_INCLUDE_DIRS ${MySQL_INCLUDE_DIR})
    set(MySQL_LIBRARIES ${MySQL_LIBRARY})
endif()

if(MySQL_FOUND AND NOT TARGET MySQL::MySQL)
    add_library(MySQL::MySQL UNKNOWN IMPORTED)
    set_target_properties(MySQL::MySQL PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${MySQL_INCLUDE_DIR}"
        IMPORTED_LOCATION "${MySQL_LIBRARY}"
    )
endif()
