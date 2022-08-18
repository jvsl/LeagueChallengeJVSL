import UIKit

public final class ViewControllerSpy: UIViewController {
    public private(set) var callPresentControllerCount = 0
    public private(set) var callDismissControllerCount = 0
    public private(set) var viewControllerPresented = UIViewController()

    public init() { super.init(nibName: nil, bundle: nil) }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        callPresentControllerCount += 1
        viewControllerPresented = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        callDismissControllerCount += 1
        super.dismiss(animated: flag, completion: completion)
    }
}
