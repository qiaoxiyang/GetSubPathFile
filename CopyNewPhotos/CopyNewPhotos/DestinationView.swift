import Foundation
import Cocoa
public protocol XYDragDropViewDelegate {
    func dragDropFilePathList(array:Array<String>,view:NSView)
}

class DestinationView: NSView {
    var isHighlighed: Bool! = false
    var delegate:XYDragDropViewDelegate?
    var xy_tag = 0
    
    override func awakeFromNib() {
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    func isHighlighted() -> Bool! {
        return self.isHighlighed
    }
    func setHighlighted(value: Bool) {
        self.isHighlighed = value
        needsDisplay = true
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if self.isHighlighed == true {
            NSBezierPath.setDefaultLineWidth(6.0)
            NSColor.keyboardFocusIndicatorColor.set()
            NSBezierPath.stroke(dirtyRect)
        }
    }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteBoard = sender.draggingPasteboard()
        if (pasteBoard.types?.contains(NSFilenamesPboardType))! {
            let paths = pasteBoard.propertyList(forType: NSFilenamesPboardType) as! [String]
            for path in paths {

                let utiType = try! NSWorkspace.shared().type(ofFile: path)


                if !NSWorkspace.shared().type(utiType, conformsToType: String(kUTTypeFolder)) {
                    self.setHighlighted(value: false)
                    return []
                }

            }
        }
        NSCursor.dragCopy().set()
        self.setHighlighted(value: true)
        return NSDragOperation.every

    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        NSCursor.arrow().set()
        self.setHighlighted(value: false)
    }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        
        let filePathList = pboard.propertyList(forType: NSFilenamesPboardType) as? Array<String>
         delegate?.dragDropFilePathList(array: filePathList!,view: self);
        Swift.print(filePathList ?? "No files")
        return true
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.setHighlighted(value: false)
        
        return true
    }
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        let files = sender?.draggingPasteboard().propertyList(forType: NSFilenamesPboardType)
//        Swift.print(files ?? "No files")
    }
}
