//
//  XYMainViewController.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa


class XYMainViewController: NSViewController ,XYDragDropViewDelegate{


    @IBOutlet weak var dragInView: DestinationView!
    @IBOutlet weak var dragOutView: DestinationView!
    let fileManager = FileManager.default
    var oldPathArr :Array<String>?
    var oldPath :NSString?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        self.dragInView.layer?.backgroundColor = NSColor.red.cgColor
        self.dragInView.delegate = self
        self.dragInView.xy_tag = 100
        self.dragOutView.delegate = self
        self.dragOutView.xy_tag = 101
    }
    
    func dragDropFilePathList(array: Array<String>, view: NSView) {
        print(array)
        let destinationView = view as!DestinationView
        if destinationView.xy_tag==100 {
            //
             print("拖入文件路径\(array)")
            if array.count>0 {
                oldPath = array.first as? NSString
            }
            oldPathArr = self.getImage(array: array) as? Array<String>
        }else{
            //
             print("拖出文件路径\(array)")
            if array.count==0 {
                print("拖入的文件为空")
                return
            }
            let nFileStr = array.first as? NSString
            
            if (oldPathArr?.count)!>0 {
                for file in oldPathArr! {
                    let filePath = file as NSString
                    let lastComponent = filePath.lastPathComponent
                    let endFileStr =  oldPath?.appendingPathComponent(file)
                    
                    let toFileStr = nFileStr?.appendingPathComponent(lastComponent)
                
                    try! fileManager.copyItem(atPath: endFileStr!, toPath: toFileStr!)
                  
                    
                }
            }
            
        }
        
    }
    
    func getImage(array:Array<String>) -> NSMutableArray {
        
        let imgArr = NSMutableArray()
        for path in array {
            if path.hasSuffix(".png") {
                
                
                imgArr.add(path)
            }else{
                let pathArr = fileManager.subpaths(atPath: path)
                if pathArr==nil {
                    continue
                }
                if (pathArr?.count)!>0 {
                    imgArr.addObjects(from: self.getImage(array: pathArr! ) as! [Any])
                }
            }
        }
        return imgArr
    }
    
}
