.
.
.

struct alignas(32)
{
	alignas(sizeof(svec4)) svec3 paddedDims;
	T time = {};
	T x0 = {};
} pushConstants;

struct SourceSsbo
{
	alignas(sizeof(svec4)) svec3 position = {};
	T sigma;
};

std::vector<SourceSsbo> sourceSsbos;
vulkan::Buffer          sourceSsbosBuffer;

vulkan::ComputePipeline pipeline;

.
.
.

void fillData(entt::registry& registry, vulkan::Buffer& Ec) |\phantomsection\label{code:fillData}|
{
	sourceSsbos.clear();

	auto group = registry.group<const components::GaussianSource<T>>(entt::get<const components::Transform>);

	for(auto&& [_, source, transform]: group.each()) |\phantomsection\label{code:iterate}|
	{
		sourceSsbos.emplace_back(SourceSsbo{
			.position = transform.position,
			.sigma    = source.sigma,
		});
	}

	const std::size_t byteSize = sourceSsbos.size()*sizeof(SourceSsbo);

	if(byteSize > sourceSsbosBuffer.getInfo().size)  |\phantomsection\label{code:recreate}|
	{
		sourceSsbosBuffer = allocateSsbosBuffer(std::bit_ceil(byteSize));
		pipeline          = recreatePipeline(Ec);
	}

	sourceSsbosBuffer.memcpy(sourceSsbos.data(), byteSize);

}

void dispatch(vk::CommandBuffer commandBuffer, entt::registry& registry, T time, vulkan::Buffer& Ec, T x0 = 0) |\phantomsection\label{code:dispatch}|
{
	pushConstants.time = time;
	pushConstants.x0   = x0;

	fillData(registry, Ec);

	if(sourceSsbos.empty())
		return;

	pipeline.bind(commandBuffer);
	pipeline.pushConstants(commandBuffer, pushConstants);
	commandBuffer.dispatch(getWorkgroupCount(),1,1);
}
