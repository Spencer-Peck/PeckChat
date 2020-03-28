//
//  ViewFrindsController.swift
//  PeckChat
//
//  Created by Spencer Peck on 3/4/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation

import UIKit

class ViewFriendsController: UIViewController {
    
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.usersWhoAreFriends{ [unowned self] (users) in
            self.users = users
            print(users)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func FindFriendsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "FindFriendsSegue", sender: self)
    }
    
    @IBAction func FriendRequestButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "FriendRequestsSegue", sender: self)
    }
}

extension ViewFriendsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewFriendsCell") as! ViewFriendsCell
        //cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)

        return cell
    }

    func configure(cell: ViewFriendsCell, atIndexPath indexPath: IndexPath) {
        
        let user = users[indexPath.row]

        cell.friendLabel.text = user.username
        cell.deleteFriendButton.setTitle("Delete", for: .normal)
        //cell.DeleteRequestButton.setTitle("Decline", for: .normal)
    }

}

