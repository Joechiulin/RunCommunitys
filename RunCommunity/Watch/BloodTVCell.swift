//
//  BloodTVCell.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/8.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class BloodTVCell: UITableViewCell {

    @IBOutlet weak var lDetail: UILabel!
    @IBOutlet weak var lTitle: UILabel!
    
    @IBOutlet weak var ivLower: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
