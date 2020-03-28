//
//  ViewFriendsCell.swift
//  PeckChat
//
//  Created by Spencer Peck on 3/19/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import UIKit

class ViewFriendsCell: UITableViewCell {
    
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var deleteFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.reuseIdentifier == "ViewFriendsCell" {
            deleteFriendButton.layer.borderColor = UIColor.lightGray.cgColor
            deleteFriendButton.layer.borderWidth = 1
            deleteFriendButton.layer.cornerRadius = 6
            deleteFriendButton.clipsToBounds = true
            //addButton.setTitle("Add", for: .normal)
        
            }
        
    }
}
