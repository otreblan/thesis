// gaussianSource.slang

RWStructuredBuffer<float> Ez;

struct PushConstants
{
	uint pos;
	float sigma;
	uint timestep;
};

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 threadId : SV_DispatchThreadID, uniform PushConstants pushConstants)
{
	uint idx = threadId.x;

	const float x = pushConstants.pos/pushConstants.sigma;

	Ez[pushConstants.pos] += exp(-(x*x));
}
