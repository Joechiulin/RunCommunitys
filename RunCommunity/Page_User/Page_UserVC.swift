//
//  Page_UserVC.swift
//  RunCommunity
//
//  Created by Sin-yuan Jiang on 2019/3/18.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit

class Page_UserVC: UIViewController {
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var viewPersonal: UIView!
    @IBOutlet weak var viewNotice: UIView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPersonal.isHidden = false
        viewNotice.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btSignOut(_ sender: Any) {
        
        alertController = UIAlertController(title: "登出", message:"確定要登出嗎？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let signOut = UIAlertAction(title: "登出", style: .default) {
            (alertAction) in
            
            self.userDefaults.removeObject(forKey: "useraccount")
            self.userDefaults.removeObject(forKey: "userpassword")
            self.userDefaults.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil) //storyboard
            let signInPage = storyboard.instantiateViewController(withIdentifier: "logInVC") as! ViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInPage
            
        }
        alertController.addAction(signOut)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func scUserPage(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex{
        case 0:
            viewPersonal.isHidden = false
            viewNotice.isHidden = true
        case 1:
            viewPersonal.isHidden = true
            viewNotice.isHidden = false
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
