import ReSwift

public struct SetBooksAction: Action {
  public var books: [Book]
  public init(books: [Book]) {
    self.books = books
  }
}
