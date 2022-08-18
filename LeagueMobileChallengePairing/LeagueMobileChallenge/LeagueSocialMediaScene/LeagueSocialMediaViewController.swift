import UIKit

protocol LeagueSocialMediaDisplaying: AnyObject {
    func display(_ posts: [SocialMediaViewModel])
    func displayLoading()
    func hideLoading()
}

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
        interactor.fetchPosts()
    }
    
    init(interactor: LeagueSocialMediaInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.prefetchDataSource = self
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
    func updateDataSource(data: [SocialMediaViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SocialMediaViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
      
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension LeagueSocialMediaViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        interactor.prefechImages(indexPaths: indexPaths)
        print("PREFETCHING \(indexPaths)")
    }
    
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        interactor.cancelPrefetchingImages(indexPaths: indexPaths)
        print("CANCEL PREFETCHING \(indexPaths)")
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

extension LeagueSocialMediaViewController: LeagueSocialMediaDisplaying {
    func display(_ posts: [SocialMediaViewModel]) {
        updateDataSource(data: posts)
    }
    
    func displayLoading() {
        LLSpinner.spin(style: .large, backgroundColor: UIColor(white: 0, alpha: 0.6))
    }
    
    func hideLoading() {
        LLSpinner.stop()
    }
}
