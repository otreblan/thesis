using CUDA

# Kernel definition

function add(C, A, B)
	i = (blockIdx().x - 1) * blockDim().x + threadIdx().x

	@inbounds C[i] = A[i] + B[i]

	return
end

# Variables

A = CuArray{Float32}([1,2,3,4])
B = CuArray{Float32}([5,6,7,8])
C = CuArray{Float32}(undef, 4)

# Calling the kernel

@cuda threads=length(A) blocks=1 add(C, A, B)

# Result:
# julia> C
# 4-element CuArray{Float32, 1, CUDA.DeviceMemory}:
#   6.0
#   8.0
#  10.0
#  12.0
