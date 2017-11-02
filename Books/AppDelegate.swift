import Model
import ReSwift
import ReSwiftRouter
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  private let booksService = BooksService()
  private var router: Router<AppState>?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let loggingMiddleware:
      (@escaping DispatchFunction, @escaping () -> AppState?)
      -> (@escaping DispatchFunction)
      -> DispatchFunction
      = { dispatch, getState in
        return { next in
          return { action in
            NSLog("[Store] Dispatching action: \(action)")
            next(action)
          }
        }
      }
    let booksMiddleware:
      (@escaping DispatchFunction, @escaping () -> AppState?)
      -> (@escaping DispatchFunction)
      -> DispatchFunction
      = { [weak self] dispatch, getState in
        guard let app = self else { return { n in return { a in n(a) } } }
        return app.booksService.middleware(
          dispatch: dispatch,
          getState: { getState()?.books })
      }
    let store = Store<AppState>(
      reducer: appReducer,
      state: nil,
      middleware: [
        loggingMiddleware,
        booksMiddleware
      ])

    let main = MainViewController(store: store)

    router = Router(
      store: store,
      rootRoutable: main,
      stateTransform: { $0.select { $0.navigation } })

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = main
    window.makeKeyAndVisible()
    self.window = window

    DispatchQueue.main.async {
      store.dispatch(SetRouteAction(["Books"]))
      store.dispatch(RefreshBooks())
    }

    return true
  }
}

