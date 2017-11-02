import ReSwift

public struct BooksState: StateType {
  public var books = [Book]()
  public init(books: [Book]) {
    self.books = books
  }

  public enum Error: Swift.Error {
    case cantLoad
  }
}

extension BooksState: Equatable {
  public static func ==(lhs: BooksState, rhs: BooksState) -> Bool {
    return lhs.books == rhs.books
  }
}

// MARK: - State for loadable things

public enum State<T: Equatable, E: Equatable>: StateType {
  case notLoaded
  case loading
  case success(T)
  case failure(E)
}

extension State: Equatable {
  public static func ==(lhs: State<T, E>, rhs: State<T, E>) -> Bool {
    switch (lhs, rhs) {
      case (.notLoaded, .notLoaded), (.loading, .loading): return true
      case (.success(let l), .success(let r)): return l == r
      case (.failure(let l), .failure(let r)): return l == r
      default: return false
    }
  }
}

