//
//  NewChatViewController.swift
//  PeckChat
//
//  Created by Spencer Peck on 3/20/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {
    
    var friends = [User]()
    var selectedUser: User?
    var existingChat: Chat?
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        
        UserService.usersWhoAreFriends { [weak self] (friends) in
            self?.friends = friends

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        print("next button tapped")
        guard let selectedUser = selectedUser else { return }

        // 2
        sender.isEnabled = false
        // 3
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            // 4
            sender.isEnabled = true
            self.existingChat = chat

            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }
    
}

extension NewChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatUserCell") as! NewChatUserCell
        configureCell(cell, at: indexPath)

        return cell
    }

    func configureCell(_ cell: NewChatUserCell, at indexPath: IndexPath) {
        let follower = friends[indexPath.row]
        cell.textLabel?.text = follower.username

        if let selectedUser = selectedUser, selectedUser.uid == follower.uid {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension NewChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // 2
        selectedUser = friends[indexPath.row]
        cell.accessoryType = .checkmark

        // 3
        nextButton.isEnabled = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 4
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // 5
        cell.accessoryType = .none
    }
}

// MARK: - Navigation

extension NewChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "toChat", let destination = segue.destination as? ChatViewController, let selectedUser = selectedUser {
            let members = [selectedUser, User.current]
            destination.chat = existingChat ?? Chat(members: members)
        }
    }
}
