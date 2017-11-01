public struct Book: Codable {
  var id: String
  var author: String
  var title: String
  var publishedAt: Date
  var coverURL: URL
}
