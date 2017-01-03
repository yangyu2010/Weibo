//
//  ShowTip.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/18.
//  Copyright © 2016年 杨羽. All rights reserved.
//  提示语 比如请求超时时

import UIKit

class ShowTip: NSObject {

    class func showHudTip(tipStr : String) {
     
        let hud = MBProgressHUD.showAdded(to: kKeyWindow, animated: true)
        hud.mode = .text
        hud.detailsLabel.text = tipStr
        hud.bezelView.color = UIColor.orange
        hud.contentColor = UIColor.white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        hud.animationType = .zoom
        hud.removeFromSuperViewOnHide = true
        hud.margin = 10.0
        hud.hide(animated: true, afterDelay: 1.2)
        
    }
    
}
