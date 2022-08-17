import UIKit

enum LeagueSocialMediaAction {
    case back
}

protocol LeagueSocialMediaCoordinating: AnyObject {
    var viewController: UIViewController? { get set }

    func perform(action: LeagueSocialMediaAction)
}

final class LeagueSocialMediaCoordinator {
    weak var viewController: UIViewController?
}

extension LeagueSocialMediaCoordinator: LeagueSocialMediaCoordinating {
    func perform(action: LeagueSocialMediaAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
