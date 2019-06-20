//
//  AppDelegate.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 23/09/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 DataController.sharedInstance.load()
        return true
    }

    func saveViewContext() {
        try? DataController.sharedInstance.viewContext.save()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
}
