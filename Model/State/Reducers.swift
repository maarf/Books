import ReSwift

public func booksReducer(action: Action, state: BooksState?) -> BooksState {
  var state = state ?? BooksState()
  switch action {
    case let action as SetBooksAction:
      state.books = action.books
    default: break
  }
  return state
}
