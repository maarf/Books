import Foundation
import Result
import ReSwift

public class BooksService {

  public init() {}

  public func middleware(
    dispatch: @escaping DispatchFunction,
    getState: @escaping () -> BooksState?
  ) -> (@escaping DispatchFunction) -> DispatchFunction {
    return { next in
      return { action in
        return next(action)
      }
    }
  }

  enum FetchingError: Error {
    case cantFetch
    case noData
    case cantDecode
  }

  func fetchBooks(completionHandler: @escaping (Result<[Book], FetchingError>) -> ()) {
    let session = URLSession(configuration: .default)
    let url = URL(string: "https://raw.githubusercontent.com/maarf/Books/master/Fixtures/Books.json")!
    let dataTask = session.dataTask(with: url) { data, response, error in
      if let _ = error {
        completionHandler(Result(error: .cantFetch))
        return
      }
      guard let data = data else {
        completionHandler(Result(error: .noData))
        return
      }
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let fetchResponse = try decoder.decode(FetchResponse.self, from: data)
        completionHandler(Result(value: fetchResponse.books))
      } catch {
        completionHandler(Result(error: .cantDecode))
      }
    }
    dataTask.resume()
  }

  private struct FetchResponse: Codable {
    var books: [Book]
  }
}
