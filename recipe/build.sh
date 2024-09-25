#! /bin/sh

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${LD_RUN_PATH}"; then
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
elif test -n "${OSX_ARCH}"; then
    major=`echo "${MACOSX_DEPLOYMENT_TARGET}" | sed -e "s/^\([0-9]*\).*/\1/"`
    minor=`echo "${MACOSX_DEPLOYMENT_TARGET}" | sed -e "s/^[0-9]*\.\([0-9]*\).*/\1/"`
    if test "${major}" -lt "10" -o \(                           \
            "${major}" -eq "10" -a "${minor}" -lt "11" \); then
        libiconv="libiconv.dylib"
    else
        libiconv="libiconv.tbd"
    fi
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/${libiconv}"
    if test "${major}" -lt "10" -o \(                           \
            "${major}" -eq "10" -a "${minor}" -lt "14" \); then
	CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    fi
fi

#numpy_args="-DPython_FIND_STRATEGY=LOCATION"
#numpy_args="-DPython3_NumPy_INCLUDE_DIR:PATH=${BUILD_PREFIX}/lib/python${PY_VER}/site-packages/numpy/core/include"
if test -n "${CONDA_BUILD_CROSS_COMPILATION}"; then
    echo "BUILDING WITH CONDA_NPY='${CONDA_NPY}' NPY_VER='${NPY_VER}'"
    if test "${CONDA_NPY}" != "20"; then
	include_dir="${SP_DIR}/numpy/core/include"
    else
	include_dir="${SP_DIR}/numpy/_core/include"
    fi
    numpy_args="-DPython3_NumPy_INCLUDE_DIR:PATH=${include_dir}"
fi

#echo "SP_DIR=${SP_DIR}"
#ls -a ${SP_DIR}

#echo "STDLIB_DIR=${STDLIB_DIR}"
#ls -a ${STDLIB_DIR}

#echo "PYTHON=${PYTHON}"
#ls -a ${PYTHON}

#echo "SP_DIR/numpy"
#ls -al ${SP_DIR}/numpy

#echo "SP_DIR/numpy/core"
#ls -al ${SP_DIR}/numpy/core

# ${SP_DIR}/numpy/core/include only appears to exist on
#   linux_64_numpy1.22python3.8.____cpython
#     $PREFIX/lib/python3.8/site-packages/numpy/core/include/numpy/arrayobject.h
#   linux_64_numpy1.22python3.9.____73_pypy
#     $PREFIX/lib/python3.9/site-packages/numpy/core/include/numpy/arrayobject.h
#   osx_64_numpy1.22python3.8.____cpython
#     $PREFIX/lib/python3.8/site-packages/numpy/core/include/numpy/arrayobject.h
#   osx_64_numpy1.22python3.9.____73_pypy
#     $PREFIX/lib/python3.9/site-packages/numpy/core/include/numpy/arrayobject.h
#   osx_arm64_numpy1.22python3.8.____cpython
#     $PREFIX/lib/python3.8/site-packages/numpy/core/include/numpy/arrayobject.h

#echo "SP_DIR/numpy/core/include"
#ls -al ${SP_DIR}/numpy/core/include

#echo "BUILD_PREFIX=${BUILD_PREFIX}"
#ls -al ${BUILD_PREFIX}

#echo "BUILD_PREFIX/lib/python${PY_VER}/site-packages"
#ls -al ${BUILD_PREFIX}/lib

#echo "USING find(1)"
#find ${PREFIX} -name "arrayobject.h"
#find ${SP_DIR} -name "arrayobject.h"

test "${PKG_BUILDNUM}" != "0" && sed                                       \
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1${PKG_BUILDNUM}:" \
    -i.bak "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

#    -DCMAKE_INSTALL_DOCDIR:PATH="${PREFIX}/share/doc/${PKG_NAME}"
cmake ${CMAKE_ARGS} ${iconv_args} ${numpy_args}  \
    -DBUILD_PYTHON_MODULE:BOOL=ON                \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"     \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall" \
    -DCMAKE_INSTALL_DATADIR:PATH="${PREFIX}/share/${PKG_NAME}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}"      \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"        \
    "${SRC_DIR}"

cmake --build .
cmake --install .
