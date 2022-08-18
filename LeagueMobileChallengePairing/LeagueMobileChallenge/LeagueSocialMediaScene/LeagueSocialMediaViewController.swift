import UIKit

protocol LeagueSocialMediaDisplaying: AnyObject {
    func displayPosts()
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
    fileprivate let tableView = UITableView()
    
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
        tableView.dataSource = self
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

extension LeagueSocialMediaViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        interactor.prefechImages(indexPaths: indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        interactor.cancelPrefetchingImages(indexPaths: indexPaths)
    }
}

extension LeagueSocialMediaViewController: UITableViewDataSource, LeagueSocialMediaDisplaying {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SocialMediaCell.reuseIdentifier,
            for: indexPath
        ) as? SocialMediaCell
        
        let viewModel = interactor.socialMediaViewModelData()[indexPath.row]
        cell?.setup(viewModel: viewModel)
        
        return cell ?? UITableViewCell()
    }

    func displayPosts() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayLoading() {
        if #available(iOS 13.0, *) {
            LLSpinner.spin(style: .large, backgroundColor: UIColor(white: 0, alpha: 0.6))
        } else {
            LLSpinner.spin(style: .whiteLarge, backgroundColor: UIColor(white: 0, alpha: 0.6))
        }
    }
    
    func hideLoading() {
        LLSpinner.stop()
    }
}
