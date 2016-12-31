//
//  HomeViewModel.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/15.
//  Copyright © 2016年 杨羽. All rights reserved.
//  viewModel  对首页model进行了一层封装

import UIKit

class HomeViewModel: NSObject {

    //拥有一个model
    var statusModel : HomeStatusModel?

    var cellHeight : CGFloat = 0.0      //每个model对应的cell高度
    
    // MARK: -发微博的用户数据处理
    var verified_image : UIImage?       //用户认证类型图片
    var vip_image : UIImage?            //vip等级图片
    var iconUrl : URL?                  //用户头像的url
    
    //对当前微博的数据处理
    var sourceText : String?        //source处理后的文字
    var created_atString : String?  //微博创建时间的字符串
    
    //对图片url处理
    var textPicUrls : [URL] = [URL]()
    
    // MARK: -构造函数
    init(statusModel : HomeStatusModel) {
        super.init()
        self.statusModel = statusModel
        
        //1.对微博来源处理
        if let source = statusModel.source , source != ""{
         
            //"<a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>"
            
            let loction = (source as NSString).range(of: ">").location + 1
            
            let length = (source as NSString).range(of: "</").location - loction
            
            sourceText = (source as NSString).substring(with: NSRange(location: loction, length: length))
            
        }
        
        //2.发微博的时间处理
        if let created_at = statusModel.created_at {
            created_atString = NSDate.creatDateString(creatStr: created_at)
        }
        
        //3.对微博认证的处理
        let type =  statusModel.user?.verified_type ?? -1
        switch type {
            case 0 :
                verified_image = UIImage(named: "avatar_vip")
            case 2,3,5 :
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 220 :
                verified_image = UIImage(named: "avatar_grassroot")
            default:
                verified_image = nil
        }
    
 
        //4.微博会员等级
        let mbrank = statusModel.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vip_image = UIImage(named: "common_icon_membership_level" + "\(mbrank)")
        }
        
        //5.发微博人的头像
        let urlStr = statusModel.user?.avatar_hd ?? ""
        iconUrl = URL.init(string: urlStr)
    
        //6.微博配图的数据处理
        //如果自己发的微博里面图片数组为0,就去转发的微博model里去找
        let iconArr = statusModel.pic_urls?.count != 0 ? statusModel.pic_urls : statusModel.retweeted_status?.pic_urls
        
        if let iconArr = iconArr , iconArr.count > 0 {
            
            for dict in iconArr {
                guard let urlStr = dict["thumbnail_pic"] else {
                    continue
                }
                textPicUrls.append(URL.init(string: urlStr)!)
            }
            
        }

    }

}
