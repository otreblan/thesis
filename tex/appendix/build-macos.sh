git clone https://github.com/fdtd-lucuma/fdtd-lucuma
cd fdtd-lucuma

VCPKG="./vcpkg"

git clone https://github.com/microsoft/vcpkg.git "$VCPKG"
pushd "$VCPKG"
./bootstrap-vcpkg.sh -disableMetrics
popd

"$VCPKG/vcpkg" install shader-slang
xargs -- brew install < pkg/macos/dependencies.txt

export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
export LLVM_PREFIX="$(brew --prefix llvm)"
export CC="$LLVM_PREFIX/bin/clang"
export CXX="$LLVM_PREFIX/bin/clang++"
export LDFLAGS="-L$LLVM_PREFIX/lib/c++"

MODULES="$LLVM_PREFIX/lib/c++/libc++.modules.json"
TOOLCHAIN="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"

cmake -B build -G Ninja -DCMAKE_CXX_STDLIB_MODULES_JSON="$MODULES" -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN"
cmake --build build

cd build
./fdtd-lucuma
