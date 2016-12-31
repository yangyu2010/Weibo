//
//  UserAccountViewModel.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/13.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {

    //设置成单例
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    var account : UserAccount?

    //存储的路径
    var accountPath : String? {
    
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (path as NSString).appendingPathComponent("account.plist")
    }
    
    //2.判断是否登录了
    var isLogin : Bool {
    
        if accountPath == nil {
            return false
        }

        guard let user =  NSKeyedUnarchiver.unarchiveObject(withFile: accountPath!) as? UserAccount else {
            return false
        }
        
        let expires_date = user.expires_date
        return  expires_date!.compare(Date()) == .orderedDescending

    }
    
    override init() {
        super.init()
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath!) as? UserAccount
    }
}
