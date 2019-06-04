//
//  ProductsVC.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 17/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit
import UserNotifications

class ProductsVC: BaseVC {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeholderView: UIView!
    
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellReuseID: ProductCollectionCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func updateData() {
        products = ProductsManager.getSavedProducts()
        collectionView.reloadData()
        
        setPlaceholderHidden(products.count != 0)
    }
    
    func setPlaceholderHidden(_ isHidden: Bool) {
        if placeholderView.isHidden == isHidden { return }
        
        UIView.animate(withDuration: 0.5) {
            self.placeholderView.alpha = isHidden ? 0 : 1
            self.placeholderView.isHidden = isHidden
        }
    }

    @IBAction func addButtonAction(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        
//        requestPermissions()
    }
    
    func requestPermissions() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            guard didAllow else {
                print("User has declined notifications")
                return
            }
            
            self.sendNotification()
        }
    }
    
    func sendNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent(), trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("Send!")
            }
        }
    }
    
    func notificationContent() -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        
        content.body = "Кажется, Молоко скоро испортится!"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        return content
    }
}

extension ProductsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.reuseID, for: indexPath) as! ProductCollectionCell
        let product = products[indexPath.row]
        
        cell.setup(withProduct: product)
        
        return cell
    }
    
}

extension ProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 30) / 2
        return CGSize(width: side, height: side * 1.5)
    }
    
}

extension ProductsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let product = products[indexPath.row]
        let controller = ProductDetailsVC.instance(product: product)
        Router.show(controller: controller)
    }
    
}



