//
//  XYMainViewController.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa

class XYMainViewController: NSViewController {

    @IBOutlet weak var dragInView: XYDragDropView!
    @IBOutlet weak var dragOutView: XYDragDropView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.dragInView.layer?.backgroundColor = NSColor.red.cgColor
        
    }
    
}
