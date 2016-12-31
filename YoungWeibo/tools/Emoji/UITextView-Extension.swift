//
//  UITextView-Extension.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/20.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit


extension UITextView {

    //插入表情
    func insertEmojition(model : EmojiModel) {
        
        /// 如果点击的是空表情
        if model.isEmpty {
            return
        }
        
        /// 删除
        if model.isDelete {
            deleteBackward()
            return
        }
        
        //emoji表情
        if model.emojiCode != nil {
            insertText(model.emojiCode!)
            return
        }
        
        /// 默认和浪小花的表情
        //1.创建属性字符串 设置image
        let arrachment  = EmojiTextAttachment()
        arrachment.image = UIImage(contentsOfFile: model.pngPath!)
        arrachment.chs = model.chs
        
        let font = self.font
        //设置宽高
        arrachment.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
        let attri = NSAttributedString(attachment: arrachment)
        
        //创建可变的属性字符串 把输入框里的文字也拿到
        let attrMstr = NSMutableAttributedString(attributedString: attributedText)
        //取出光标所在的位置
        let range =  selectedRange
        //用新的字符替换
        attrMstr.replaceCharacters(in: range, with: attri)
        attributedText = attrMstr
        
        
        //恢复输入框的文字大小 和 光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
        self.font = font
        
    }
    
    
    /// 获取输入框的属性字符串
    func getTextViewAttrString() -> String {
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedText.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            if dict["NSAttachment"] != nil {
                let chment = dict["NSAttachment"] as! EmojiTextAttachment
                attrMStr.replaceCharacters(in: range, with: chment.chs!)
            }
            
        }
        
//        print(attrMStr.string)
        return attrMStr.string
    }
    
}
