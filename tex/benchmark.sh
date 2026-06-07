seq 16 16 640 | xargs -I{} time -ao /dev/stdout -f "{},%e" -- fdtd-lucuma -b vulkan -t {} 2> /dev/null
