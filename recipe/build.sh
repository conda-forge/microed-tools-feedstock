#! /bin/sh

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${OSX_ARCH}"; then
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.tbd"
else
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
fi

echo "PKG_BUILDNUM: ${PKG_BUILDNUM}"
echo "SRC_DIR:      ${SRC_DIR}"
which sed
which test
ls "${SRC_DIR}"
cat "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

test "${PKG_BUILDNUM}" != "0" && sed                                       \
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1${PKG_BUILDNUM}:" \
    -i "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

echo "SED OK"
test "${PKG_BUILDNUM}" != "0" && echo "TEST OK"

cmake ${CMAKE_ARGS} ${iconv_args}                \
    -DBUILD_PYTHON_MODULE:BOOL=ON                \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"     \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall" \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"        \
    "${SRC_DIR}"

cmake --build .
cmake --install . --prefix "${PREFIX}"
