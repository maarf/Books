import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let main = window!.rootViewController as! MainViewController
    let navigation = main.viewControllers[main.viewControllers.count-1] as! UINavigationController
    navigation.topViewController!.navigationItem.leftBarButtonItem = main.displayModeButtonItem
    return true
  }
}

