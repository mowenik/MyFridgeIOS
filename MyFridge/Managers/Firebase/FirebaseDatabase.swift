//
//  FirebaseDatabase.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 23.05.2020.
//  Copyright © 2020 Maxim Vitovitsky. All rights reserved.
//

import FirebaseDatabase

class FirebaseDatabase {
    
    static let shared = FirebaseDatabase()
    
    let ref = Database.database().reference()

    
}
