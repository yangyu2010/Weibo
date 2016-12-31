//
//  EmojiModel.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/19.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class EmojiModel: NSObject {

    var code : String? {     //emoji表情
        didSet {
            guard code == code else {
                return
            }
            
            let scanner = Scanner(string: code!)
            var pointer : UInt32 = 0
            scanner.scanHexInt32(&pointer)
            
            let char = Character.init(UnicodeScalar(pointer)!)
            
            emojiCode = String(char)
        }
    }
    
    var chs : String?       //默认和浪小花的表情name
    var png : String? {     //默认和浪小花的表情图片
        didSet {
            guard png == png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
        }
    }
    var isDelete : Bool = false
    var isEmpty : Bool = false
    
    var pngPath : String?   //拼接后的路径
    var emojiCode : String? //处理后的emoji表情
    
    init(dict : [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    init(isDelete : Bool) {
        self.isDelete = isDelete
    }
    
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    override var description: String {
    
        return dictionaryWithValues(forKeys: ["emojiCode","chs","pngPath"]).description
    }
}
