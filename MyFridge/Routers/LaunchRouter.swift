import UIKit

struct LaunchRouter {
    
    enum Destination {
        case products
    }
    
    // MARK: - Public.
    
    static func to(_ destination: Destination) {
        switch destination {
        case .products:
            show(with: TabBarController())
        }
    }
    
    // MARK: - Private.
    
    private static func show(with viewController: UIViewController) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
}
