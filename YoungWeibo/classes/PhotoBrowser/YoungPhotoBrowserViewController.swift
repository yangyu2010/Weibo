//
//  YoungPhotoBrowserViewController.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/2.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let picCollecCellID = "picCollecCellID"

class YoungPhotoBrowserViewController: UIViewController {

    var index : IndexPath
    var picURLs : [URL]
    fileprivate lazy var picCollec : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontNum: 14.0, title: "关 闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontNum: 14.0, title: "保 存")

    init(index : IndexPath , picURLs : [URL]) {
        
        self.index = index
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        picCollec.scrollToItem(at: index, at: .left, animated: false)
    }

    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
}

// MARK: -设置UI相关
extension YoungPhotoBrowserViewController {

    fileprivate func setupUI() {
        
        view.addSubview(picCollec)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
//        picCollec.delegate = self
        picCollec.dataSource = self
        picCollec.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: picCollecCellID)
        
        
//        picCollec.snp.makeConstraints { (make) in
//            make.top.left.bottom.right.equalTo(0)
//        }

        picCollec.bounds = view.bounds
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 78, height: 32))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.size.equalTo(closeBtn)
        }
        
        closeBtn.addTarget(self, action:#selector(closeBtnClick) , for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
}

// MARK: -事件监听
extension YoungPhotoBrowserViewController {

    @objc fileprivate func closeBtnClick() {
    
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func saveBtnClick() {
    
        let cell = picCollec.visibleCells.first as! PhotoBrowserCell
        guard let img = cell.imgView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    ////  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc fileprivate func image(image : UIImage , didFinishSavingWithError : NSError? , contextInfo : Any) {
    
        var info = ""
        if didFinishSavingWithError != nil {
            info = "保存失败"
        }else {
            info = "保存成功"
        }
        
        ShowTip.showHudTip(tipStr: info)
    }
}




// MARK: -collectionView代理
extension YoungPhotoBrowserViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picCollecCellID, for: indexPath) as! PhotoBrowserCell
        cell.picURL = picURLs[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}

// MARK: -cell代理,退出图片浏览
extension YoungPhotoBrowserViewController : PhotoBrowserCellDelegate {

    func imgViewTapClick() {
        
        closeBtnClick()
    }
}

// MARK: -消失动画的代理
extension YoungPhotoBrowserViewController : PhotoBrowserAnimatorDismissDelegate {

    func indexPathForDismiss() -> IndexPath {
        let cell = picCollec.visibleCells.first!
        return picCollec.indexPath(for: cell)!
    }
    
    func imageViewForDismiss() -> UIImageView {
        let img = UIImageView()
        let cell = picCollec.visibleCells.first as! PhotoBrowserCell
        img.frame = cell.imgView.frame
        img.image = cell.imgView.image
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }
    
}

// MARK: -自定义layout
class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        super.prepare()
        
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}

