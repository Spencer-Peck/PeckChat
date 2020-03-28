//
//  ConversationViewController.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//


import UIKit
import FirebaseDatabase

class ChatListViewController: UIViewController {
    var chats = [Chat]()
    
    var userChatsHandle: DatabaseHandle = 0
    var userChatsRef: DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 71
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        
        userChatsHandle = UserService.observeChats { [weak self] (ref, chats) in
            self?.userChatsRef = ref
            self?.chats = chats

            // 3
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    deinit {
        // 4
        userChatsRef?.removeObserver(withHandle: userChatsHandle)
    }
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        chats.sort { (chat1, chat2) -> Bool in
            return chat1.lastMessageSent?.compare(chat2.lastMessageSent!) == ComparisonResult.orderedDescending
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell

        let chat = chats[indexPath.row]
        cell.titleLabel.text = chat.title
        cell.lastMessageLabel.text = chat.lastMessage

        return cell
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChat", sender: self)
    }
}

// MARK: - Navigation

extension ChatListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "toChat",
            let destination = segue.destination as? ChatViewController,
            let indexPath = tableView.indexPathForSelectedRow {

            destination.chat = chats[indexPath.row]
        }
    }
}
