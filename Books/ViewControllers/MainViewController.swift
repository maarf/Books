import ReSwift
import ReSwiftRouter
import UIKit

final class MainViewController: UISplitViewController {

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

  private(set) lazy var masterNavigationController: RoutableNavigationController<MainViewController> = {
    let controller = RoutableNavigationController<MainViewController>(
      rootViewController: EmptyViewController())
    controller.routingDelegate = self
    return controller
  }()

  private(set) lazy var detailNavigationController: RoutableNavigationController<MainViewController> = {
    let controller = RoutableNavigationController<MainViewController>(
      rootViewController: EmptyViewController())
    controller.routingDelegate = self
    controller.topViewController?.navigationItem.leftBarButtonItem =
      self.displayModeButtonItem
    return controller
  }()

  // MARK: - State

  fileprivate var isSeparating = false
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

  public func splitViewController(
    _ splitViewController: UISplitViewController,
    separateSecondaryFrom primaryViewController: UIViewController
  ) -> UIViewController? {
    isSeparating = true
    return nil
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

extension MainViewController: RoutableNavigationControllerDelegate {

  func routableNavigationController(
    _ rnc: RNC<MainViewController>,
    didPush vc: UIVC,
    animated: Bool,
    sender: Any?
  ) {
    // We don't need to do anything when pushing
  }

  func routableNavigationController(
    _ rnc: RNC<MainViewController>,
    didPop vc: UIVC,
    animated: Bool,
    sender: Any?
  ) {
    guard isSeparating == false else {
      isSeparating = false
      return
    }
    let newRoute = Array(store.state.navigation.route.dropLast())
    store.dispatch(SetRouteAction(newRoute))
  }
}
