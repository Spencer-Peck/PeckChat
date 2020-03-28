//
//  UserService.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    //Create Service
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]

        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }

            completion(user)
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")

        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            // 3
            var users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }

            // 4
            var i = 0
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()

                // 5
                FriendRequestService.isRequestSent(user) { (isRequested) in
                    user.isRequested = isRequested
                    
                    FriendService.isFriendship(user) { (isFriends) in
                        user.isFriends = isFriends
                        print(user.isFriends)
                        if (user.isFriends) {
                            users.remove(at: i)
                            i -= 1
                        }
                        
                        i += 1
                        dispatchGroup.leave()
                    }
                }
            }

            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func usersWhoAreFriends(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")

        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            // 3
            var users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }

            // 4
            var i = 0
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                FriendService.isFriendship(user) { (isFriends) in
                    user.isFriends = isFriends
                    print(user.isFriends)
                    if (!user.isFriends) {
                        users.remove(at: i)
                        i -= 1
                    }
                    
                    i += 1
                    dispatchGroup.leave()
                }
            }

            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func pendingFriendRequests(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")

        // 2
        ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            // 3
            var users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }

            // 4
            let dispatchGroup = DispatchGroup()
            var i = 0;
            users.forEach { (user) in
                dispatchGroup.enter()

                // 5
                FriendRequestService.isRequestRecieved(user) { (isRequested) in
                    user.isRequested = isRequested
                    print("user is: ")
                    print(user.isRequested)
                    if (!user.isRequested) {
                        users.remove(at: i)
                        i -= 1
                    }
                    
                    i += 1
                    dispatchGroup.leave()
                }
            }

            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func observeChats(for user: User = User.current, withCompletion completion: @escaping (DatabaseReference, [Chat]) -> Void) -> DatabaseHandle {
        let ref = Database.database().reference().child("chats").child(user.uid)

        return ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion(ref, [])
            }

            let chats = snapshot.compactMap(Chat.init)
            completion(ref, chats)
        })
    }
    
}
