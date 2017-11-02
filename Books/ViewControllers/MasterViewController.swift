import Model
import ReSwift
import ReSwiftRouter
import UIKit

class MasterViewController: UITableViewController, StoreSubscriber {

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

    store.subscribe(self) { $0.select { $0.books } }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    store.unsubscribe(self)
  }

  // MARK: - State

  func newState(state: State<BooksState, BooksState.Error>) {
    switch state {
      case .success(let booksState):
        books = booksState.books
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      default: break
    }
  }

  var books = [Book]()

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return books.count
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

    let book = books[indexPath.row]
    cell.textLabel?.text = book.title
    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let book = books[indexPath.row]
    store.dispatch(SetRouteAction(["Books", "Detail", book.id]))
  }
}

extension MasterViewController: Routable {

  func pushRouteSegment(
    _ route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    switch route {
      case "Detail":
        let detail = DetailViewController(store: store)
        detail.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        detail.navigationItem.leftItemsSupplementBackButton = true

        if let main = splitViewController as? MainViewController {
          main.detailNavigationController.viewControllers = [detail]
          if (animated) {
            main.showDetailViewController(main.detailNavigationController, sender: self)
            // TODO: Call completion handler after animation finishes
            completionHandler()
          } else {
            UIView.performWithoutAnimation {
              main.showDetailViewController(main.detailNavigationController, sender: self)
              completionHandler()
            }
          }
        }
        return detail
      default:
        fatalError("[MasterViewController] Can't push unhandled route: \(route)")
    }
  }

  func popRouteSegment(
    _ route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) {
    switch route {
      case "Detail":
        if let main = splitViewController as? MainViewController {
          main.detailNavigationController.viewControllers = [EmptyViewController()]
          if animated {
            main.show(main.masterNavigationController, sender: self)
            // TODO: Call completion handler after animation finishes
            completionHandler()
          } else {
            UIView.performWithoutAnimation {
              main.show(main.masterNavigationController, sender: self)
              completionHandler()
            }
          }
        }
      default:
        fatalError("[MasterViewController] Can't pop unhandled route: \(route)")
    }
  }
}
