import Foundation

protocol LeagueSocialMediaPresenting: AnyObject {
    var viewController: LeagueSocialMediaDisplaying? { get set }
    
    func presentPosts()
    func presentError(retryAction: @escaping () -> Void)
    func presentLoading()
    func hideLoading()
}

final class LeagueSocialMediaPresenter {
    weak var viewController: LeagueSocialMediaDisplaying?
    private let coordinator: LeagueSocialMediaCoordinating

    init(coordinator: LeagueSocialMediaCoordinating) {
        self.coordinator = coordinator
    }
}

extension LeagueSocialMediaPresenter: LeagueSocialMediaPresenting {
    
    func presentPosts() {
        viewController?.displayPosts()
    }
    
    func presentError(retryAction: @escaping () -> Void) {
        coordinator.perform(action: .error(retry: retryAction))
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func hideLoading() {
        viewController?.hideLoading()
    }
}
