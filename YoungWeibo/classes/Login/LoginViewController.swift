//
//  LoginViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/12.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SVProgressHUD


class LoginViewController: UIViewController {

    // MARK: -熟悉
    @IBOutlet weak var webV: UIWebView!
    
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupWebView()
    }

    

}

// MARK: -设置ui
extension LoginViewController {

    fileprivate func setupNavBar() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(leftBarItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(rightBarItemClick))
        title = "登录页面"
    }
    
    
    fileprivate func setupWebView() {
    
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(sinaApp_Key)&redirect_uri=\(sina_redirect_uri)"
    
        NSLog(message: urlStr)
        
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let request = URLRequest.init(url: url)
        webV.loadRequest(request)
        
    }
}

// MARK: -事件监听
extension LoginViewController {

    @objc fileprivate func leftBarItemClick() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightBarItemClick() {
        
    }
    
}

// MARK: -webView的代理
extension LoginViewController : UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
    
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    //webView准备加载某个网页时,会执行这个方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        guard let url = request.url else {
            return true
        }
            
        guard url.absoluteString.contains("code=")  else {
           return true
        }
        
        let code = url.absoluteString.components(separatedBy: "code=").last!
        
        questAccess_tokenData(code: code)
        
        return false
    }
}


// MARK: -数据请求
extension LoginViewController {

    
    //请求accesstoken
    fileprivate func questAccess_tokenData(code : String) {
        
        NetworkTools.shareInstance.requestAccessToken(code: code) { (result, error) in
            
            if error != nil {
                NSLog(message:error!)
                return
            }
                        
            guard let dict = result else {
            
                return
            }
            
            let user = UserAccount(dict: dict)
            self.requestUserInfo(user: user)
            
        }

    }
    
    //请求用户信息
    fileprivate func requestUserInfo(user : UserAccount) {
        NetworkTools.shareInstance.requestUserInfo(user: user) { (result, error) in
            
            if error != nil {
                NSLog(message:error!)
                return
            }
            
            guard let dict = result else {
                return
            }
            
            user.screen_name = dict["screen_name"] as? String
            user.avatar_hd = dict["avatar_hd"] as? String
            
            var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            path = (path as NSString).appendingPathComponent("account.plist")
            
            NSKeyedArchiver.archiveRootObject(user, toFile: path)
            
            
            UserAccountViewModel.shareIntance.account = user
            
            self.dismiss(animated: false, completion: { 
                
                UIApplication.shared.keyWindow?.rootViewController = YoungWelcomeViewController()
                
            })
        }
    }

    // 登录成功后对账号存档
    fileprivate func setUserArchiver(user : UserAccount) {
    
        
    }
}



