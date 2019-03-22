//
//  HealthVC.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/22.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class HealthVC: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var smHealth: UISegmentedControl!
    
    @IBOutlet weak var svHealth: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        smHealth.selectedSegmentIndex = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
    }
    @IBAction func smAction(_ sender: Any) {
        switch smHealth.selectedSegmentIndex {
        case 0:
            svHealth.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        case 1:
            svHealth.setContentOffset(CGPoint(x: svHealth.bounds.size.width, y: 0), animated: true)
            break
        case 2:
            svHealth.setContentOffset(CGPoint(x: svHealth.bounds.size.width*2, y: 0), animated: true)
        default:
            break
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
