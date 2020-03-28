//
//  FindFriendsViewController.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    var users = [User]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    //self.performSegue(withIdentifier: "labelSegue", sender: self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserService.usersExcludingCurrentUser { [unowned self] (users) in
            self.users = users
            print(users)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let identifier = segue.identifier else { return }

           // 2
           if identifier == "Label" {
               print("Transitioning to the Label Controller")
           }
    }
}

// MARK: - UITableViewDataSource

extension FindFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell") as! FindFriendsCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)

        return cell
    }

    func configure(cell: FindFriendsCell, atIndexPath indexPath: IndexPath) {
        //print("here3")
        let user = users[indexPath.row]

        cell.usernameLabel.text = user.username
        if (user.isRequested) {
            cell.addButton.setTitle("Cancel Request", for: .normal)
        } else {
            cell.addButton.setTitle("Add", for: .normal)
        }
    }

}

extension FindFriendsViewController: FindFriendsCellDelegate {
    
    func didTapAddButton(_ addButton: UIButton, on cell: FindFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        addButton.isUserInteractionEnabled = false
        let requester = users[indexPath.row]
        
        var title = "nada"
        if (requester.isRequested) {
            addButton.setTitle("Cancel Request", for: .normal)
            title = "Add"
        } else {
            addButton.setTitle("Add", for: .normal)
            title = "Cancel Request"
        }
        //print(title)

        FriendRequestService.setIsFriendRequest(!requester.isRequested, fromCurrentUserTo: requester) { (success) in
            defer {
                addButton.isUserInteractionEnabled = true
            }

            guard success else {
                
                let alertController = UIAlertController(title: "Oops!", message:
                    "It looks like you have already recieved a friend request from this person!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            

            requester.isRequested = !requester.isRequested
            //print(self.tableView.cellForRow(at: indexPath)!.isSelected)
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
}

