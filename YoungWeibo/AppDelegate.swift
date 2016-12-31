//
//  AppDelegate.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/9.
//  Copyright © 2016年 杨羽. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultContr : UIViewController? {
    
        let isLogin = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? YoungWelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //设置他tabBar颜色
        //在storyboard里设置 Image Tint一样的效果
        //        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultContr
        window?.makeKeyAndVisible()
  
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
    }


}

// MARK: -自定义打印
func NSLog<Temp>(message : Temp , fileName : String = #file , funcName : String = #function , line : Int = #line)  {
    
    //判断如果在debug模式下才打印
    #if DEBUG
       
        let className = (fileName as NSString).lastPathComponent
        //    print("[\(className)]{\(funcName)}(\(line)):\(message)")
        print("[\(className)]-(\(line))-:\(message)")
    
    #endif
    
    
    
}

