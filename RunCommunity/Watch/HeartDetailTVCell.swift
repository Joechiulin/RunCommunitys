//
//  HeartDetailTVCell.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/28.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class HeartDetailTVCell: UITableViewCell {

    @IBOutlet weak var lCount: UILabel!
    @IBOutlet weak var lLimit: UILabel!
    @IBOutlet weak var lHeart: UILabel!
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivLimit: UIImageView!
    @IBOutlet weak var ivCount: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
