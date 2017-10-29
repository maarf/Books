import Model
import ReSwift
import ReSwiftRouter

struct AppState: StateType {
  var authors = AuthorsState()
  var books = BooksState()
  var navigation = NavigationState()
}
