#include <stdint.h>
#include <winnt.h>

namespace CyberpunkMod {

LARGE_INTEGER recentCallTimes[0x10000] = {0};
uint16_t recentCallTimesIndex = 0;
// std::mutex recentCallTimesMutex;

struct Profiler {
  inline Profiler() {
    QueryPerformanceFrequency(&Frequency); 
    QueryPerformanceCounter(&StartingTime);
  }

  LONGLONG End() {
    QueryPerformanceCounter(&EndingTime);
    LARGE_INTEGER ElapsedMicroseconds;
    ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
    // std::lock_guard<std::mutex> recentCallTimesLock(recentCallTimesMutex);
    recentCallTimes[recentCallTimesIndex++] = ElapsedMicroseconds;
    if (recentCallTimesIndex == 0) {
      LARGE_INTEGER sum = LARGE_INTEGER();
      for (uint32_t i = 0; i < 0x10000; i++) {
        sum.QuadPart += recentCallTimes[i].QuadPart;
      } 
      sum.QuadPart /= 0x10000;
      sum.QuadPart *= 1000000;
      sum.QuadPart /= Frequency.QuadPart;
      return sum.QuadPart;
    }
    return 0;
  }

  LARGE_INTEGER Frequency;
  LARGE_INTEGER StartingTime;
  LARGE_INTEGER EndingTime;
};

} // namespace CyberpunkMod