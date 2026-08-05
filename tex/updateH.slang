// updateH.slang

RWStructuredBuffer<float> Hy;
StructuredBuffer<float> Ez;

struct PushConstants
{
	uint x;
	float deltaT;
	float deltaX;
	float mu;
};

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 threadId : SV_DispatchThreadID, uniform PushConstants pushConstants)
{
	uint idx = threadId.x;
	const float C = (pushConstants.deltaT/(pushConstants.mu*pushConstants.deltaX));

	Hy[idx] = (idx >= pushConstants.x) ? Hy[idx] : (Hy[idx] + C*(Ez[idx+1] - Ez[idx]));
}
