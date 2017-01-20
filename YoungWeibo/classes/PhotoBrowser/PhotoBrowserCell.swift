//
//  PhotoBrowserCell.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/2.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate {
    func imgViewTapClick()
}


class PhotoBrowserCell: UICollectionViewCell {
    
    var picURL : URL? {
        didSet {
            setupContent(picURL: picURL)
        }
    }
    
    lazy var imgView : UIImageView = UIImageView()
    fileprivate lazy var scrollV : UIScrollView = UIScrollView()
    fileprivate lazy var progressV : YoungProgressView = YoungProgressView()
    
    var delegate : PhotoBrowserCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: -设置ui相关
extension PhotoBrowserCell {

    fileprivate func setupUI() {
        
        contentView.addSubview(scrollV)
        contentView.addSubview(progressV)
        scrollV.addSubview(imgView)
        
        scrollV.frame = contentView.bounds
        scrollV.frame.size.width -= 20
        progressV.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressV.center = scrollV.center
        progressV.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgViewTapClick))
        imgView.addGestureRecognizer(tap)
        imgView.isUserInteractionEnabled = true
        
    }
}

// MARK: -事件监听
extension PhotoBrowserCell {

    @objc fileprivate func imgViewTapClick() {
            delegate?.imgViewTapClick()
    }
}

// MARK: -设置cell内容
extension PhotoBrowserCell {

    fileprivate func setupContent(picURL : URL?) {
    
        guard let picURL = picURL else {
            return
        }
        
        guard let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString) else {
            return
        }
        
        //cell复用 图片会不在最上面 设置下
        if scrollV.contentOffset.y > 0 {
            scrollV.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        let width = UIScreen.main.bounds.width
        //根据宽度的比例还算出高度
        let height = (width / image.size.width) * image.size.height
        var y : CGFloat = 0
        //如果图片的高度比屏幕还高,y就从0开始,如果比屏幕小,就算出y
        if height < UIScreen.main.bounds.height {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        imgView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        progressV.isHidden = false
        imgView.sd_setImage(with: getBigIconUrl(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total) in
            self.progressV.progress =  CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressV.isHidden = true
        }
        
        scrollV.contentSize = CGSize(width: 0, height: height)
    }
    
    fileprivate func getBigIconUrl(smallURL : URL) -> URL {
    
        let urlStr = smallURL.absoluteString
        let bigURLStr = urlStr.replacingOccurrences(of: "thumbnail", with: "large")
        
        return URL(string: bigURLStr)!
        
    }
}
