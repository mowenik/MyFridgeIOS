import UIKit

struct TabBar {
    
    // MARK: - Public.
    
    static var viewControllers: [UIViewController] {
        return [products, addProducts, groupSettings]
    }
    
    // MARK: - Private.
    
    private static var products: UIViewController {
        let viewController = ProductsVC.instance()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_fridge"), selectedImage: UIImage(named: "ic_fridge_active"))
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        return navigationController
    }
    
    private static var addProducts: UIViewController {
        let viewController = AddProductsVC.instance()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_add"), selectedImage: nil)
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        return navigationController
    }
    
    private static var groupSettings: UIViewController {
        let viewController = GroupVC.instance()
        viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_group"), selectedImage: nil)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        
        return viewController
    }
    
}
