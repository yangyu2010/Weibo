//
//  PicturePickerCollecView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/17.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

//cellID
fileprivate let pickerCollecCellID = "PicturePickerCollecCellID"
//每个cell的间隔
fileprivate let collecViewCellMaggin : CGFloat = 15.0
//每个item的大小
fileprivate let collecItemWH = (UIScreen.main.bounds.width - 4 * collecViewCellMaggin) / 3

class PicturePickerCollecView: UICollectionView {

    //装cell图片的数组
    var imagesArr : [UIImage] = [UIImage]() {
        didSet{
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: collecItemWH, height: collecItemWH)
        //设置了没用
//        layout.minimumLineSpacing = collecViewCellMaggin
//        layout.minimumInteritemSpacing = collecViewCellMaggin
        contentInset = UIEdgeInsets(top:collecViewCellMaggin , left: collecViewCellMaggin, bottom: 0, right: collecViewCellMaggin)
        
        register(UINib.init(nibName: "PicturePickerCollecCell", bundle: nil), forCellWithReuseIdentifier: pickerCollecCellID)
        
        dataSource = self
        delegate = self
        
    }

}


extension PicturePickerCollecView : UICollectionViewDataSource , UICollectionViewDelegate {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickerCollecCellID, for: indexPath) as! PicturePickerCollecCell

        cell.image = indexPath.row <= imagesArr.count - 1 ? imagesArr[indexPath.row] : nil
        
        return cell
    }
}
