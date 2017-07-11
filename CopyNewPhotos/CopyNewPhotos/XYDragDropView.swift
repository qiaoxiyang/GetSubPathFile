//
//  XYDragDropView.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa

public protocol XYDragDropViewDelegate {
    func dragDropFilePathList(array:Array<String>)
}

class XYDragDropView: NSView {

    var delegate:XYDragDropViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册view拖动事件监听的数据类型为文件类型
        self.register(forDraggedTypes: [NSFilenamesPboardType]);
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pboard = sender.draggingPasteboard()
        if (pboard.types?.contains(NSFilenamesPboardType))! {
            return .copy
        }
        return .init(rawValue: 0)
    }
    
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        
        let filePathList = pboard.propertyList(forType: NSFilenamesPboardType)
        
        delegate?.dragDropFilePathList(array: filePathList as! Array<String>);
        
        return true
    }
    
}
