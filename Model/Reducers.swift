import ReSwift

public func authorsReducer(action: Action, state: AuthorsState?) -> AuthorsState {
  var state = state ?? AuthorsState()
  switch action {
    case let action as SetAuthorsAction:
      state.authors = action.authors
    default: break
  }
  return state
}

public func booksReducer(action: Action, state: BooksState?) -> BooksState {
  var state = state ?? BooksState()
  switch action {
    case let action as SetBooksAction:
      state.books = action.books
    default: break
  }
  return state
}
