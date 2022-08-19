import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview(_:))
    }
}

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

protocol ViewCoding {
    func addSubviews()
    func addConstraints()
    func additionalConfig()
    func buildView()
}

extension ViewCoding {
    func buildView() {
        addSubviews()
        addConstraints()
        additionalConfig()
    }
}

