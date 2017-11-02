import Model
import ReSwift
import ReSwiftRouter
import UIKit

class DetailViewController: UIViewController, StoreSubscriber {

  private let store: Store<AppState>

  init(store: Store<AppState>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func loadView() {
    super.loadView()

    view.backgroundColor = .white

    view.addSubview(detailsLabel)
    detailsLabel.translatesAutoresizingMaskIntoConstraints = false
    let topConstraint = detailsLabel.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor,
      constant: 10)
    let leadingConstraint = detailsLabel.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: 10)
    NSLayoutConstraint.activate([topConstraint, leadingConstraint])
  }

  var isVisible = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isVisible = true

    store.subscribe(self) { $0.select { $0.books } }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    isVisible = false

    store.unsubscribe(self)
  }

  // MARK: - State

  var detailItemId: String? {
    didSet {
      guard detailItemId != oldValue else { return }
      // If the view is visible and the book id is updated, we need to ask store
      // for state because we don't keep it locally and the book state has not
      // changed nor we will be subscribing, because the controller is visible
      // and is already a subscriber.
      if isVisible {
        process(state: store.state.books)
      }
    }
  }

  func newState(state: State<BooksState, BooksState.Error>) {
    process(state: state)
  }

  private func process(state: State<BooksState, BooksState.Error>) {
    if
      case .success(let booksState) = state,
      let bookId = detailItemId,
      let book = find(bookId: bookId, in: booksState)
    {
      configure(with: book)
    }
  }

  private func find(bookId: String, in state: BooksState) -> Book? {
    return state.books.first { $0.id == bookId }
  }

  // MARK: - Views

  private func configure(with book: Book) {
    detailsLabel.text = book.title
  }

  private lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.text = "Detail"
    return label
  }()
}

extension DetailViewController: Routable {

  func pushRouteSegment(
    _ route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    detailItemId = route
    completionHandler()
    return self
  }

  func changeRouteSegment(
    _ oldRoute: RouteElementIdentifier,
    to route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) -> Routable {
    detailItemId = route
    completionHandler()
    return self
  }

  func popRouteSegment(
    _ route: RouteElementIdentifier,
    animated: Bool,
    completionHandler: @escaping RoutingCompletionHandler
  ) {
    // This is a leaf controller, meaning that it's route is actually an id of
    // the content, so we remove additional segment form the route
    detailItemId = nil
    let newRoute = Array(store.state.navigation.route.dropLast())
    store.dispatch(SetRouteAction(newRoute))
    completionHandler()
  }
}
