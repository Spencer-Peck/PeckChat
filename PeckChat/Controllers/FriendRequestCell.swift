//
//  FriendRequestCell.swift
//  PeckChat
//
//  Created by Spencer Peck on 3/11/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import UIKit

protocol FriendRequestCellDelegate: class {
    func didTapAddFriendButton(_ AddFriendButton: UIButton, on cell: FriendRequestCell)
}

class FriendRequestCell: UITableViewCell {
    
    weak var delegate: FriendRequestCellDelegate?
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var AddFriendButton: UIButton!
    @IBOutlet weak var DeleteRequestButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.reuseIdentifier == "FriendRequestCell" {
            
            AddFriendButton.layer.borderColor = UIColor.lightGray.cgColor
            AddFriendButton.layer.borderWidth = 1
            AddFriendButton.layer.cornerRadius = 6
            AddFriendButton.clipsToBounds = true
            
            DeleteRequestButton.layer.borderColor = UIColor.lightGray.cgColor
            DeleteRequestButton.layer.borderWidth = 1
            DeleteRequestButton.layer.cornerRadius = 6
            DeleteRequestButton.clipsToBounds = true
        
            }
        
    }
    
    @IBAction func AddFriendButtonPressed(_ sender: UIButton) {
        delegate?.didTapAddFriendButton(sender, on: self)
    }
    
    @IBAction func DeleteRequestButtonPressed(_ sender: Any) {
        print("Delete Request Button Tapped")
    }
}


