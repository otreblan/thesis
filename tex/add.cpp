void Compute::compute()
{
	float a = 1.0f;
	float b = 2.0f;
	float c;

	// VkComputePipeline and it's binded VkBuffers
	auto pipeline = createHelloWorld();

	pipeline.aBuffer.memcpy(&a, sizeof(float)*1);
	pipeline.bBuffer.memcpy(&b, sizeof(float)*1);

	auto& commandBuffer = pipeline.pipeline.getCommandBuffer();

	vk::CommandBufferBeginInfo beginInfo{};

	commandBuffer.begin(beginInfo);

	pipeline.pipeline.bind(commandBuffer);
	commandBuffer.dispatch(1, 1, 1);

	commandBuffer.end();

	vulkanCompute.submit(commandBuffer);

	c = *(float*)pipeline.cBuffer.getInfo().pMappedData;

	std::println("{} + {} = {}", a, b, c);
}

vk::DescriptorSetLayoutBinding simpleComputeBuffer(std::uint32_t binding)
{
	return vk::DescriptorSetLayoutBinding {
		.binding         = binding,
		.descriptorType  = vk::DescriptorType::eStorageBuffer,
		.descriptorCount = 1,
		.stageFlags      = vk::ShaderStageFlagBits::eCompute,
	};
}

Compute::HelloWorldData Compute::createHelloWorld()
{
	HelloWorldData result;

	result.aBuffer = vulkanAllocator.allocate(
		sizeof(float)*1,
		vk::BufferUsageFlagBits::eStorageBuffer | vk::BufferUsageFlagBits::eTransferDst,
		vma::AllocationCreateFlagBits::eHostAccessSequentialWrite | vma::AllocationCreateFlagBits::eMapped
	);

	result.bBuffer = vulkanAllocator.allocate(
		sizeof(float)*1,
		vk::BufferUsageFlagBits::eStorageBuffer | vk::BufferUsageFlagBits::eTransferDst,
		vma::AllocationCreateFlagBits::eHostAccessSequentialWrite | vma::AllocationCreateFlagBits::eMapped
	);

	result.cBuffer = vulkanAllocator.allocate(
		sizeof(float)*1,
		vk::BufferUsageFlagBits::eStorageBuffer | vk::BufferUsageFlagBits::eTransferSrc,
		vma::AllocationCreateFlagBits::eHostAccessRandom | vma::AllocationCreateFlagBits::eMapped
	);

	result.pipeline = vulkanCompute.createPipeline({
		.shaderPath = "hello_world.spv",
		.setLayouts = {{
			.bindings = {
				simpleComputeBuffer(0),
				simpleComputeBuffer(1),
				simpleComputeBuffer(2),

			},
			.buffers = {
				result.aBuffer,
				result.bBuffer,
				result.cBuffer,
			}
		}},
	});

	return result;

}
