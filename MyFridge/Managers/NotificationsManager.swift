//
//  NotificationsManager.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 24.05.2020.
//  Copyright © 2020 Maxim Vitovitsky. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func sheduleNotifications(for products: [Product]) {
        removeNotifications()
        
        for product in products {
            let content = UNMutableNotificationContent()
            content.title = "Продукт скоро испортится!"
            content.body = "Завтра истечет срок годности продукта \(product.name)"
            content.sound = .default
            
            let date = product.shelfLifeEnd.date().byAddingDays(-1)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let identifier = product.id
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            notificationCenter.add(request) { error in
                if let error = error {
                    Logger.error("Notification error – \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
}
