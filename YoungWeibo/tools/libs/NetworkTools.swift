//
//  NetworkTools.swift
//  SwiftAFNetworking
//
//  Created by Young on 2016/12/12.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import AFNetworking

enum RequestType : String {
    
    case POST = "POST"
    case GET = "GET"
}

class NetworkTools: AFHTTPSessionManager {

    
    static let shareInstance : NetworkTools = {
    
        let tool = NetworkTools()
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tool.responseSerializer.acceptableContentTypes?.insert("application/json")
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("text/json")
        tool.responseSerializer.acceptableContentTypes?.insert("text/JavaScript")

        return tool
    }()
 
}


// MARK: -封装请求
extension NetworkTools {
    
    func requestData(methodType : RequestType, urlString : String , parameters : [String : Any] , finished : @escaping ([String : Any]? , Error? ) -> ()) {
        
        //1.定义成功的闭包
        let successCallBack = { ( task : URLSessionDataTask, result : Any?) in
            
            let dict = result as? [String : Any]
            
            finished(dict, nil)
            
        }
        
        //2.定义失败的闭包
        let failureCallBack = { (task :  URLSessionDataTask?, error : Error) in
            
            finished(nil, error)
        }
        
        //3.发送请求
        if methodType == .GET {
            
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }else {
            
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}


// MARK: -请求access_token
extension NetworkTools {
    
    //请求access_token
    func requestAccessToken(code : String , finished : @escaping ([String : Any]? , Error?) -> ()) {
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id" : sinaApp_Key ,
                          "client_secret" : sinaApp_Secret ,
                          "grant_type" : "authorization_code" ,
                          "redirect_uri" : sina_redirect_uri ,
                          "code" : code
        ]
        
        requestData(methodType: .POST, urlString: urlStr, parameters: parameters) { ( result :  [String : Any]?, error : Error?) in
            
            finished(result, error)
        }
    }
    
    //请求用户信息 https://api.weibo.com/2/users/show.json
    func requestUserInfo(user : UserAccount , finished : @escaping ([String : Any]? , Error?) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        let parameters = ["access_token" : user.access_token ,
                          "uid" : user.uid
                            ]
        
        requestData(methodType: .GET, urlString: urlStr, parameters: parameters) { ( result :  [String : Any]?, error : Error?) in
            finished(result, error)
        }
    }
    
    //请求首页数据
    func requestHomeStausesData(since_id : Int , max_id : Int , finished : @escaping ([[String : Any]]? , Error?) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token" : UserAccountViewModel.shareIntance.account?.access_token!,
                          "since_id" : "\(since_id)" ,
                          "max_id" : "\(max_id)"
                          ]
        
        requestData(methodType: .GET, urlString: urlStr, parameters: parameters) { (result, error) in
            
            guard let statusDict = result else {
                finished(nil, error)
                return
            }
            finished(statusDict["statuses"] as? [[String : Any]], error)
        }
    }
    
    
    /// 发微博
    func sendWeibo(statusStr : String , isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        
        let parameters = ["access_token" : UserAccountViewModel.shareIntance.account?.access_token!,
                          "status" : statusStr]
        
        requestData(methodType: .POST, urlString: urlStr, parameters: parameters) { (dict, error) in
            
            if error != nil {
                isSuccess(false)
            }else {
                isSuccess(true)
            }
        }
    }
    
    //发带图片的微博
    func sendWeibo(statusStr : String ,image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        let parameters = ["access_token" : UserAccountViewModel.shareIntance.account?.access_token!,
                          "status" : statusStr]
        
        post(urlStr, parameters: parameters, constructingBodyWith: { (formData) in
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                formData.appendPart(withFileData: data, name: "pic", fileName: "weibo.png", mimeType: "image/jpg")
            }
        }, progress: nil, success: { (task, result) in
            NSLog(message: result)
            isSuccess(true)
            
        }) { (task, error) in
            NSLog(message: error)
            isSuccess(false)
        }
        
    }
    
    
}






