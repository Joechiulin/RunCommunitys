//
//  UserMessageCell.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/29.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class UserMessageCell: UITableViewCell {

    @IBOutlet weak var tvUserMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
