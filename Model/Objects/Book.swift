public struct Book: Codable, Equatable {
  public var id: String
  public var author: String
  public var title: String
  public var publishedAt: Date
  public var coverURL: URL

  public static func ==(lhs: Book, rhs: Book) -> Bool {
    return lhs.id == rhs.id
      && lhs.author == rhs.author
      && lhs.title == rhs.title
      && lhs.publishedAt == rhs.publishedAt
      && lhs.coverURL == rhs.coverURL
  }
}
