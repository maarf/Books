import ReSwift

public enum SetBooks: Action {
  case loading
  case success(books: [Book])
  case failure(error: Error)
}

public struct RefreshBooks: Action {
  public init() {}
}
