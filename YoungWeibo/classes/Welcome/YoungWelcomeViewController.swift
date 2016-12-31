//
//  YoungWelcomeViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/14.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SDWebImage

class YoungWelcomeViewController: UIViewController {

    @IBOutlet weak var iconButtomCons: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let iconUrlStr = UserAccountViewModel.shareIntance.account?.avatar_hd
        
        let url = URL.init(string: iconUrlStr ?? "")
        icon.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"))
        
        icon.layer.cornerRadius = 45.0
        icon.layer.masksToBounds = true
        
        iconButtomCons.constant = UIScreen.main.bounds.height - 200
        
        // withDuration动画时间
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        // delay 延时
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (_) in
            
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
