//
//  FriendRequestViewController.swift
//  PeckChat
//
//  Created by Spencer Peck on 3/8/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation

import UIKit

class FriendRequestViewController: UIViewController {
    
    var users = [User]()
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.tableFooterView = UIView()
        TableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.pendingFriendRequests { [unowned self] (users) in
            self.users = users
            print(users)
            
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        }
        
    }
    
}

extension FriendRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as! FriendRequestCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)

        return cell
    }

    func configure(cell: FriendRequestCell, atIndexPath indexPath: IndexPath) {
        
        let user = users[indexPath.row]

        cell.Username.text = user.username
        cell.AddFriendButton.setTitle("Accept", for: .normal)
        cell.DeleteRequestButton.setTitle("Decline", for: .normal)
    }

}


extension FriendRequestViewController: FriendRequestCellDelegate {
    
    func didTapAddFriendButton(_ AddFriendButton: UIButton, on cell: FriendRequestCell) {
        print("Add button Tapped")
        
        guard let indexPath = TableView.indexPath(for: cell) else { return }
        
        print("hey")
        AddFriendButton.setTitle("Friends!", for: .normal)
        AddFriendButton.isUserInteractionEnabled = false
        let requester = users[indexPath.row]
        
        FriendRequestService.deleteOtherUserFriendRequest(requester) { (success) in
            guard success else {
                
                return
                
            }
            FriendService.AcceptFriendRequest(requester) { (success) in
                defer {
                    AddFriendButton.isUserInteractionEnabled = true
                }

                guard success else {
                    
                    return
                    
                }
                
                //requester.isRequested = !requester.isRequested
                //print(self.tableView.cellForRow(at: indexPath)!.isSelected)
                print("babe")
                self.users.remove(at: indexPath.row)
                //self.TableView.reloadRows(at: [indexPath], with: .none)
                self.TableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                
            }
        }
    }

}
