//
//  EmojiManager.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/19.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class EmojiManager: NSObject {

    var packagesArr : [EmojiPackage] = [EmojiPackage]()
    
    override init() {
                
        packagesArr.append(EmojiPackage(path: ""))
        
        packagesArr.append(EmojiPackage(path: "com.sina.default"))
        
        packagesArr.append(EmojiPackage(path: "com.apple.emoji"))

        packagesArr.append(EmojiPackage(path: "com.sina.lxh"))
        
    }
}
