#! /bin/sh

_version_lt() {
    _lhs=`echo "${1}" | cut -d '.' -f 1`
    _rhs=`echo "${2}" | cut -d '.' -f 1`
    test "${_lhs}" -lt "${_rhs}" && return 0

    if test "${_lhs}" -eq "${_rhs}"; then
        _lhs=`echo "${1}" | cut -d '.' -f 2`
        _rhs=`echo "${2}" | cut -d '.' -f 2`
        test "${_lhs}" -lt "${_rhs}" && return 0
    fi

    return 1
}

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${LD_RUN_PATH}"; then
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
elif test -n "${OSX_ARCH}"; then
    if _version_lt "${MACOSX_DEPLOYMENT_TARGET}" "10.11" ; then
        _libiconv="${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.dylib"
    else
        _libiconv="${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.tbd"
    fi
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${_libiconv}"

    if _version_lt "${MACOSX_DEPLOYMENT_TARGET}" "10.14" ; then
        CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    fi
fi

if test -n "${CONDA_BUILD_CROSS_COMPILATION}"; then
    if _version_lt "${NPY_VER}" "2.0" ; then
        _include_dir="${SP_DIR}/numpy/core/include"
    else
        _include_dir="${SP_DIR}/numpy/_core/include"
    fi
    numpy_args="-DPython3_NumPy_INCLUDE_DIR:PATH=${_include_dir}"
fi

test "${PKG_BUILDNUM}" != "0" && sed                                       \
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1${PKG_BUILDNUM}:" \
    -i.bak "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

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
