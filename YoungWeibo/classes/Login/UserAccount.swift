//
//  UserAccount.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/12.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class UserAccount: NSObject , NSCoding {
    
    // MARK:- 归档&解档
    //归档
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_hd, forKey: "avatar_hd")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    /// 解档的方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_hd = aDecoder.decodeObject(forKey: "avatar_hd") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }

    // MARK: -属性
    var access_token : String?
    var uid : String?
    //过期时间 - s
    var expires_in : TimeInterval = 0.0 {
        
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
        
    }
    //过期时间 - 日期
    var expires_date : NSDate?
    //用户昵称
    var screen_name : String?
    //头像
    var avatar_hd : String?
    
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    override var description: String {
    
        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid","expires_date","screen_name","avatar_hd"]).description
    }
 
    
   
    
   
}

