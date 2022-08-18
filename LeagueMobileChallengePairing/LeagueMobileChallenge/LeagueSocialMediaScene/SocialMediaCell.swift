import UIKit
import SnapKit
import Kingfisher

struct SocialMediaViewModel: Hashable {
    let id = UUID()
    let userName: String
    let title: String
    let description: String
    let avatar: String?
    
    var avatarURL: URL? {
        return URL(string: avatar ?? "")
    }
}

final class SocialMediaCell: UITableViewCell, ReusableView {
    
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
    
    private var postLabelContainer: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        
        return stack
    }()
    
    private var avatarContainer: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        
        return stack
    }()
    
    private var mainContainer: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }
    
    func setup(viewModel: SocialMediaViewModel) {
        userNameLabel.text = viewModel.userName
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        avatarImage.kf.setImage(with: viewModel.avatarURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetPropertieValues()
    }
    
    private func resetPropertieValues() {
        userNameLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""
        avatarImage.image = nil
    }
}

extension SocialMediaCell: ViewCoding {
    func addSubviews() {
        contentView.addSubview(mainContainer)
        mainContainer.addArrangedSubviews(avatarContainer, titleLabel, descriptionLabel)
        avatarContainer.addArrangedSubviews(avatarImage, userNameLabel)
    }
    
    func addConstraints() {
        mainContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        avatarImage.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
    }
    
    func additionalConfig() {
        contentView.backgroundColor = .white
    }
}

