import UIKit

struct TabBar {
    
    // MARK: - Public.
    
    static var viewControllers: [UIViewController] {
        return [products, addProducts]
    }
    
    // MARK: - Private.
    
    private static let imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
    
    private static var products: UIViewController {
        let viewController = ProductsVC.instance()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_fridge"), selectedImage: UIImage(named: "ic_fridge_active"))
        navigationController.tabBarItem.imageInsets = imageInsets
        
        return navigationController
    }
    
    private static var addProducts: UIViewController {
        let viewController = AddProductsVC.instance()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_add"), selectedImage: nil)
        navigationController.tabBarItem.imageInsets = imageInsets
        
        return navigationController
    }
    
}
