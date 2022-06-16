#! /bin/sh

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${OSX_ARCH}"; then
    CFLAGS="${CFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.dylib"
else
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
fi

test "${PKG_BUILDNUM}" != "0" && sed                                       \
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1${PKG_BUILDNUM}:" \
    -i "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"
cat "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

cmake ${CMAKE_ARGS} ${iconv_args}                \
    -DBUILD_PYTHON_MODULE:BOOL=ON                \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"     \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall" \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"        \
    "${SRC_DIR}"

cmake --build .
cmake --install . --prefix "${PREFIX}"

src/tiff2smv -V
