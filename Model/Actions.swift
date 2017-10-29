import ReSwift

public struct SetAuthorsAction: Action {
  public var authors: [Author]
  public init(authors: [Author]) {
    self.authors = authors
  }
}

public struct SetBooksAction: Action {
  public var books: [Book]
  public init(books: [Book]) {
    self.books = books
  }
}
