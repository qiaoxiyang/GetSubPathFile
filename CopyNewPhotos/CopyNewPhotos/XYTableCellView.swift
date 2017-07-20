//
//  XYTableCellView.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/7/20.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa

class XYTableCellView: NSTableCellView {

    
    @IBOutlet weak var fileNameLab: NSTextField!
    @IBOutlet weak var filePathLab: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
