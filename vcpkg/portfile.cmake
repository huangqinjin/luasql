set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_USE_HEAD_VERSION ON)
cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH REPO)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL ${REPO}
    HEAD_REF HEAD
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        odbc    WITH_ODBC
        sqlite3 WITH_SQLite3
        postgre WITH_PostgreSQL
        mysql   WITH_MySQL
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
vcpkg_copy_pdbs()
vcpkg_install_copyright(FILE_LIST "${VCPKG_ROOT_DIR}/ports/lua/COPYRIGHT")
