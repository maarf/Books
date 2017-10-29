import UIKit

class MainViewController: UISplitViewController {

  override init(nibName: String?, bundle: Bundle?) {
    super.init(nibName: nibName, bundle: bundle)
    delegate = self
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    delegate = self
  }
}

extension MainViewController: UISplitViewControllerDelegate {
  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondary: UIViewController,
    onto primary: UIViewController
  ) -> Bool {
    guard
      let secondary = secondary as? UINavigationController,
      let detail = secondary.topViewController as? DetailViewController
    else { return false }
    if detail.detailItem == nil {
      // Return true to indicate that we have handled the collapse by doing
      // nothing; the secondary controller will be discarded.
      return true
    }
    return false
  }
}
