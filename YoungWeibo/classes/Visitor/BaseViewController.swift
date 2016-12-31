//
//  BaseViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/10.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SDWebImage

class BaseViewController: UITableViewController {


    lazy var visitorView : VisitorView = VisitorView.visitorView()
    var isLogin : Bool = UserAccountViewModel.shareIntance.isLogin
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }


}


// MARK: -setupUI
extension BaseViewController {

    //设置view==访客view
    fileprivate func setupVisitorView() {
        view = visitorView
        
        //给按钮添加监听
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        
    }
    
    //设置导航栏左右标题
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self , action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self , action: #selector(loginBtnClick))
    
    }
    
}


// MARK: -监听点击
extension BaseViewController {

    @objc fileprivate func registerBtnClick() {
        print("registerBtnClick")
        
        ShowTip.showHudTip(tipStr: "请求超时")
    }
    
    @objc fileprivate func loginBtnClick() {
        
        let loginVC = LoginViewController()
        
        let nav = UINavigationController(rootViewController: loginVC)
        
        present(nav, animated: true, completion: nil)
        
        
    }
}

