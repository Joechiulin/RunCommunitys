//
//  Page_UserVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/18.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_UserVC: UIViewController {

    
    @IBOutlet weak var viewPersonal: UIView!
    @IBOutlet weak var viewAchievement: UIView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPersonal.isHidden = false
        viewAchievement.isHidden = true
        // Do any additional setup after loading the view.
    }
    
//
//    @IBAction func panGR(gesture: UIScreenEdgePanGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            segmented.selectedSegmentIndex = 1
//        case .ended:
//            segmented.selectedSegmentIndex = 1
//        default:
//            break
//        }
//    }
    
    
    @IBAction func scUserPage(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex{
        case 0:
            viewPersonal.isHidden = false
            viewAchievement.isHidden = true
        case 1:
            viewPersonal.isHidden = true
            viewAchievement.isHidden = false
        default: fatalError()
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
