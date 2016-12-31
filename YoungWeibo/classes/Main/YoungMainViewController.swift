//
//  YoungMainViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/9.
//  Copyright © 2016年 杨羽. All rights reserved.
//      //print(HomeViewController()) +YoungWeibo.了
//      <YoungWeibo.HomeViewController: 0x7feb92f03790>
//  fileprivate 文件内私有属性和方法，仅在当前文件中可以访问，包括同一个文件中不同的类。
//  private 私有属性和方法，仅在当前类中可以访问，不包括分类；

import UIKit

class YoungMainViewController: UITabBarController {
    
    fileprivate lazy var composeBtn : UIButton = UIButton.init(iamgeName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComposeBtn()
        

    }
    
}


// MARK: -初始化ui
extension YoungMainViewController {
    
    ///初始化按钮
    fileprivate func setupComposeBtn() {
    
        tabBar.addSubview(composeBtn)
        composeBtn.center = CGPoint.init(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //#selector(YoungMainViewController.composeBtnClick)
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
    }

    
}

// MARK: -事件监听
extension YoungMainViewController {

    // 事件监听本质发送消息.但是发送消息是OC的特性
    // 将方法包装成@SEL --> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
    // 如果swift中将一个函数声明称private,那么该函数不会被添加到方法列表中
    // 如果在private前面加上@objc,那么该方法依然会被添加到方法列表中
    @objc fileprivate func composeBtnClick() {
      
        let composeVC = ComposeViewController()
        let nav = UINavigationController(rootViewController: composeVC)
        present(nav, animated: true, completion: nil)
    }
}

// MARK: -手写代码 初始化控制器
extension YoungMainViewController {

     
    /// 初始化vc
//    func initChildVC() {
//        
//        //1.先去拿到json的路径
//        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings", ofType: "json") else {
//            print("没有拿到MainVCSettings.json文件")
//            return
//        }
//        
//        //2.根据路径去转成NSData
//        
//        
//        
////        guard let jsonData =  Data(contentsOfFile: jsonPath) else {
////            print("没有拿到json文件里的data数据")
////            return
////        }
//        
//        //3.然后从NSData转成 Any 类型
//        guard let obj =  try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
//            
//            return
//        }
//        
//        //4.然后从Any类型转成Array类型
//        guard let dictArr = obj as? [[String : Any]] else {
//            
//            return
//        }
//        
//        //5.遍历数组,然后取出对应的值
//        for dict in dictArr {
//            
//            guard let vcName = dict["vcName"] as? String else {
//                continue
//            }
//            
//            
//            guard let title = dict["title"] as? String else {
//                continue
//            }
//            
//            guard let imageName = dict["imageName"] as? String else {
//                continue
//            }
//            
//            
//            addChildViewController(childVCName: vcName, title: title, image: imageName)
//        }
//        
//        //        addChildViewController(childVCName: "HomeViewController", title: "首页", image: "tabbar_home")
//        //        addChildViewController(childVCName: "MessageViewController", title: "消息", image: "tabbar_message_center")
//        //        addChildViewController(childVCName: "DiscoveryViewController", title: "发现", image: "tabbar_discover")
//        //        addChildViewController(childVCName: "ProfileViewController", title: "我", image: "tabbar_profile")
//        
//    }
    
    
    /// 添加子控制器
    func addChildViewController(_ childVCName : String , title : String , image : String) {
        
        //取出info.plist里Executable file //YoungWeibo就是拿到项目名称
        guard let nameSpace =  Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            
            print("没有获取到info.plist里的字段")
            return
        }
        
        guard let className = NSClassFromString(nameSpace + "." + childVCName) else {
            
            print("没有获取到className")
            return
        }
        
        
        guard let childVCType = className as? UIViewController.Type else {
            
            print("没有获拿到控制器类型")
            return
        }
        
        let childVC = childVCType.init()
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: image)
        childVC.tabBarItem.selectedImage = UIImage.init(named: image + "_highlighted")
        
        let nav = UINavigationController(rootViewController: childVC)
        
        addChildViewController(nav)
        
    }
}


