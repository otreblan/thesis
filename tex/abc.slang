// abc.slang

RWStructuredBuffer<float> Ez;

struct PushConstants
{
	uint x;
	float Cr;
	float mu;
	float eps;
};

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 threadId : SV_DispatchThreadID, uniform PushConstants pushConstants)
{
	uint idx = threadId.x;

	const float Sc = pushConstants.Cr / sqrt(pushConstants.mu*pushConstants.eps);
	const float abcCoef = (Sc - 1)/(Sc + 1);

	Ez[0] = Ez[0] + abcCoef*(Ez[1] - Ez[0]);
	Ez[pushConstants.x-1] = Ez[pushConstants.x-1] + abcCoef*(Ez[pushConstants.x-2] - Ez[pushConstants.x-1]);
}
