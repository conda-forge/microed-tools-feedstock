#! /bin/sh

_version_lt() {
    _lhs=`echo "${1}" | cut -d. -f1`
    _rhs=`echo "${2}" | cut -d. -f1`
    test "${_lhs}" -lt "${_rhs}" && return 0

    if test "${_lhs}" -eq "${_rhs}"; then
        _lhs=`echo "${1}" | cut -d. -f2`
        _rhs=`echo "${2}" | cut -d. -f2`
        test "${_lhs}" -lt "${_rhs}" && return 0
    fi

    return 1
}

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${LD_RUN_PATH}"; then
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
elif test -n "${OSX_ARCH}"; then
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.tbd"

    if _version_lt "${MACOSX_DEPLOYMENT_TARGET}" "10.14" ; then
        CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    fi

    if test "${CONDA_BUILD_CROSS_COMPILATION}" = "1"; then
        numpy_args="-DPython3_NumPy_INCLUDE_DIR:PATH=${SP_DIR}/numpy/_core/include"
    fi
fi

cmake ${CMAKE_ARGS} ${iconv_args} ${numpy_args}                \
    -DBUILD_PYTHON_MODULE:BOOL=ON                              \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"                   \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall"               \
    -DCMAKE_INSTALL_DATADIR:PATH="${PREFIX}/share/${PKG_NAME}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}"                    \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"                      \
    "${SRC_DIR}"

cmake --build .
cmake --install .
cat MICROED-TOOLS-VERSION-FILE
