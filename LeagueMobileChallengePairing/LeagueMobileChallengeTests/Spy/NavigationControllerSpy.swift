import UIKit

public final class NavigationControllerSpy: UINavigationController {

    public private(set) var callPresentViewControllerCount: Int = 0

    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        callPresentViewControllerCount += 1
        super.present(viewControllerToPresent, animated: false)
        completion?()
    }
}
