import UIKit

protocol LeagueSocialMediaDisplaying: AnyObject {}

private extension LeagueSocialMediaViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class LeagueSocialMediaViewController: UIViewController {
    enum Layout { }
    private let interactor: LeagueSocialMediaInteracting
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(interactor: LeagueSocialMediaInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeagueSocialMediaViewController: LeagueSocialMediaDisplaying {}
