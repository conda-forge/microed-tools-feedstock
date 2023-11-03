#! /bin/sh

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${LD_RUN_PATH}"; then
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
elif test -n "${OSX_ARCH}"; then
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    major=`echo "${MACOSX_DEPLOYMENT_TARGET}" | sed -e "s/^\([0-9]*\).*/\1/"`
    minor=`echo "${MACOSX_DEPLOYMENT_TARGET}" | sed -e "s/^[0-9]*\.\([0-9]*\).*/\1/"`
    if test "${major}" -gt "10" -o \( "${major}" -eq "10" -a "${minor}" -ge "11" \); then
        libiconv="libiconv.tbd"
    else
        libiconv="libiconv.dylib"
    fi
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/${libiconv}"
fi

test "${PKG_BUILDNUM}" != "0" && sed                                       \
    -e "s:^\(MICROED_TOOLS_VERSION_BUILDMETADATA=\).*$:\1${PKG_BUILDNUM}:" \
    -i.bak "${SRC_DIR}/MICROED-TOOLS-VERSION-FILE"

cmake ${CMAKE_ARGS} ${iconv_args}                \
    -DBUILD_JIFFIES:BOOL=ON                \
    -DBUILD_PYTHON_MODULE:BOOL=ON                \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"     \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall" \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"        \
    "${SRC_DIR}"

cmake --build .
cmake --install . --prefix "${PREFIX}"

mkdir -p "${PREFIX}/share/man/man1"
mv "${PREFIX}/share/man/"*.1 "${PREFIX}/share/man/man1"

mkdir -p "${PREFIX}/share/man/man5"
mv "${PREFIX}/share/man/"*.5 "${PREFIX}/share/man/man5"

mkdir -p "${PREFIX}/share/${PKG_NAME}"
mv "${PREFIX}/share/doc/LICENSE" \
    "${PREFIX}/share/doc/README" \
    "${PREFIX}/share/${PKG_NAME}"
