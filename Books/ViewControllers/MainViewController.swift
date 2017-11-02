import ReSwift
import ReSwiftRouter
import UIKit

class MainViewController: UISplitViewController {

  private let store: Store<AppState>

  init(store: Store<AppState>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
    delegate = self

    viewControllers = [
      masterNavigationController,
      detailNavigationController,
    ]
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  // MARK: - Navigation controllers

  private(set) lazy var masterNavigationController: UINavigationController = {
    return UINavigationController(
      rootViewController: MasterViewController(store: store))
  }()

  private(set) lazy var detailNavigationController: UINavigationController = {
    let controller = UINavigationController(
      rootViewController: EmptyViewController())
    controller.topViewController?.navigationItem.leftBarButtonItem =
      self.displayModeButtonItem
    return controller
  }()
}

extension MainViewController: UISplitViewControllerDelegate {
  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondary: UIViewController,
    onto primary: UIViewController
  ) -> Bool {
    if let secondary = secondary as? UINavigationController {
      // Return true to indicate that we have handled the collapse by doing
      // nothing; the secondary controller will be discarded.
      if
        let detail = secondary.topViewController as? DetailViewController,
        detail.detailItemId == nil
      {
        return true
      }
      if secondary.topViewController is EmptyViewController {
        return true
      }
    }
    return false
  }
}

extension MainViewController: Routable {
  func pushRouteSegment(
    _ route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    switch route {
      case "Books":
        let master = MasterViewController(store: store)
        masterNavigationController.viewControllers = [master]
        completionHandler()
        return master
      default:
        fatalError("[MainViewController] Can't push unhandled route: \(route)")
    }
  }
}
