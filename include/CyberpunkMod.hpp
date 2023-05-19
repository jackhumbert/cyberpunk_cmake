#pragma once

#include <stdint.h>
#include <winnt.h>
#include <map>
#include <RED4ext/CName.hpp>

#define S_TO_US 1000000
#define S_TO_NS 1000000000

namespace CyberpunkMod {

struct TimeTracker {

  inline TimeTracker() {
    QueryPerformanceCounter(&Init);
    QueryPerformanceFrequency(&Frequency); 
  }

  inline LONGLONG LoopDifference() {
    return Second.QuadPart - First.QuadPart;
  }

  inline LONGLONG TotalDifference() {
    return First.QuadPart - Init.QuadPart;
  }

  inline void Start(uint32_t printInterval_s) {
    QueryPerformanceCounter(&First);
    shouldPrint = TotalDifference() * S_TO_US / Frequency.QuadPart > printInterval_s * S_TO_US;
  }

  inline LONGLONG End() {
    QueryPerformanceCounter(&Second);
    LONGLONG sum = 0;
    if (shouldPrint) {
      sum = recentCallTimes;
      // sum *= S_TO_US;
      // sum /= Frequency; // 
      LONGLONG div = (TotalDifference() * S_TO_US / Frequency.QuadPart);
      if (div != 0) {
        sum = sum * S_TO_US / div;
      } else {
        sum = -1;
      }
      // sum /= m_printInterval_s;
      Init = First;
      recentCallTimes = 0;
      shouldPrint = false;
    }
    recentCallTimes += (LoopDifference() * S_TO_US / Frequency.QuadPart);
    return sum;
  }

  LARGE_INTEGER Frequency;
  LARGE_INTEGER Init;
  LARGE_INTEGER First;
  LARGE_INTEGER Second;
  LONGLONG recentCallTimes = 0;
  bool shouldPrint = false;
};


struct Profiler {
  inline static std::map<RED4ext::CName, TimeTracker> timeTrackers;
  inline Profiler(RED4ext::CName tracker, uint32_t printInterval_s) : m_tracker(tracker) {
    timeTrackers[m_tracker].Start(printInterval_s);
  }

  inline LONGLONG End() {
    return timeTrackers[m_tracker].End();
  }

  RED4ext::CName m_tracker;
};

} // namespace CyberpunkMod