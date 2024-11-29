//
//  AppDelegate.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //设置http代理，firebase不支持socks5代理
        setenv("grpc_proxy", "http://127.0.0.1:1087", 1)
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        print(db) //测试是否成功，要出现<FIRFirestore: 0x600002129c70>字样
        
        IQKeyboardManager.shared.isEnabled = true
        //IQKeyboardManager.shared.enableAutoToolbar = true //出现done的标志
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        //全局样式-顶部菜单颜色
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: K.BrandColors.blue)  // 设置背景色
        
        // 设置标题字体和颜色
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 25, weight: .black),  // 设置字号为28
            .foregroundColor: UIColor.white        // 设置颜色为白色
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

