//
//  HomeTableViewCell.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/15.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let edgeMaggin : CGFloat = 15.0
fileprivate let collecViewMaggin : CGFloat = 10.0
fileprivate let collecItemWH = (UIScreen.main.bounds.width - 2 * edgeMaggin - 2 * collecViewMaggin) / 3


class HomeTableViewCell: UITableViewCell {

    //控件
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var vipImg: UIImageView!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var formLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var picColleView: PicCollectionView!
    @IBOutlet weak var retweetLab: UILabel!
    @IBOutlet weak var retweetBgView: UIView!
    @IBOutlet weak var buttomToolView: UIView!
    
    
    //约束
    @IBOutlet weak var contentLabWidthCons: NSLayoutConstraint!
    @IBOutlet weak var collecWidthCons: NSLayoutConstraint!
    @IBOutlet weak var collecHeightCons: NSLayoutConstraint!
    @IBOutlet weak var collecBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetLabTopCons: NSLayoutConstraint!
    
    
    var model : HomeViewModel? {
        didSet {
            //1.nil值验证
            guard let model = model else {
                return
            }
            //2.设置头像
            icon.sd_setImage(with: model.iconUrl)
            //3.认证图标
            verifiedView.image = model.verified_image
            //4.昵称
            nameLab.text = model.statusModel?.user?.screen_name
            //5.会员图标
            vipImg.image = model.vip_image
            //6.时间
            timeLab.text = model.created_atString
            //7.微博来源
            if model.sourceText != nil {
                formLab.text = "来自" + model.sourceText!
            } else {
                formLab.text = "未知"
            }
            
            //8.内容
            contentLab.attributedText = FindEmoji.shareInstance.findAttriString(statusStr: model.statusModel?.text, font: contentLab.font)
            
            //9.如果是会员就设置name颜色
            nameLab.textColor = model.vip_image == nil ? UIColor.black : UIColor.orange
            
            //10.计算中间图片的宽高
            let collecSize =  setupCollecViewSize(count: model.textPicUrls.count)
            collecWidthCons.constant = collecSize.width
            collecHeightCons.constant = collecSize.height
            picColleView.picURLs = model.textPicUrls
            
            //11.转发的微博的lab内容
            if let retweetModel = model.statusModel?.retweeted_status {
                //如果是转发的微博,就把灰色背景图显示出来
                retweetBgView.isHidden = false
                if let screenName = retweetModel.user?.screen_name , let retweentText = retweetModel.text {
//                    retweetLab.text = "@" + "\(screenName):" + retweentText
                    
                    let content = "@" + "\(screenName):" + retweentText
                    retweetLab.attributedText = FindEmoji.shareInstance.findAttriString(statusStr: content, font: retweetLab.font)
                }
                //设置转发微博lab,如果有转发就设置顶部15,没有就是0
                retweetLabTopCons.constant = 15.0
            } else {
                retweetBgView.isHidden = true
                retweetLab.text = ""
                retweetLabTopCons.constant = 0.0
            }
            
            //12.先强制布局
            if model.cellHeight <= 0 {
                layoutIfNeeded()
                model.cellHeight = buttomToolView.frame.maxY
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //对内容的宽度做约束
        contentLabWidthCons.constant = UIScreen.main.bounds.width - 2 * edgeMaggin
        
    }

}


extension HomeTableViewCell {

    fileprivate func setupCollecViewSize(count : Int) -> CGSize {
    
        //没有图片时
        if count == 0 {
            collecBottomCons.constant = 0
            return CGSize.zero
        }
        
        collecBottomCons.constant = 10
        
        //对collectionView
        let layout = picColleView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //只有一张图片的时候,让collectionCell item大小跟随图片大小
        if count == 1 {
            let urlStr = model?.textPicUrls.first?.absoluteString
            let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlStr)
            
            //如果只有一张图片时,itemSize根据图片的大小来决定的
            layout.itemSize = CGSize(width: img!.size.width * 2, height: img!.size.height * 2)
            return CGSize(width: img!.size.width * 2, height: img!.size.height * 2)
        }
        
        //如果有多张图片,itemSize是固定的collecItemWH
        layout.itemSize = CGSize(width: collecItemWH, height: collecItemWH)
        
        let collecWidth = UIScreen.main.bounds.width - 2 * edgeMaggin

        //四张图片时
        if count == 4 {
            let collecHeight = 2 * collecItemWH + collecViewMaggin + 1
            return CGSize(width: collecHeight, height: collecHeight)
        }
        
        //其他张图片时
        let rows = CGFloat((count - 1) / 3 + 1)
        let collecHeight = rows * collecItemWH + (rows - 1) * collecViewMaggin
        return CGSize(width: collecWidth, height: collecHeight)
        
    }
}


