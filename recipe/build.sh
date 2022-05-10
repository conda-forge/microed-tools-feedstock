#! /bin/sh

iconv_args="-DIconv_INCLUDE_DIR:PATH=${CONDA_BUILD_SYSROOT}/usr/include"
if test -n "${LD_RUN_PATH}"; then
    iconv_args="${iconv_args} -DIconv_IS_BUILT_IN:BOOL=TRUE"
elif test -n "${OSX_ARCH}"; then
    iconv_args="${iconv_args} -DIconv_LIBRARY:PATH=${CONDA_BUILD_SYSROOT}/usr/lib/libiconv.dylib"
fi

test "${PKG_BUILDNUM}" != "0" && buildmetadata="${PKG_BUILDNUM}"
cat << EOF > "${SRC_DIR}/tvips/MICROED-TOOLS-VERSION-FILE"
MICROED_TOOLS_VERSION_BRANCH=experimental/jiffies
MICROED_TOOLS_VERSION_BUILDMETADATA=${buildmetadata}
MICROED_TOOLS_VERSION_OBJECT_NAME=a496c67
MICROED_TOOLS_VERSION_PRERELEASE=dev.6
MICROED_TOOLS_VERSION_STATE=
PACKAGE_VERSION_MAJOR=0
PACKAGE_VERSION_MINOR=1
PACKAGE_VERSION_PATCH=0
PACKAGE_VERSION_TWEAK=0
EOF

cmake ${CMAKE_ARGS} ${iconv_args}                \
    -DBUILD_PYTHON_MODULE:BOOL=ON                \
    -DCMAKE_C_FLAGS:STRING="${CFLAGS} -Wall"     \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS} -Wall" \
    -DPython3_EXECUTABLE:PATH="${PYTHON}"        \
    "${SRC_DIR}/tvips"

cmake --build . --parallel "${CPU_COUNT}"
cmake --install . --prefix "${PREFIX}"

pandoc --from=gfm                          \
       --to=plain+shortcut_reference_links \
       --output=README                     \
       --reference-links                   \
       "${SRC_DIR}/README.md"
install -D -m 644                        \
    README                               \
    "${PREFIX}/share/${PKG_NAME}/README"
