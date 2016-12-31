//
//  PicturePickerCollecCell.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/17.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class PicturePickerCollecCell: UICollectionViewCell {

    //控件属性
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    
    var image : UIImage? {
        didSet{
            if image == nil {
                imageV.image = nil
                addBtn.isUserInteractionEnabled = true
                deleteBtn.isHidden = true
            } else {
                imageV.image = image
                addBtn.isUserInteractionEnabled = false
                deleteBtn.isHidden = false
            }
        }
    }
    
    
    //点击添加图片按钮
    @IBAction func addPotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(addPotoClickNotification), object: nil)
    }
    
    //点击删除按钮
    @IBAction func deleteBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init(deletePotoClickNotification), object: imageV.image)
    }
    
}
