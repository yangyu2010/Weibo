//
//  HomeStatusModel.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/14.
//  Copyright © 2016年 杨羽. All rights reserved.
//  首页cell的model

import UIKit

class HomeStatusModel: NSObject {

    var created_at : String?        //微博创建时间
    var mid : Int64 = 0              //微博MID
    var text : String?              //微博信息内容
    var source : String?            //微博来源
    var user : HomeUserModel?       //发微博的用户信息
    var pic_urls : [[String : String]]? //发微博的图片
    var retweeted_status : HomeStatusModel?     //转发的微博信息
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String : Any] {
            user = HomeUserModel(dict: userDict)
        }
        
        if let userDict = dict["retweeted_status"] as? [String : Any] {
            retweeted_status = HomeStatusModel(dict: userDict)
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
    
}
