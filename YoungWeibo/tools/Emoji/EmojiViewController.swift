//
//  EmojiViewController.swift
//  EmojiKeyBoard
//
//  Created by Young on 2016/12/19.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

fileprivate let emojiCollecViewCellID = "emojiCollecViewCellID"

class EmojiViewController: UIViewController {

    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    fileprivate lazy var emojiCollecView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiCollecViewLayout())
    fileprivate lazy var manager : EmojiManager = EmojiManager()
    fileprivate var emojiCallBack : (_ emoji : EmojiModel) -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    
    init(emojiCallBack : @escaping (_ emoji : EmojiModel) -> ()) {
        
        self.emojiCallBack = emojiCallBack
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension EmojiViewController {
    
    fileprivate func setupUI() {
    
        view.addSubview(toolBar)
        view.addSubview(emojiCollecView)
        
        toolBar.backgroundColor = UIColor.white
        emojiCollecView.backgroundColor = UIColor.lightGray
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        emojiCollecView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar" : toolBar , "emojiCollecView" : emojiCollecView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[emojiCollecView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //准备collectionView
        prepareForCollecView()
        
        //准备toolBar
        prepareForToolBar()
    }
    
    //初始化collectionView
    fileprivate func prepareForCollecView() {
        
        emojiCollecView.register(UINib.init(nibName: "EmojiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: emojiCollecViewCellID)
        
        emojiCollecView.dataSource = self
        emojiCollecView.delegate = self
    }
    
    //初始化toolBar
    fileprivate func prepareForToolBar() {
    
        let titles = ["最近","默认","emoji","浪小花"]
        var itemsArr : [UIBarButtonItem] = [UIBarButtonItem]()
        for i in 0 ..< titles.count   {
            let item = UIBarButtonItem(title: titles[i], style: .plain, target: self, action: #selector(toolBarItemsClick(item:)))
            item.tag = i
            itemsArr.append(item)
            itemsArr.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        itemsArr.removeLast()
        toolBar.items = itemsArr
        toolBar.tintColor = UIColor.orange
    }
    
    
    @objc fileprivate func toolBarItemsClick(item : UIBarButtonItem) {
        
        let path = IndexPath(row: 0, section: item.tag)
        emojiCollecView.scrollToItem(at: path, at: .left, animated: true)
    }
}

// MARK: -collectionView代理
extension EmojiViewController : UICollectionViewDataSource , UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packagesArr[section]
        return package.emojiModelsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCollecViewCellID, for: indexPath) as! EmojiCollectionViewCell
        
//        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.blue
        
        let package = manager.packagesArr[indexPath.section]
        let model = package.emojiModelsArr[indexPath.row]
        cell.emojiModel = model
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let package = manager.packagesArr[indexPath.section]
        let model = package.emojiModelsArr[indexPath.row]
        
        insetRecentlyModel(model: model)
        
        //把点击的表情传给外面控制器
        emojiCallBack(model)
    }
    
    //recently
    fileprivate func insetRecentlyModel(model : EmojiModel) {

        //判断如果是删除或者空表情就不插入
        if model.isEmpty || model.isDelete {
            return
        }
        
        let packer = manager.packagesArr.first!
        if packer.emojiModelsArr.contains(model) {
            //已经有了这个表情
            let index = packer.emojiModelsArr.index(of: model)!
            packer.emojiModelsArr.remove(at: index)
        }else {
            //没有
            packer.emojiModelsArr.remove(at: packer.emojiModelsArr.count - 2)
        }
        
        packer.emojiModelsArr.insert(model, at: 0)
    }
    
}


// MARK: -自定义layout
class EmojiCollecViewLayout: UICollectionViewFlowLayout {
    
   override func prepare() {
    
        super.prepare()
    
        let itemeWH = UIScreen.main.bounds.width / 7.0
    
        itemSize = CGSize(width: itemeWH, height: itemeWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let maggin = (collectionView!.bounds.height - 3 * itemeWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(maggin, 0, maggin, 0)
    }
    
}


