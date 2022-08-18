import Foundation

protocol LeagueSocialMediaPresenting: AnyObject {
    var viewController: LeagueSocialMediaDisplaying? { get set }
    
    func present(_ posts: [SocialMediaViewModel])
    func presentError()
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
    
    func present(_ posts: [SocialMediaViewModel]) {
        viewController?.display(posts)
    }
    
    func presentError() {
        coordinator.perform(action: .error)
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func hideLoading() {
        viewController?.hideLoading()
    }
}
