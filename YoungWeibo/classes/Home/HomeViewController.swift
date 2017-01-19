//
//  HomeViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/10.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    // MARK: -懒加载
    fileprivate lazy var titleBtn : NavTitleButton = NavTitleButton()
    fileprivate lazy var popoverAnimator : PopoverAnimaor = PopoverAnimaor {[weak self] (status) in
        
        self!.titleBtn.isSelected = status
    }
    
    fileprivate lazy var tipLab : UILabel = UILabel()
    fileprivate lazy var statusMArr : [HomeViewModel] = [HomeViewModel]()
    //用来处理转场动画的
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK: -系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置访客视图动画
        visitorView.setVisitorViewAnim()
        
        if !isLogin {
            return
        }
                
        //2.设置navBar
        setupNavigationBar()

        //3.设置cell高度是自动的
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        
        //4.设置刷新
        setRefresh()
        
        //5.设置提示Label
        setupTipLabel()
        
        //6.添加通知
        addNotifiction()
        
        //7.请求数据
        requestHomeData(isNewData: true)
    }


}

// MARK: -设置ui
extension HomeViewController {
    
    fileprivate func setupNavigationBar() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        //1.左边item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //2.右边item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //3.titleView
        let tit = UserAccountViewModel.shareIntance.account?.screen_name ?? ""
        titleBtn.setTitle(tit, for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    fileprivate func setRefresh() {

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            self.requestHomeData(isNewData: true)
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.requestHomeData(isNewData: false)
        })
        
        //tableView.mj_header.beginRefreshing()
    }
    
    //设置提示lab
    fileprivate func setupTipLabel() {
    
        navigationController?.navigationBar.insertSubview(tipLab, at: 0)
        tipLab.frame = CGRect(x: 0, y: 12, width: UIScreen.main.bounds.width, height: 32)
        tipLab.backgroundColor = UIColor.red
        
        tipLab.textColor = UIColor.white
        tipLab.font = UIFont.systemFont(ofSize: 14)
        tipLab.textAlignment = .center
        tipLab.isHidden = true
    }
    
    //添加图片的点击通知
    fileprivate func addNotifiction() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(noti:)), name: NSNotification.Name.init(showPhotoBrowserNote), object: nil)
    }
}

// MARK: -事件监听
extension HomeViewController {
    
    @objc fileprivate func titleBtnClick() {
                
        let presentVC = PresentViewController()
        
        //设置转场model的类型 .custom设置后 present视图下面的view不会被删除
        presentVC.modalPresentationStyle = .custom
        
        presentVC.transitioningDelegate = popoverAnimator
        
        popoverAnimator.presentedFrame = CGRect(x: (UIScreen.main.bounds.width - 180 ) * 0.5, y: 55, width: 180, height: 240)
        
        present(presentVC, animated: true, completion: nil)
    }
    
    //监听微博图片的点击
    @objc fileprivate func showPhotoBrowser(noti : Notification) {
        
        let urls = noti.userInfo![showPhotoBrowserURLKey] as! [URL]
        let index = noti.userInfo![showPhotoBrowserIndexKey] as! IndexPath
        let objc = noti.object as! PicCollectionView
        
        let photoBrowserVC = YoungPhotoBrowserViewController(index: index, picURLs: urls)
        
        photoBrowserVC.modalPresentationStyle = .custom
        
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        
        photoBrowserAnimator.presentedDelegate = objc
        photoBrowserAnimator.indexPath = index
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        
        present(photoBrowserVC, animated: true , completion: nil)
    }
}

// MARK: -请求数据
extension HomeViewController {

    //请求数据
    @objc fileprivate func requestHomeData(isNewData : Bool) {
        
        var since_id :Int = 0
        var max_id : Int = 0
        if isNewData {
            since_id = statusMArr.first?.statusModel?.mid ?? 0
        } else {
            since_id = statusMArr.last?.statusModel?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
 
        NetworkTools.shareInstance.requestHomeStausesData(since_id: since_id, max_id: max_id) { (resultArr, error) in
            
            guard let arr = resultArr , error == nil , arr.count != 0 else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()                
                return
            }
            
            var tempArr = [HomeViewModel]()
            for dict in arr {
                let model = HomeStatusModel(dict: dict)
                let viewModel = HomeViewModel(statusModel: model)
                tempArr.append(viewModel)
            }
            
            if isNewData {
                self.statusMArr =  tempArr + self.statusMArr
            }else {
                self.statusMArr +=  tempArr
            }
            
            self.cacheContentPic(cacheArr: tempArr)
//            self.showTipLab(count: tempArr.count)
        }
    }
    
    //下载内容中的图片 开发过程中不需要这步
    fileprivate func cacheContentPic(cacheArr : [HomeViewModel]) {
    
        let group = DispatchGroup()
        
        for viewModel in cacheArr {
            for url in viewModel.textPicUrls {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
   
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            
        }
    }
    
    
    fileprivate func showTipLab(count : Int) {
        self.tipLab.isHidden = false
        tipLab.text = count == 0 ? "没有新微薄" : "\(count)个新微薄"
        UIView.animate(withDuration: 1, animations: {
            self.tipLab.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 1.5, options: [], animations: {
                self.tipLab.frame.origin.y = 12
            }, completion: { (_) in
                self.tipLab.isHidden = true
            })
        }
    }
}

// MARK: - Table view data source
extension HomeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusMArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeStatusCellID", for: indexPath) as! HomeTableViewCell
        let model = statusMArr[indexPath.row]
        cell.model = model
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let model = statusMArr[indexPath.row]
//        return model.cellHeight
//    }
 
}







