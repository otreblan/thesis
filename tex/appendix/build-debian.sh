git clone https://github.com/fdtd-lucuma/fdtd-lucuma
cd fdtd-lucuma

VCPKG="./vcpkg"

apt update
apt upgrade -y
apt install -y git curl zip unzip tar cmake ninja-build build-essential
git clone https://github.com/microsoft/vcpkg.git "$VCPKG"
pushd "$VCPKG"
./bootstrap-vcpkg.sh -disableMetrics
popd

"$VCPKG/vcpkg" install shader-slang glm
sed "/debuginfo/d" pkg/ubuntu/dependencies.txt | xargs -o -- sudo apt -t experimental install

cmake -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE="$VCPKG/scripts/buildsystems/vcpkg.cmake"
cmake --build build

cd build
./fdtd-lucuma
