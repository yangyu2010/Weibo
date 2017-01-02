//
//  UIButton-Extension.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/10.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit


extension UIButton {

    class func creatButton(_ iamgeName : String , bgImageName : String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: iamgeName), for: .normal)
        btn.setImage(UIImage.init(named: iamgeName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
    
    /** 构造函数 */
    convenience init(iamgeName : String , bgImageName : String) {
        self.init()
        
        setImage(UIImage.init(named: iamgeName), for: .normal)
        setImage(UIImage.init(named: iamgeName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor , fontNum : CGFloat , title : String) {
        self.init()
        
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontNum)
        setTitle(title, for: .normal)
    }
}
