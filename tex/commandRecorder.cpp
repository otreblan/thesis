.
.
.

CommandRecorder::~CommandRecorder()
{
	if(!commandBuffer || compute == nullptr)
		return;


	commandBuffer.end();
	compute->submit(getCommandBuffer()); // TODO: Fence?
}

.
.
.
