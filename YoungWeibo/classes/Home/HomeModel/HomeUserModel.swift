//
//  HomeUserModel.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/15.
//  Copyright © 2016年 杨羽. All rights reserved.
//  发微博的用户model

import UIKit

class HomeUserModel: NSObject {

    var screen_name : String?               //昵称
    var avatar_hd : String?                 //头像
    var verified_type : Int = -1            //用户认证类型
    var mbrank : Int = 0                    //会员等级

    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
