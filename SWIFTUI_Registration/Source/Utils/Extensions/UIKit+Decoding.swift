import UIKit
// MARK: -
// MARK: UIViewController
extension UIViewController {

    class func from(storyboardNamed name: String, identifier: String? = nil, bundle: Bundle) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return self.from(storyboard: storyboard, identifier: identifier)
    }

    class func from(storyboard: UIStoryboard, identifier: String? = nil) -> Self {
        let targetIdentifier = identifier ?? String(describing: self)
        return storyboard.viewController(named: targetIdentifier)
    }
}

// MARK: -
// MARK: Private
private extension UIStoryboard {

    func viewController<T>(named: String) -> T {
        return self.instantiateViewController(withIdentifier: named) as! T
    }
}
