using CUDA

# Kernel definitions

function updateH(Hy, Ez, x, deltaT, deltaX, mu)
	idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x

	@inbounds Hy[idx] = (idx > x) ? Hy[idx] : (Hy[idx] + (deltaT/(mu*deltaX))*(Ez[idx+1] - Ez[idx]))
end

function updateE(Ez, Hy, deltaT, deltaX, eps)
	idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x

	@inbounds Ez[idx] = (idx == 1) ? Ez[idx] : (Ez[idx] + (deltaT/(eps*deltaX))*(Hy[idx] - Hy[idx-1]))
end

function gaussianSource(Ez, pos, sigma, timestep)
	CUDA.allowscalar() do
		Ez[pos] += exp(-1 * (timestep/sigma)^2)
	end
end

function abc(Ez, x, Cr, mu, eps)
	Sc = Cr / (sqrt(mu * eps))
	abcCoef = (Sc - 1) / (Sc + 1)

	CUDA.allowscalar() do
		Ez[1] = Ez[1] + abcCoef*(Ez[2] - Ez[1])
		Ez[x] = Ez[x] + abcCoef*(Ez[x-1] - Ez[x])
	end
end

x::Int64 = 100
Cr::Float32 = 1.0 / sqrt(3.0)
sigma::Float32 = 10
sourcePos::Int64 = Int.(floor(x/2))
deltaT::Float32 = 1.0
deltaX::Float32 = 1.0
mu::Float32 = 1.0
eps::Float32 = 1.0

maxTime::Int64 = 300

Hy = CuArray{Float32}(undef, x)
Ez = CuArray{Float32}(undef, x)

for timestep in 1:1:maxTime
	@cuda threads = x blocks = 1 updateH(Hy, Ez, x, deltaT, deltaX, mu)
	CUDA.device_synchronize()

	@cuda threads = x blocks = 1 updateE(Ez, Hy, deltaT, deltaX, eps)
	CUDA.device_synchronize()

	gaussianSource(Ez, sourcePos, sigma, timestep)
	CUDA.device_synchronize()

	abc(Ez, x, Cr, mu, eps)
	CUDA.device_synchronize()
end
