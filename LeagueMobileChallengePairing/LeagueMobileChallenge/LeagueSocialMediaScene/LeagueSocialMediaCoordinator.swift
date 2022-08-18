import UIKit

enum LeagueSocialMediaAction {
    case error
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
        case .error:
            let errorViewController = FullScreenErrorViewController()
            viewController?.navigationController?.pushViewController(
                errorViewController, animated: true)
        }
    }
}
