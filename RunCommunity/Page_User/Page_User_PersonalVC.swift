//
//  Page_User_PersonalVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/20.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_User_PersonalVC: UIViewController {
    @IBOutlet weak var btUserPhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btUserPhoto.layer.cornerRadius=self.btUserPhoto.frame.size.width / 2;
        self.btUserPhoto.clipsToBounds = true;
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
