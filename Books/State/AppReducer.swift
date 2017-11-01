import Model
import ReSwift
import ReSwiftRouter

func appReducer(action: Action, state: AppState?) -> AppState {
  var state = state ?? AppState()
  state.books = booksReducer(action: action, state: state.books)
  state.navigation = NavigationReducer.handleAction(action, state: state.navigation)
  return state
}
