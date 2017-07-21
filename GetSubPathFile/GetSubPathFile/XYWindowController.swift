//
//  XYWindowController.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/7/21.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa

class XYWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        //设置titlebar透明
        self.window?.titlebarAppearsTransparent = true
        //隐藏title
        self.window?.titleVisibility = .hidden
        //隐藏最大化按钮
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
        
        //禁止使用window动态放大
        self.window?.styleMask = [.titled,.closable]
    }

}
