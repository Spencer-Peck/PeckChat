//
//  FindFriendsCell.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/26/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import UIKit

protocol FindFriendsCellDelegate: class {
    func didTapAddButton(_ addButton: UIButton, on cell: FindFriendsCell)
}

class FindFriendsCell: UITableViewCell {
    
    weak var delegate: FindFriendsCellDelegate?

    // MARK: - Properties

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!

    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        
        if self.reuseIdentifier == "FindFriendsCell" {
            addButton.layer.borderColor = UIColor.lightGray.cgColor
            addButton.layer.borderWidth = 1
            addButton.layer.cornerRadius = 6
            addButton.clipsToBounds = true
            //addButton.setTitle("Add", for: .normal)
        
            }
        //addButton.setTitle("Delete Request", for: .selected)
    }

    // MARK: - IBActions

    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate?.didTapAddButton(sender, on: self)
    }
}
