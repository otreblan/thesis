void Compute::compute()
{
	float a = 1.0f;
	float b = 2.0f;
	float c;

	auto pipeline = createHelloWorld(); // VkComputePipeline and it's binded VkBuffers

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
