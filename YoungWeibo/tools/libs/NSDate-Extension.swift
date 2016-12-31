//
//  NSDate-Extension.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/14.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

extension NSDate {

    class func creatDateString(creatStr : String) -> (String) {
        
        //Fri Dec 16 20:01:03 +0800 2016
        //Wed Dec 14 15:17:27 +0800 2016
        let format = DateFormatter()
        format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        //一定要加上这句话,不如可能转不成功
        format.locale = Locale.init(identifier: "en")
        
        guard let creatDate = format.date(from: creatStr) else {
            return ""
        }
        
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince(creatDate))
        
        
        if interval < 60 {
            return "刚刚"
        }
        
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        let calend = NSCalendar.current
        if calend.isDateInYesterday(creatDate) {
            format.dateFormat = "昨天 HH:mm"
            let time = format.string(from: creatDate)
            return time
        }
        
        let comp =  calend.dateComponents([Calendar.Component.year], from: creatDate, to: nowDate)

        //判断是否是去年的时间
        if let year = comp.year , year < 1{
             format.dateFormat = "MM-dd HH:mm"
             let time = format.string(from: creatDate)
             return time
        }

        format.dateFormat = "yyyy-MM-dd HH:mm"
        let time = format.string(from: creatDate)
        return time
    }
    
}
