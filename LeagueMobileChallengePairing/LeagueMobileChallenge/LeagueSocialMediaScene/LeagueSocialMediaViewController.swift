import UIKit

protocol LeagueSocialMediaDisplaying: AnyObject {}

private extension LeagueSocialMediaViewController.Layout {

    enum Size {
        static let tableViewHeight: CGFloat = 100
    }
}

final class LeagueSocialMediaViewController: UIViewController {
    enum Layout { }
    private let interactor: LeagueSocialMediaInteracting
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        setupTableView()
        updateDataSource()
    }
    
    init(interactor: LeagueSocialMediaInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        tableView.separatorStyle = .singleLine
        tableView.register(
            SocialMediaCell.self,
            forCellReuseIdentifier: SocialMediaCell.reuseIdentifier)
    
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.backgroundColor = .white
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Layout.Size.tableViewHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeagueSocialMediaViewController {
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SocialMediaViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems([.fixture(), .fixture(), .fixture()])
      
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension LeagueSocialMediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension LeagueSocialMediaViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
  }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}

private extension LeagueSocialMediaViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Int, SocialMediaViewModel> {

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, repository in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SocialMediaCell.reuseIdentifier,
                    for: indexPath
                ) as? SocialMediaCell
                
                cell?.setup(viewModel: repository)

                return cell
            }
        )
    }
}

extension LeagueSocialMediaViewController: LeagueSocialMediaDisplaying {}
