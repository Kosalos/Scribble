import UIKit

class CanvasView: UIImageView {
    private let defaultLineWidth:CGFloat = 16
    private var drawColor: UIColor = UIColor.blue
    var penAngle:CGFloat = 0
    var vector:CGVector = CGVector()
    var style:Int = 0
    
    func changeStyle(_ s:Int) { style = s }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            vector = t.azimuthUnitVector(in:nil)
            
            if vector.dx == 0 && vector.dy == 0 {   // Ruban:  added this so it works (badly) with just finger swipes
                let pt = t.location(in: self)
                vector.dx = pt.x
                vector.dy = pt.y
            }
       }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        image?.draw(in: bounds)
        
        penAngle = t.azimuthAngle(in: nil)
        vector = t.azimuthUnitVector(in:nil)
        
        if vector.dx == 0 && vector.dy == 0 {   // Ruban:  added this so it works (badly) with just finger swipes
            let pt = t.location(in: self)
            vector.dx = pt.x
            vector.dy = pt.y
        }

        drawStroke(context: context, touch: t)

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func lineWidthForDrawing(context: CGContext?, touch: UITouch) -> CGFloat {
        let maxW:Float = 100
        let fdx = fabs(Float(vector.dx))
        var w = 1 + logf(3 * fdx) * 60
        if w < 1 { w = 1 }
        if w > maxW { w = maxW }
        return CGFloat(w)
    }
    
    private func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        let lineWidth = lineWidthForDrawing(context: context, touch: touch)

        var x = fabs(vector.dx)
        if x > 1 { x = 1 }
        
        switch style {
        case 0,1 : drawColor = UIColor(hue:CGFloat( Float(1 - x)), saturation: 1.0, brightness: 1.0, alpha: fabs(vector.dy))
        default :  drawColor = UIColor(red:x, green:x, blue:x,  alpha: fabs(vector.dy))
        }
        
        drawColor.setStroke()
        
        context!.setLineWidth(lineWidth)
        context!.setLineCap(.round)
        
        context?.move(to:previousLocation)
        context?.addLine(to:location)
        context!.strokePath()
    }
    
    func clearCanvas() {
        image = nil
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        switch style {
        case 1,3 : UIColor.white.set()
        default : UIColor.black.set()
        }
        
        context!.fill(self.bounds)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
