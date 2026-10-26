#!/bin/bash

set -ex

# osx-arm64 py3.14 invoked clang-20 from the package cache. dyld aborted
# because @rpath/libclang-cpp.20.1.dylib was not beside that binary.
# Upstream then skipped the optional extension, and the test import of
# lazy_object_proxy.cext failed. The dylib is provided by libclang-cpp
# in $BUILD_PREFIX/lib.
if [[ "${target_platform}" == osx-* ]]; then
  export DYLD_LIBRARY_PATH="${BUILD_PREFIX}/lib${DYLD_LIBRARY_PATH:+:${DYLD_LIBRARY_PATH}}"
  export DYLD_FALLBACK_LIBRARY_PATH="${BUILD_PREFIX}/lib${DYLD_FALLBACK_LIBRARY_PATH:+:${DYLD_FALLBACK_LIBRARY_PATH}}"
fi

$PYTHON -m pip install . --no-deps --no-build-isolation -vv

# Do not match cext.c, which is copied even when the extension is skipped.
find "${SP_DIR}/lazy_object_proxy" -name 'cext*.so' | grep -q .
