import ReSwift

public struct AuthorsState: StateType {
  public var authors = [Author]()
  public init() {}
}

public struct BooksState: StateType {
  public var books = [Book]()
  public init() {}
}
