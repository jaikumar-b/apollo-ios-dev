import Foundation

class AsynchronousOperation: Operation {
  class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
    return ["state"]
  }
  
  class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
    return ["state"]
  }
  
  enum State {
    case initialized
    case ready
    case executing
    case finished
  }
  
  var state: State = .initialized {
    willSet {
      willChangeValue(forKey: "state")
    }
    didSet {
      print(state)
      didChangeValue(forKey: "state")
    }
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override var isReady: Bool {
    let ready = super.isReady
    if ready {
      state = .ready
    }
    return ready
  }
  
  override var isExecuting: Bool {
    return state == .executing
  }
  
  override var isFinished: Bool {
    return state == .finished
  }
}
