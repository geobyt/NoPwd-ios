//
//  PasswordListTableViewCell.swift
//  nopwd
//
//  Created by George on 3/15/15.
//  Copyright (c) 2015 George. All rights reserved.
//

import UIKit

class PasswordListTableViewCell: UITableViewCell {

    @IBOutlet weak var entityLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
