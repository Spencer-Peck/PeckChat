//
//  FriendService.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FriendService {
    
    
    // sets the user and currentUser as friends in Firebase
    static func AcceptFriendRequest(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = User.current.uid
        let friendRequestData = ["friends/\(user.uid)/\(currentUID)" : true,
                          "friends/\(currentUID)/\(user.uid)" : true]

        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(friendRequestData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }

            // 3
            success(error == nil)
        }
    }
    
    // Delete friendship of user and currentUser
    
    static func DeleteFrienship(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = User.current.uid
        let friendRequestData = ["friends/\(user.uid)/\(currentUID)" : NSNull(),
                          "friends/\(currentUID)/\(user.uid)" : NSNull()]

        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(friendRequestData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }

            // 3
            success(error == nil)
        }
    }
    
    static func isFriendship(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("friends").child(user.uid)

        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
    
}
