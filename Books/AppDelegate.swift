import Model
import ReSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

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
      = { dispatch, getState in
        return BooksService().middleware(
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

    return true
  }
}

