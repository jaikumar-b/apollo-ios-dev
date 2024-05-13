public final class InMemoryNormalizedCache: NormalizedCache {
  private var records: RecordSet

  public init(records: RecordSet = RecordSet()) {
    self.records = records
  }

  public func loadRecords(forKeys keys: Set<CacheKey>) throws -> [CacheKey: Record] {
    return keys.reduce(into: [:]) { result, key in
      result[key] = records[key]
    }
  }

  public func removeRecord(for key: CacheKey) throws {
    records.removeRecord(for: key)
  }
  
  public func merge(records newRecords: RecordSet, requestContext: RequestContext? = nil) throws -> Set<CacheKey> {
    return records.merge(records: newRecords)
  }

  public func removeRecords(matching pattern: CacheKey) throws {
    records.removeRecords(matching: pattern)
  }

  public func clear() {
    records.clear()
  }

  public func sizeInBytes() -> Int {
    records.sizeInBytes()
  }
}

//public final class InMemoryNormalizedCache: NormalizedCache {
//  private var records: RecordSet
//  private var maxSize: Int?
//  private var keysQueue: [CacheKey] = []
//
//  public init(records: RecordSet = RecordSet(), maxSize: Int? = nil) {
//    self.records = records
//    self.maxSize = maxSize
//  }
//
//  public func loadRecords(forKeys keys: Set<CacheKey>) throws -> [CacheKey: Record] {
//    return keys.reduce(into: [:]) { result, key in
//      result[key] = records[key]
//    }
//  }
//
//  public func removeRecord(for key: CacheKey) throws {
//    records.removeRecord(for: key)
//    keysQueue.removeAll { $0 == key }
//  }
//
//  public func merge(records newRecords: RecordSet) throws -> Set<CacheKey> {
//    let mergedKeys = records.merge(records: newRecords)
//    keysQueue.append(contentsOf: mergedKeys)
//
//    if let maxSize = maxSize, keysQueue.count > maxSize {
//      while keysQueue.count > maxSize {
//        if let key = keysQueue.first {
//          try removeRecord(for: key)
//        }
//      }
//    }
//
//    return mergedKeys
//  }
//
//  public func removeRecords(matching pattern: CacheKey) throws {
//    records.removeRecords(matching: pattern)
//    keysQueue.removeAll { $0 == pattern }
//  }
//
//  public func clear() {
//    records.clear()
//    keysQueue.removeAll()
//  }
//}
