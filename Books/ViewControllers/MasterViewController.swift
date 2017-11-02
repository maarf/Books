import ReSwift
import UIKit

class MasterViewController: UITableViewController {

  private let store: Store<AppState>

  init(store: Store<AppState>) {
    self.store = store
    super.init(style: .plain)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - State

  var objects = [
    Date(),
    Date(timeIntervalSinceNow: -60*60*1),
    Date(timeIntervalSinceNow: -60*60*2),
    Date(timeIntervalSinceNow: -60*60*3),
    Date(timeIntervalSinceNow: -60*60*4),
  ]

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return objects.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell: UITableViewCell
    if let reused = tableView.dequeueReusableCell(withIdentifier: "Cell") {
      cell = reused
    } else {
      cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    }

    let date = objects[indexPath.row]
    cell.textLabel?.text = date.description
    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let date = objects[indexPath.row]
    let detail = DetailViewController(store: store)
    detail.detailItem = date
    detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    detail.navigationItem.leftItemsSupplementBackButton = true

    if let main = splitViewController as? MainViewController {
      main.detailNavigationController.viewControllers = [detail]
      main.showDetailViewController(main.detailNavigationController, sender: self)
    }
  }
}
