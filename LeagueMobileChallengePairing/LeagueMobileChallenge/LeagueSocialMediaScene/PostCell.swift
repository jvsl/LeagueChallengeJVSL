import UIKit
import SnapKit
import Kingfisher

struct PostViewModel: Hashable {
    let userName: String
    let title: String
    let description: String
    let avatar: String?
    
    var avatarURL: URL? {
        return URL(string: avatar ?? "")
    }
}

private extension PostCell.Layout {

    enum Constants {
        static let avatarSize: CGFloat = 50
        static let mainContainerPadding: CGFloat = 16
        static let stackSpacing: CGFloat = 10
    }
}

final class PostCell: UITableViewCell, ReusableView {
    enum Layout { }
    private lazy var userNameLabel = makeLabel()
    private lazy var titleLabel = makeLabel()
    private lazy var descriptionLabel = makeLabel()
    private var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            imageView.layer.cornerRadius = imageView.frame.height/2
        }
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.yellow.cgColor
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        
        return imageView
    }()
    
    private lazy var postLabelContainer = makeStackView(.horizontal)
    private lazy var avatarContainer = makeStackView(.horizontal)
    private lazy var mainContainer: UIStackView = makeStackView(.vertical)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetPropertieValues()
    }
    
    func setup(viewModel: PostViewModel) {
        userNameLabel.text = viewModel.userName
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        avatarImage.kf.setImage(with: viewModel.avatarURL)
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }
    
    private func makeStackView(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = Layout.Constants.stackSpacing
        stack.axis = axis
        
        return stack
    }
    
    private func resetPropertieValues() {
        userNameLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""
        avatarImage.image = nil
    }
}

extension PostCell: ViewCoding {
    func addSubviews() {
        contentView.addSubview(mainContainer)
        mainContainer.addArrangedSubviews(avatarContainer, titleLabel, descriptionLabel)
        avatarContainer.addArrangedSubviews(avatarImage, userNameLabel)
    }
    
    func addConstraints() {
        mainContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Layout.Constants.mainContainerPadding)
        }
        avatarImage.snp.makeConstraints {
            $0.width.height.equalTo(Layout.Constants.avatarSize)
        }
    }
    
    func additionalConfig() {
        contentView.backgroundColor = .white
    }
}

