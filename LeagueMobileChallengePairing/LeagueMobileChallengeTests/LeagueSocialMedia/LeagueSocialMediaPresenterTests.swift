import XCTest
@testable import LeagueMobileChallenge

final class LeagueSocialMediaPresenterTests: XCTestCase {
    private var viewControllerSpy = LeagueSocialMediaViewControllerSpy()
    private var coordinatorSpy = LeagueSocialMediaCoordintorSpy()
    private lazy var sut: LeagueSocialMediaPresenting = {
       let presenter = LeagueSocialMediaPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentPosts() {
        sut.presentPosts()
        
        XCTAssertEqual(viewControllerSpy.didDisplayPosts, 1)
    }
    
    func testPresentLoading() {
        sut.presentLoading()
        
        XCTAssertEqual(viewControllerSpy.didDisplayLoading, 1)
    }
    
    func testHideLoading() {
        sut.hideLoading()
        
        XCTAssertEqual(viewControllerSpy.didHideLoading, 1)
    }
}

final class LeagueSocialMediaCoordintorSpy: LeagueSocialMediaCoordinating {
    var viewController: UIViewController?
    var action: LeagueSocialMediaAction?
    
    func perform(action: LeagueSocialMediaAction) {
        self.action = action
    }
}

final class LeagueSocialMediaViewControllerSpy: LeagueSocialMediaDisplaying {
    var didDisplayPosts = 0
    var didDisplayLoading = 0
    var didHideLoading = 0
    
    func displayPosts() {
        didDisplayPosts += 1
    }
    
    func displayLoading() {
        didDisplayLoading += 1
    }
    
    func hideLoading() {
        didHideLoading += 1
    }
}
