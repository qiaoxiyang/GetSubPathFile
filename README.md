#GetSubPathFile
##前言
> 前几天在开发项目的时候，由于APP整体色调的改变，UI向我要工程中所有的图标要进行修改。但在Finder中工程文件Assets是这样显示的

>![屏幕快照 2017-07-21 下午3.10.56.png](http://upload-images.jianshu.io/upload_images/1180232-db2a360d847a4a03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
那么多的文件夹中不单单只有png图片 ，还有json等乱七八糟的东西。作为程序员的我总不能一个个筛选给调出来吧，那么就写了点简短的代码给筛选出来了。


##简短的筛选代码

使用递归算法将所需文件类型筛选出：

    NSMutableArray* getImage(NSArray *array){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *imgArr = [NSMutableArray array];
    
    for (NSString *path in array) {
        if ([path hasSuffix:@".png"]) {
            [imgArr addObject:path];
        }else{
            NSArray *pathArr = [fileManager subpathsAtPath:path];
            if (pathArr.count>0) {
                [imgArr addObjectsFromArray:getImage(pathArr)];
            }
            
        }
    }
    return imgArr;
    }
之后使用`NSFileManager`将筛选的图片copy到一个新的文件夹中就算实现了。

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileStr = [NSString stringWithFormat:@"%@/Desktop/ZiChanXunCha/ZiChanXunCha/Assets.xcassets/KeHuDaiKuan",NSHomeDirectory()];
        
        NSArray *subPath = [fileManager subpathsAtPath:fileStr];
        
        NSMutableArray *imgArr = getImage(subPath);
        NSLog(@"%@",imgArr);
        
        NSString *nFileStr = [NSString stringWithFormat:@"%@/Desktop/NEWFile",NSHomeDirectory()];
        
        for (NSString *file in imgArr) {
            NSString *endFileStr = [fileStr stringByAppendingPathComponent:file];
            NSString *toFileStr = [nFileStr stringByAppendingPathComponent:[file lastPathComponent]];
            [fileManager copyItemAtPath:endFileStr toPath:toFileStr error:nil];
        }
但想想这段代码可以更灵活的去筛选其它文件类型，于是就有了写一个Mac APP的想法。
##GetSubPathFile的诞生
####什么是GetSubPathFile和如何使用？
* 通过拖拽你想要筛选的文件所在文件夹，无论这个类型的文件所在的文件夹层次有多复杂，它都可以帮你把这个类型文件找出来。
左边的`DragIn`是被筛选的文件夹，右边的`Export`是你想要将筛选出来的文件存放的文件夹。

![Select.gif](http://upload-images.jianshu.io/upload_images/1180232-59ce4aad49fac6ab.gif?imageMogr2/auto-orient/strip)
####GetSubPathFile的实现
`GetSubPathFile`是通过`Swift`来进行编写的，主要就是使用递归算法，在此贴出部分主要代码：
* 根据后缀名筛选出符合的文件
  
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
* 重命名重复文件名
    
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
GetSubPathFile软件我已导出，[点此处获取](https://pan.baidu.com/s/1i4VsJRJ )，密码: qc4c 
详细代码查看：[GetSubPathFile](https://github.com/qiaoxiyang/GetSubPathFile)，如果你喜欢这款工具的话，请给个Star。
⚠️在此声明，GetSubPathFile为本人原创，请勿修改名称上架App Store，此代码仅供学习交流使用。如果你又更好的实现方法，请留言。
