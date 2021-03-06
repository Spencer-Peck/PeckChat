//
//  User.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/23/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {

    // MARK: - Properties

    let uid: String
    let username: String
    var isRequested = false
    var isFriends = false

    // MARK: - Init

    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }

        self.uid = snapshot.key
        self.username = username
    }
    
    // MARK: - Singleton

    // 1
    private static var _current: User?

    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }

        // 4
        return currentUser
    }

    // MARK: - Class Methods

    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            
            if let data = try? JSONEncoder().encode(user) {
                
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }

        _current = user
    }
    
}
