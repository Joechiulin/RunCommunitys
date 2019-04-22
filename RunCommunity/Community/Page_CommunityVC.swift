//
//  Page_CommunityVC.swift
//  RunCommunity
//
//  Created by Joe on 2019/4/9.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
class Page_CommunityVC: UIViewController {

    @IBOutlet weak var community: UIView!
    @IBOutlet weak var communityFrient: UIView!
    
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
community.isHidden=false
        communityFrient.isHidden=true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func scPage(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            community.isHidden=false
            communityFrient.isHidden=true
        case 1:
            community.isHidden=true
            communityFrient.isHidden=false
        default:
            fatalError()
        }
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
