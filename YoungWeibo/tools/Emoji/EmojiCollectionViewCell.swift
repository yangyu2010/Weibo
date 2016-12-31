//
//  EmojiCollectionViewCell.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/19.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiBtn: UIButton!

    var emojiModel : EmojiModel? {
        didSet {
            guard let emojiModel = emojiModel else {
                return
            }
 
            emojiBtn.setImage(UIImage.init(contentsOfFile: emojiModel.pngPath ?? ""), for: .normal)
            emojiBtn.setTitle(emojiModel.emojiCode, for: .normal)
            
            if emojiModel.isDelete {
                emojiBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        
        emojiBtn.isUserInteractionEnabled = false
    }
    
   
}
