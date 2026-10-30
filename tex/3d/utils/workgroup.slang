// utils/workgroup.slang

#pragma once

// For hardware that doesn't support dynamic workgroup size
#ifdef STATIC_WORKGROUP
#define Workgroup(x,y,z) [numthreads(64,4,2)]
#else
#define Workgroup(x,y,z) [numthreads(x,y,z)]
#endif
