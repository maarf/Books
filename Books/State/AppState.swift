import Model
import ReSwift
import ReSwiftRouter

struct AppState: StateType {
  var books = BooksState()
  var navigation = NavigationState()
}
