import ReSwift

public func booksReducer(
  action: Action,
  state: State<BooksState, BooksState.Error>?
) -> State<BooksState, BooksState.Error> {
  var state = state ?? State<BooksState, BooksState.Error>.notLoaded
  switch action {
    case SetBooks.loading:
      state = .loading
    case SetBooks.success(let books):
      state = .success(BooksState(books: books))
    case SetBooks.failure(_):
      state = .failure(BooksState.Error.cantLoad)
    default: break
  }
  return state
}
