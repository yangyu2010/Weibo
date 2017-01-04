//
//  PicCollectionView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/16.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        
        delegate = self
        dataSource = self
    }
}

// MARK: -dataSource代理
extension PicCollectionView : UICollectionViewDataSource , UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollecViewCellID", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let info = [showPhotoBrowserIndexKey : indexPath ,showPhotoBrowserURLKey : picURLs] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhotoBrowserNote), object: self, userInfo: info)
    }
}


// MARK: -自定义collection cell
class PicCollectionViewCell: UICollectionViewCell {
    
    //
    var picURL : URL? {
        didSet {
            guard let pirURL = picURL else {
                return
            }
            
            icon.sd_setImage(with: pirURL, placeholderImage: UIImage.init(named: "empty_picture"))
        }
    }
    
    
    //控件属性
    @IBOutlet weak var icon: UIImageView!
}



extension PicCollectionView : PhotoBrowserAnimatorPresentedDelegate {

    func startRectForPresented(indexPath: IndexPath) -> CGRect {
        
        //1.获取cell
        let cell = self.cellForItem(at: indexPath)!
        
        //2.获取cell的frame
        let startFrame = self.convert(cell.frame, to: kKeyWindow)
        
        return startFrame
        
    }
    
    func endRectForPresented(indexPath: IndexPath) -> CGRect {
        
        //1.先获取图片
        let picURL = picURLs[indexPath.row]

        guard let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString) else {
            return CGRect.zero
        }
        
        let w = UIScreen.main.bounds.width
        let h = (w / img.size.width) * img.size.height
        var y : CGFloat = 0.0
        if h < UIScreen.main.bounds.height {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }

        print(h,y)
        
        return CGRect(x: 0, y: y, width: w, height: h)
 
        
    }
    
    func imageViewForPresented(indexPath: IndexPath) -> UIImageView {
        
        let imgView = UIImageView()
        
        let picURL = picURLs[indexPath.row]
        
        let img = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)

        imgView.image = img
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        return imgView
        
    }
}






















