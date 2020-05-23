//
//  GroupManager.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 23.05.2020.
//  Copyright © 2020 Maxim Vitovitsky. All rights reserved.
//

import Foundation

let UD_GROUP_KEY = "groupKey"

class GroupManager {
    
    // MARK: - Singleton.
    
    static let shared = GroupManager()
    
    
    // MARK: - Properties.
    
    var groupID: String {
        get {
            var id = UserDefaults.standard.string(forKey: UD_GROUP_KEY)

            if id == nil {
                id = generateGroupID()
                UserDefaults.standard.set(generateGroupID(), forKey: UD_GROUP_KEY)
            }

            return id!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UD_GROUP_KEY)
        }
    }
    
    // MARK: - Private.
    
    private func generateGroupID() -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<8).map{ _ in letters.randomElement()! })
    }
    
}
