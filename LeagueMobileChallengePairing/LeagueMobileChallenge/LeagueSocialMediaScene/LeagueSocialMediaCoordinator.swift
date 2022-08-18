import UIKit

enum LeagueSocialMediaAction {
    case error(retry: () -> Void)
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
        case let .error(action):
            let errorViewController = FullScreenErrorViewController()
            errorViewController.tryAgainAction = action
            errorViewController.modalPresentationStyle = .fullScreen
            viewController?.present(errorViewController, animated: true)
        }
    }
}
