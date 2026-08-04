// updateE.slang

StructuredBuffer<float> Hy;
RWStructuredBuffer<float> Ez;

struct PushConstants
{
	uint x;
	float deltaT;
	float deltaX;
	float eps;
};

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 threadId : SV_DispatchThreadID, uniform PushConstants pushConstants)
{
	uint idx = threadId.x;

	Ez[idx] = (idx == 0) ? Ez[idx] : (Ez[idx] + (pushConstants.deltaT/(pushConstants.eps*pushConstants.deltaX))*(Hy[idx+1] - Hy[idx]));
}
