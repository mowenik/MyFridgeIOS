import UIKit

class Router {
    
    class func show(controller: UIViewController, inNavigation: Bool = true) {
        showOnTopController(controller, inNavigation: inNavigation)
    }
    
    private class func showOnTopController(_ viewController: UIViewController, inNavigation: Bool = true, animated: Bool = true) {
        let topController = UIApplication.topViewController
        
        if let navController = topController?.navigationController, inNavigation {
            navController.pushViewController(viewController, animated: animated)
            return
        }
        
        if let topViewController = topController {
            topViewController.present(viewController, animated: animated, completion: nil)
            return
        }
    }
    
}

