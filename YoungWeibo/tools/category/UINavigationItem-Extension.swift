//
//  UINavigationItem-Extension.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/11.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    convenience init(imageName : String) {
        
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.init(customView : btn)
        
    }
}
