void fillData(entt::registry& registry, vulkan::Buffer& Ec)
{
	sourceSsbos.clear();

	auto group = registry.group<const components::GaussianSource<T>>(entt::get<const components::Transform>);

	for(auto&& [_, source, transform]: group.each())
	{
		sourceSsbos.emplace_back(SourceSsbo{
			.position = transform.position,
			.sigma    = source.sigma,
		});
	}

	const std::size_t byteSize = sourceSsbos.size()*sizeof(SourceSsbo);

	if(byteSize > sourceSsbosBuffer.getInfo().size)
	{
		sourceSsbosBuffer = allocateSsbosBuffer(std::bit_ceil(byteSize));
		pipeline          = recreatePipeline(Ec);
	}

	sourceSsbosBuffer.memcpy(sourceSsbos.data(), byteSize);

}

/// This function fill the VkCommandBuffer with the commands needed to apply the gaussian sources to the electric field.
void dispatch(vk::CommandBuffer commandBuffer, entt::registry& registry, T time, vulkan::Buffer& Ec, T x0 = 0)
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
