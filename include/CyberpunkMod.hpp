#include <stdint.h>
#include <winnt.h>
#include <map>
#include <RED4ext/CName.hpp>

namespace CyberpunkMod {

struct TimeTracker {
  LONGLONG Difference() {
    return Current.QuadPart - Last.QuadPart;
  }

  void Update(LONGLONG elapsedTicks) {
    recentCallTimes[recentCallTimesIndex++] = elapsedTicks;
    if (!recentCallTimesIndex) {
      flipped = true;
    }
  }

  LONGLONG Sum(LONGLONG frequency) {
    LONGLONG sum = 0;
    auto length = flipped ? 0x10000 : (recentCallTimesIndex + 1);
    for (uint32_t i = 0; i < length; i++) {
      sum += recentCallTimes[i];
    } 
    sum /= length;
    sum *= 1000000;
    sum /= frequency;
    return sum;
  }

  LARGE_INTEGER Last;
  LARGE_INTEGER Current;
  LONGLONG recentCallTimes[0x10000] = {0};
  uint16_t recentCallTimesIndex = 0;
  bool flipped;
};

std::map<RED4ext::CName, TimeTracker> timeTrackers;

struct Profiler {
  inline Profiler(RED4ext::CName tracker, uint32_t printInterval_s) : Tracker(tracker) {
    QueryPerformanceFrequency(&Frequency); 
    if (timeTrackers.find(Tracker) == timeTrackers.end()) {
      timeTrackers[Tracker] = TimeTracker();
    }
    timeTrackers[Tracker].Last = timeTrackers[Tracker].Current;
    QueryPerformanceCounter(&timeTrackers[Tracker].Current);
    if (timeTrackers[Tracker].Difference() > (Frequency.QuadPart * printInterval_s)) {
      shouldPrint = true;
    }
    QueryPerformanceCounter(&StartingTime);
  }

  LONGLONG End() {
    QueryPerformanceCounter(&EndingTime);
    LARGE_INTEGER ElapsedMicroseconds;
    ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
    timeTrackers[Tracker].Update(ElapsedMicroseconds.QuadPart);
    if (shouldPrint) {
      return timeTrackers[Tracker].Sum(Frequency.QuadPart);
    }
    return 0;
  }

  RED4ext::CName Tracker;
  LARGE_INTEGER Frequency;
  LARGE_INTEGER StartingTime;
  LARGE_INTEGER EndingTime;
  bool shouldPrint;
};

} // namespace CyberpunkMod