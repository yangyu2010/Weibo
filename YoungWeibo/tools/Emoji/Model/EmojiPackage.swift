//
//  EmojiPackage.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/19.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class EmojiPackage: NSObject {

    var emojiModelsArr : [EmojiModel] = [EmojiModel]()
    
    init(path : String) {
        
        super.init()
        
        if path == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        let sorcePath = Bundle.main.path(forResource: "\(path)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!

        let arr = NSArray(contentsOfFile: sorcePath) as! [[String : String]]
        
        var i = 0
        for var dict in arr {

            //把文件夹的名称拼接起来
            if let png = dict["png"] {
                dict["png"] = path + "/" + png
            }
            
            emojiModelsArr.append(EmojiModel(dict: dict))
           
            //第21个给插入一个删除按钮
            i += 1
            if i == 20 {
                emojiModelsArr.append(EmojiModel(isDelete: true))
                i = 0
            }

        }
        
        addEmptyEmoticon(isRecently: false)
        
    }
    
    fileprivate func addEmptyEmoticon(isRecently : Bool) {
        let count = emojiModelsArr.count % 21
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emojiModelsArr.append(EmojiModel(isEmpty: true))
        }
        
        emojiModelsArr.append(EmojiModel(isDelete: true))
    }
}
