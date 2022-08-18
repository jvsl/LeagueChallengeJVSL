import UIKit

final class LLSpinner {
    internal static var spinnerView: UIActivityIndicatorView?
    private static let style: UIActivityIndicatorView.Style = .whiteLarge
    private static let backgroundColor: UIColor = UIColor(white: 0, alpha: 0.6)
    private static let window = UIApplication.shared.keyWindow
    private static let frame = UIScreen.main.bounds
    
    static func spin(
        style: UIActivityIndicatorView.Style = style,
        backgroundColor: UIColor = backgroundColor) {
        
        spinnerView = UIActivityIndicatorView(frame: frame)
            
        spinnerView?.backgroundColor = backgroundColor
        spinnerView?.style = style
        window?.addSubview(spinnerView ?? UIView())
        spinnerView?.startAnimating()
    }
    
    static func stop() {
        if let _ = spinnerView {
            spinnerView?.stopAnimating()
            spinnerView?.removeFromSuperview()
            spinnerView = nil
        }
    }
}
