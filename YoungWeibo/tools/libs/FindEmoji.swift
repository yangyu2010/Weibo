//
//  FindEmoji.swift
//  正则表达式
//
//  Created by Young on 2016/12/25.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class FindEmoji: NSObject {
    
    static let shareInstance : FindEmoji = FindEmoji()

    fileprivate lazy var manager : EmojiManager = EmojiManager()
    
    func findAttriString(statusStr : String? , font : UIFont) -> NSMutableAttributedString? {
        
        guard let statusStr = statusStr else {
            return nil
        }
        
        let pattern = "\\[.*?\\]"   //[]在正装表达式里有特殊规则,要用\\转义下

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let results = regex.matches(in: statusStr, options: [], range: NSRange(location: 0, length: statusStr.characters.count))
        
        let attriMStr = NSMutableAttributedString(string: statusStr)
        
        for result in results.reversed() {
            
            let chs = (statusStr as NSString).substring(with: result.range)
            guard let path = findEmoji(chs: chs) else {
                return nil
                
            }
            
            let attachement = NSTextAttachment()
            attachement.image = UIImage(contentsOfFile: path)
            attachement.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            
            let attri = NSAttributedString(attachment: attachement)
            
            attriMStr.replaceCharacters(in: result.range, with: attri)
        }
        
       return attriMStr
    }
    
    
    fileprivate func findEmoji(chs : String) -> String? {
        
        for package in manager.packagesArr {
            for emoji in package.emojiModelsArr {
                if emoji.chs == chs {
                    return emoji.pngPath
                }
            }
        }
        
        return nil
    }
    
    
    
}
