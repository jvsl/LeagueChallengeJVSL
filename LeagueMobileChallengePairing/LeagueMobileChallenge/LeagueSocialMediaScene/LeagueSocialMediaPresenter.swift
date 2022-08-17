import Foundation

protocol LeagueSocialMediaPresenting: AnyObject {
    var viewController: LeagueSocialMediaDisplaying? { get set }
}

final class LeagueSocialMediaPresenter {
    weak var viewController: LeagueSocialMediaDisplaying?
    private let coordinator: LeagueSocialMediaCoordinating

    init(coordinator: LeagueSocialMediaCoordinating) {
        self.coordinator = coordinator
    }
}

extension LeagueSocialMediaPresenter: LeagueSocialMediaPresenting {}
