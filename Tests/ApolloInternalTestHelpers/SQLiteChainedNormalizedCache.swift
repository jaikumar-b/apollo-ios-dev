import Apollo
import ApolloSQLite

// TODO: Add max size and eviction policies
public final class SQLiteChainedNormalizedCache: NormalizedCache {

  private let sqlite: SQLiteNormalizedCache

  init(sqlite: SQLiteNormalizedCache) {
      self.sqlite = sqlite
  }

  public func loadRecords(forKeys keys: Set<CacheKey>) throws -> [CacheKey: Apollo.Record] {
    return try sqlite.loadRecords(forKeys: keys)
  }

  public func removeRecord(for key: CacheKey) throws {
    return try sqlite.removeRecord(for: key)
  }

  public func merge(records newRecords: RecordSet, requestContext: RequestContext? = nil) throws -> Set<CacheKey> {
    if let requestContext = requestContext as? MockRequestContext {
      switch requestContext.storagePolicy {
      case .sqlite, .inMemoryAndSqlite:
        return try sqlite.merge(records: newRecords, requestContext: requestContext)
      default:
        return Set()
      }
    }
    return Set()
  }

  public func removeRecords(matching pattern: CacheKey) throws {
    return try sqlite.removeRecords(matching: pattern)
  }

  public func clear() throws {
    try sqlite.clear()
  }
}
