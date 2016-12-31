//
//  PicCollectionView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/16.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

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


