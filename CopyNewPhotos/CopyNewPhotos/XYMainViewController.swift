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
    
    @IBOutlet weak var inLab: NSTextField!
    @IBOutlet weak var outLab: NSTextField!
    @IBOutlet weak var inFileImage: NSImageView!
    @IBOutlet weak var inFileName: NSTextField!
    @IBOutlet weak var exportFileImage: NSImageView!
    @IBOutlet weak var exportFileName: NSTextField!//输出文件路径名称
    @IBOutlet weak var extionField: NSTextField!
    
    let fileManager = FileManager.default
    var oldPathArr :Array<String>?
    var oldPath :NSString? //拖入的路径
    var exportPath :NSString?//输出路径
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        self.dragInView.layer?.backgroundColor = NSColor.red.cgColor
        self.dragInView.delegate = self
        self.dragInView.xy_tag = 100
        self.dragOutView.delegate = self
        self.dragOutView.xy_tag = 101
        
    }
    
    @IBAction func startButtonAction(_ sender: NSButton) {
        if self.validateCanExport()==false {
            return
        }
        oldPathArr = self.getImage(array: [self.oldPath! as String]) as? Array<String>
        
        if (oldPathArr?.count)!>0 {
            for file in oldPathArr! {
                let filePath = file as NSString
                let lastComponent = filePath.lastPathComponent
                let endFileStr =  oldPath?.appendingPathComponent(file)
                
                let toFileStr = self.exportPath?.appendingPathComponent(lastComponent)
                let exportFilePath = self.isExistFile(fileNamePath: toFileStr!, count: 1)
                
                try! fileManager.copyItem(atPath: endFileStr!, toPath: exportFilePath!)
                
            }
        }
    }
    
    func validateCanExport() -> Bool {
        
        if self.oldPath==nil {
            let alert = NSAlert()
            alert.messageText = "没有可用文件"
            alert.informativeText = "请拖入被筛选的文件!"
            alert.addButton(withTitle: "好的")
            alert.alertStyle = .warning
            alert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) in
                
            })
            return false
        }
        
        if self.exportPath==nil {
            let alert = NSAlert()
            alert.messageText = "没有导出文件路径"
            alert.informativeText = "请拖入被导出的文件!"
            alert.addButton(withTitle: "好的")
            alert.alertStyle = .warning
            alert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) in
                
            })
            return false
        }
        return true
        
    }

    
    func isExistFile(fileNamePath:String,count:NSInteger) -> String? {
        let isExist = fileManager.fileExists(atPath: fileNamePath)
        
        if isExist {
            let pathExtension = (fileNamePath as NSString).pathExtension
            var noExtensionPath = (fileNamePath as NSString).deletingPathExtension
            
            noExtensionPath = noExtensionPath + "-\(count)"
            noExtensionPath = (noExtensionPath as NSString).appendingPathExtension(pathExtension)!
            let nCount = count+1
            
            return self.isExistFile(fileNamePath: noExtensionPath, count: nCount)
        }else{
            
            return fileNamePath
        }
        
    }
    
    func dragDropFilePathList(array: Array<String>, view: NSView) {
        print("拖出文件路径\(array)")
        if array.count==0 {
            print("拖入的文件为空")
            
            return
        }
        let destinationView = view as!DestinationView
        let fileNamePath = array.first as NSString?
        
        if destinationView.xy_tag==100 {
            //
            self.showFilePath(isExportFile: false, fileName: fileNamePath!, isHidden: false)
            self.oldPath = fileNamePath
        }else{
            //
            self.showFilePath(isExportFile: true, fileName: fileNamePath!, isHidden: false)
            self.exportPath = fileNamePath
        }
    }
    
    
    /// 配置是否显示文件名称
    ///
    /// - Parameters:
    ///   - isExportFile: 是否为输出文件名
    ///   - fileName: 文件名称
    ///   - isHidden: 是否隐藏
    func showFilePath(isExportFile:Bool,fileName:NSString,isHidden:Bool) {
        
        let lastCompoent = fileName.lastPathComponent
        
        if isExportFile {
            self.exportFileName.isHidden = isHidden
            self.exportFileImage.isHidden = isHidden
            self.exportFileName.stringValue = lastCompoent
            self.outLab.textColor = NSColor.lightGray
        }else{
            self.inFileName.isHidden = isHidden
            self.inFileImage.isHidden = isHidden
            self.inFileName.stringValue = lastCompoent
            self.inLab.textColor = NSColor.lightGray
        }
    }
    
    
    func getImage(array:Array<String>) -> NSMutableArray {
        let imgArr = NSMutableArray()
        var extionPath = ".png"
        if self.extionField.stringValue.characters.count>0 {
            extionPath = self.extionField.stringValue
        }
        
        for path in array {
            if path.hasSuffix(extionPath) {
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
