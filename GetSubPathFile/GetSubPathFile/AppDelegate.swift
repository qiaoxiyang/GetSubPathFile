//
//  AppDelegate.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//
//
/*
 **********************
 *
 * 博客地址 :http://www.jianshu.com/p/b32bddf118c7
 * GitHub: https://github.com/qiaoxiyang
 *
 **********************
 */
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        //当点击关闭按钮的时候结束APP进程
        return true
    }
    
    
    @IBAction func helpAction(_ sender: Any) {
        
        NSWorkspace.shared().open(URL(string: "https://github.com/qiaoxiyang/GetSubPathFile")!)
    }
    
    

}

