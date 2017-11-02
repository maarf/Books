import Foundation
import Result
import ReSwift

public class BooksService {

  public init() {}

  public func middleware(
    dispatch: @escaping DispatchFunction,
    getState: @escaping () -> State<BooksState, BooksState.Error>?
  ) -> (@escaping DispatchFunction) -> DispatchFunction {
    return { next in
      return { [weak self] action in
        guard let service = self else { return next(action) }

        switch action {
          case is RefreshBooks:
            dispatch(SetBooks.loading)
            service.fetchBooks { result in
              switch result {
                case .success(let books):
                  dispatch(SetBooks.success(books: books))
                case .failure(let error):
                  dispatch(SetBooks.failure(error: error))
              }
            }
            return

          case SetBooks.success(let books):
            service.store(books: books)

          case is ReSwiftInit:
            guard let books = service.load() else { break }
            dispatch(SetBooks.success(books: books))

          default: break
        }
        return next(action)
      }
    }
  }

  // MARK: - Networking

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

  // MARK: - Storage

  private lazy var localDataURL: URL = {
    let documentDirectory = try! FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false)
    return documentDirectory.appendingPathComponent("books.json")
  }()

  func store(books: [Book]) {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    do {
      let data = try encoder.encode(books)
      try data.write(to: localDataURL)
    } catch {
      NSLog("[BooksService] Can't store data: \(error)")
    }
  }

  func load() -> [Book]? {
    do {
      let data = try Data(contentsOf: localDataURL)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode([Book].self, from: data)
    } catch {
      NSLog("[BooksService] Can't load data: \(error)")
      return nil
    }
  }

}
