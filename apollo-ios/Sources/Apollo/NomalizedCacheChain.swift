import Foundation

class NormalizedCacheChain: NormalizedCache {

    let normalizedCaches: [any NormalizedCache]

    init(normalizedCaches: [any NormalizedCache]) {
        self.normalizedCaches = normalizedCaches
    }

    func loadRecords(forKeys keys: Set<Apollo.CacheKey>) throws -> [Apollo.CacheKey: Apollo.Record] {
        var recordSet = RecordSet()
        for cache in normalizedCaches.reversed() {
            let fetchedRecords = try cache.loadRecords(forKeys: keys)
            for keyedRecord in fetchedRecords {
                recordSet.merge(record: keyedRecord.value)
            }
        }
        return recordSet.storage
    }

  func merge(records: Apollo.RecordSet, requestContext: RequestContext? = nil) throws -> Set<Apollo.CacheKey> {
        var mergedRecords = Set<Apollo.CacheKey>()
        for cache in normalizedCaches {
            mergedRecords.formUnion(try cache.merge(records: records, requestContext: requestContext))
        }
        return mergedRecords
    }

    func removeRecord(for key: Apollo.CacheKey) throws {
        for cache in normalizedCaches {
            try cache.removeRecord(for: key)
        }
    }

    func removeRecords(matching pattern: Apollo.CacheKey) throws {
        for cache in normalizedCaches {
            try cache.removeRecords(matching: pattern)
        }
    }

    func clear() throws {
        for cache in normalizedCaches {
            try cache.clear()
        }
    }
}
