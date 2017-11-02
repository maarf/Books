import Model
import ReSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let booksService = BooksService()

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

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = MainViewController(store: store)
    window.makeKeyAndVisible()
    self.window = window

    DispatchQueue.main.async {
      store.dispatch(RefreshBooks())
    }

    return true
  }
}

