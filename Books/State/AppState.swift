import Model
import ReSwift
import ReSwiftRouter

struct AppState: StateType {
  var books = State<BooksState, BooksState.Error>.notLoaded
  var navigation = NavigationState()
}
