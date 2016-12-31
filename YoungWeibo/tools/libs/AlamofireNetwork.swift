//
//  AlamofireNetwork.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/13.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireNetwork: NSObject {

    class func requestData(type : RequestType , urlString : String , parameters : [String : Any]? = nil , finishedCallback : @escaping (_ result : Any? , _ error : NSError?) -> ()) {
    
       
        Alamofire.request("https://httpbin.org/get").response { (response) in
    
            NSLog(message: response)
            
        }
    }
    
    
}
