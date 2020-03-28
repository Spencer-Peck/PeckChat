//
//  FriendRequestService.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FriendRequestService {
    
    static func sendFriendRequest(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        //let checkRef = Database.database().reference().child("requestsRecieved").child(User.current.uid)
        //let query = checkRef.queryEqual(toValue: user.uid)

        // 1
        let currentUID = User.current.uid
        
        let friendRequestData = ["requestsRecieved/\(user.uid)/\(currentUID)" : true,
                          "requestsSent/\(currentUID)/\(user.uid)" : true]

        // 2
        let ref = Database.database().reference()
            ref.updateChildValues(friendRequestData) { (error, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }

                // 3
                success(error == nil)
                //success(true)
            }
    }
    
    static func deleteFriendRequest(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = User.current.uid
        let friendRequestData = ["requestsRecieved/\(user.uid)/\(currentUID)" : NSNull(),
                          "requestsSent/\(currentUID)/\(user.uid)" : NSNull()]

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
    
    static func deleteOtherUserFriendRequest(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = User.current.uid
        let friendRequestData = ["requestsRecieved/\(currentUID)/\(user.uid)" : NSNull(),
                          "requestsSent/\(user.uid)/\(currentUID)" : NSNull()]
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
    
    static func setIsFriendRequest(_ isFriendRequest: Bool, fromCurrentUserTo requester: User, success: @escaping (Bool) -> Void) {
        
        var requestExists = false
        let checkRef = Database.database().reference()

        checkRef.child("requestsRecieved").child(User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild(requester.uid){

                //print("Request already exists!")
                requestExists = true
                 //success(false)
             }
            
            if ((isFriendRequest) && (!requestExists)) {
                sendFriendRequest(requester, forCurrentUserWithSuccess: success)
                //print()
            } else if !isFriendRequest {
                deleteFriendRequest(requester, forCurrentUserWithSuccess: success)
            } else {
                success(false)
            }


         })
        
    }
    
    static func isRequestSent(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("requestsRecieved").child(user.uid)

        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    static func isRequestRecieved(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("requestsRecieved").child(currentUID)

        ref.queryEqual(toValue: nil, childKey: user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
}


