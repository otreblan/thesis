git clone https://github.com/fdtd-lucuma/fdtd-lucuma
cd fdtd-lucuma

pkg add x11-repo tur-repo
xargs -oa pkg/termux/dependencies.txt -- pkg add

NDK_VERSION=29
NDK=android-ndk-r$NDK_VERSION
curl -LO https://dl.google.com/android/repository/$NDK-linux.zip
unzip $NDK-linux.zip

pushd $NDK

cp -fr toolchains/llvm/prebuilt/linux-x86_64/share/libc++ /data/data/com.termux/files/usr/share/
cp toolchains/llvm/prebuilt/linux-x86_64/lib/libc++.modules.json /data/data/com.termux/files/usr/lib
sed -i "s#\.\./\.\.#..#g" /data/data/com.termux/files/usr/lib/libc++.modules.json
sed -i "/__inline__/ s/static//" /data/data/com.termux/files/usr/include/stdio.h

popd

cmake -B build -G Ninja -DBUILD_FOR_TERMUX=ON
cmake --build build

cd build
./fdtd-lucuma
