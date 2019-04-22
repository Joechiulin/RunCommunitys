//
//  InsertTVCell.swift
//  RunCommunity
//
//  Created by PIG on 2019/4/12.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class InsertTVCell: UITableViewCell {
    
    @IBOutlet weak var tfHeartBeat: UITextField!
    
    @IBOutlet weak var tfBloodOxygen: UITextField!
    
    @IBOutlet weak var tfSleep: UITextField!
    
    @IBOutlet weak var tfDeepSleep: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
