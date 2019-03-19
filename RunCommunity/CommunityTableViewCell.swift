//
//  CommunityTableViewCell.swift
//  RunCommunity
//
//  Created by Joe on 2019/3/15.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

protocol CommunityTableViewCellDeleget {
    
}

class CommunityTableViewCell: UIViewController {
    @IBOutlet weak var Imimageview: UIImageView!
    
    @IBOutlet weak var Lalike: UILabel!
    @IBOutlet weak var tvtext: UITextView!
    @IBOutlet weak var Lalocation: UILabel!
    @IBOutlet weak var Laname: UILabel!
    @IBOutlet weak var ImPhoto: UIImageView!
  

}
