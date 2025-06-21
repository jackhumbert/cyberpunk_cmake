#pragma once

#include <RED4ext/RED4ext.hpp>
#include <RED4ext/CName.hpp>

class NameRegistry {
public:
    // 296881534
    uint32_t FindEntry(uint64_t) const {}

    struct Entry {
        uint64_t hash;
        uint64_t * unk08;
        uint32_t size;
        char str[];
    };

    #pragma pack(push, 1)
    struct Hash {
      uint64_t hash;
      Hash * next;
      uint32_t index;
    };
    #pragma pack(pop)

    uint8_t unk00; // 00
    RED4ext::DynArray<Entry*> entries; // 08
    Hash * hashes[0x80000]; // 18
    uint8_t rwSpinLock; // 400018
    uint64_t aft20; // 400020
    uint64_t aft28; // 400028
    uint64_t aft30; // 400030
    uint64_t aft38; // 400038
    // red::memory::DynamicLinearAllocator dynamicLinearAllocator; // 400040
};

const UniversalRelocPtr<NameRegistry> s_CNames(1913530389);