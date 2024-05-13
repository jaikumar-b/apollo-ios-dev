import Apollo
import Foundation

enum StoragePolicy {
  case inMemory
  case sqlite
  case inMemoryAndSqlite
}

struct MockRequestContext: RequestContext {
  let storagePolicy: StoragePolicy
  let ttl: TimeInterval
}
