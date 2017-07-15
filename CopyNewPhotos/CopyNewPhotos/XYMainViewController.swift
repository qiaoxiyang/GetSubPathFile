//
//  XYMainViewController.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa

class XYMainViewController: NSViewController,XYDragDropViewDelegate {

    @IBOutlet weak var dragInView: XYDragDropView!
    @IBOutlet weak var dragOutView: XYDragDropView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.dragInView.layer?.backgroundColor = NSColor.red.cgColor
        self.dragInView.delegate = self
        self.dragOutView.delegate = self
    }
    
    func dragDropFilePathList(array: Array<String>) {
        print(array);
    }
    
}
