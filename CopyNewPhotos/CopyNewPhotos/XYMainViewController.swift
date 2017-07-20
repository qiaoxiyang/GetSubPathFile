//
//  XYMainViewController.swift
//  CopyNewPhotos
//
//  Created by xiyang on 2017/6/28.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import Cocoa


class XYMainViewController: NSViewController ,XYDragDropViewDelegate,NSTableViewDelegate,NSTableViewDataSource{

    
    
    @IBOutlet weak var dragInView: DestinationView!
    @IBOutlet weak var dragOutView: DestinationView!
    @IBOutlet weak var dragInTableView: NSTableView!
    
    @IBOutlet weak var inLab: NSTextField!
    @IBOutlet weak var outLab: NSTextField!

    @IBOutlet weak var exportFileImage: NSImageView!
    @IBOutlet weak var exportFileName: NSTextField!//输出文件路径名称
    @IBOutlet weak var extionField: NSTextField!
    @IBOutlet weak var popUpBtn: NSPopUpButton!
    
    let fileManager = FileManager.default
    //拖入文件数组
    lazy var dragInPathArr :Array<String> = {
        return Array()
    }()
    
    
    var exportPath :NSString?//输出路径
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        self.dragInView.layer?.backgroundColor = NSColor.red.cgColor
        self.dragInView.delegate = self
        self.dragInView.xy_tag = 100
        self.dragOutView.delegate = self
        self.dragOutView.xy_tag = 101
        self.dragOutView.layer?.backgroundColor = NSColor.white.cgColor
        self.dragInTableView.delegate = self
        self.dragInTableView.dataSource = self
        self.dragInTableView.headerView = nil
        self.popUpBtn.removeAllItems()
        self.popUpBtn.addItems(withTitles: ["png","jpg","doc","docx","xlsx","pptx","psd","pdf","cs"])
        
    }
    
    @IBAction func startButtonAction(_ sender: NSButton) {
   
        guard self.validateCanExport() else {
            return
        }

        for contentPath in self.dragInPathArr {
            self.copyNewFile(fileArr: [contentPath])
        }
    }
    
    
    
    
    func copyNewFile(fileArr:Array<String>) {
        
        let dragInFileArray = self.getImage(array: fileArr) as? Array<String>
        let oldPath = fileArr.first! as NSString
        
        guard (dragInFileArray?.isEmpty)! else {
            
            for file in dragInFileArray! {
                let filePath = file as NSString
                let lastComponent = filePath.lastPathComponent
                let endFileStr =  oldPath.appendingPathComponent(file)
                let toFileStr = self.exportPath?.appendingPathComponent(lastComponent)
                let exportFilePath = self.isExistFile(fileNamePath: toFileStr!, count: 1)
                try! fileManager.copyItem(atPath: endFileStr, toPath: exportFilePath!)
            }
            return
        }
    }
    
    
    //校验输入和输出文件是否存在
    func validateCanExport() -> Bool {
        
        if self.dragInPathArr.isEmpty {
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

    //输出文件是否重复
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
    
    //XYDragDropViewDelegate
    func dragDropFilePathList(array: Array<String>, view: NSView) {
        print("拖出文件路径\(array)")
        if array.count==0 {
            print("拖入的文件为空")
            return
        }
        let destinationView = view as!DestinationView
        let isExportFile = destinationView.xy_tag==100 ? false : true
        self.showFilePath(isExportFile: isExportFile, fileArray: array, isHidden: false)
    }
    
    
    /// 配置是否显示文件名称
    ///
    /// - Parameters:
    ///   - isExportFile: 是否为输出文件名
    ///   - fileName: 文件名称
    ///   - isHidden: 是否隐藏
    func showFilePath(isExportFile:Bool,fileArray:Array<String>,isHidden:Bool) {
        
        if isExportFile {
            self.exportPath = fileArray.first! as NSString
            self.exportFileName.isHidden = isHidden
            self.exportFileImage.isHidden = isHidden
            self.exportFileName.stringValue = self.exportPath as! String
            self.outLab.textColor = NSColor.lightGray
            
        }else{
            let arraySet = Set(fileArray)
            let dragInPathSet = Set(self.dragInPathArr)
            let nSet = arraySet.union(dragInPathSet).sorted()
            self.dragInPathArr = nSet
            self.dragInTableView.reloadData()
            self.inLab.textColor = NSColor.lightGray
        }
    }
    
    //获取筛选的文件名
    func getImage(array:Array<String>) -> NSMutableArray {
        let imgArr = NSMutableArray()
        var extionPath = self.popUpBtn.selectedItem?.title as! NSString
        if self.extionField.stringValue.characters.count>0 {
            extionPath = self.extionField.stringValue as NSString
        }
        
        for pathStr in array {
            let path = pathStr as NSString
            let extensionStr = path.pathExtension
            
            if extionPath.contains(extensionStr) {
                imgArr.add(path)
            }else{
                let pathArr = fileManager.subpaths(atPath: pathStr)
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
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.dragInPathArr.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let pathStr = self.dragInPathArr[row]
        let identifier = tableColumn?.identifier as! NSString
        
        if identifier.isEqual(to: "FilePathCell") {
            let cellView = tableView.make(withIdentifier: identifier as String, owner: self) as! XYTableCellView
            cellView.fileNameLab.stringValue = (pathStr as NSString).lastPathComponent
            cellView.filePathLab.stringValue = pathStr
            return cellView
        }
        return nil
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
}
