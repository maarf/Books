import ReSwift
import UIKit

class DetailViewController: UIViewController {

  private let store: Store<AppState>

  init(store: Store<AppState>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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

  var detailItem: Date? {
    didSet {
      detailsLabel.text = detailItem?.description ?? "None"
    }
  }

  private lazy var detailsLabel: UILabel = {
    let label = UILabel()
    label.text = "Detail"
    return label
  }()

}

