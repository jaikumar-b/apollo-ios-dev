import Apollo

// TODO: Add max size and eviction policies
public final class InMemoryChainedNormalizedCache: NormalizedCache {

  private let inMemoryCache: InMemoryNormalizedCache

  init(inMemoryCache: InMemoryNormalizedCache = InMemoryNormalizedCache()) {
      self.inMemoryCache = inMemoryCache
  }

  public func loadRecords(forKeys keys: Set<CacheKey>) throws -> [CacheKey: Record] {
    return try inMemoryCache.loadRecords(forKeys: keys)
  }

  public func removeRecord(for key: CacheKey) throws {
    return try inMemoryCache.removeRecord(for: key)
  }

  public func merge(records newRecords: RecordSet, requestContext: RequestContext? = nil) throws -> Set<CacheKey> {
    return try inMemoryCache.merge(records: newRecords, requestContext: requestContext)
  }

  public func removeRecords(matching pattern: CacheKey) throws {
    return try inMemoryCache.removeRecords(matching: pattern)
  }

  public func clear() {
    inMemoryCache.clear()
  }
}
