//
//  CustomDrawPathView.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/5/22.
//  Copyright © 2017年 Ufispace. All rights reserved.
//

import UIKit

//MARK: setup
extension CustomDrawPathView {
    func setupInitValue() {
        self.backgroundColor = UIColor.clear
        self.displayLink = CustomDisplayLink()
        self.displayLink.delegate = self
    }
}


//MARK: CustomDisplayLinkDelegate
extension CustomDrawPathView : CustomDisplayLinkDelegate {
    func displayWillUpdateWithDeltaTime(deltaTime: CFTimeInterval) {
        DispatchQueue.global(qos: .`default`).async {
            let deltaValue = min(1.0, deltaTime / (1.0 / self.framePerSecond))
            self.length += (self.lengthIteration * deltaValue)
            //算完以後回 main thread 囉
            DispatchQueue.main.async {
                self.pathImage = self.preDrawPathImage()
                self.setNeedsDisplay()
            }
        }
    }
    
    fileprivate func preDrawPathImage() -> UIImage{
        var drawPathImage:UIImage
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //設定線條的粗細, 以及圓角
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(self.hudLineWidth)
        
        //劃勾勾的線
        var length:CGFloat = CGFloat(self.length)
        for index in 0...self.drawPaths.count - 1 {
            let subArray:[CGPoint] = self.drawPaths[index]
            let firstPoint:CGPoint = subArray[0]
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            
            var isBreak:Bool = false
            for subIndex in 0...subArray.count - 2 {
                let pointA:CGPoint = subArray[subIndex]
                let pointB:CGPoint = subArray[subIndex + 1]
                let distance:CGFloat = self.distanceA(pointA: pointA, toB: pointB)
                if (length < distance) {
                    let percentA:CGFloat =  length / distance
                    let percentB:CGFloat = 1 - percentA
                    let newPoint:CGPoint = CGPoint(x: pointA.x * percentB + pointB.x * percentA, y: pointA.y * percentB + pointB.y * percentA)
                    context.addLine(to: CGPoint(x: newPoint.x, y: newPoint.y))
                    isBreak = true
                    break
                }
                else {
                    context.addLine(to: CGPoint(x: pointB.x, y: pointB.y))
                    length -= distance
                }
            }
            
            if (isBreak == true) {
                break
            }
        }
        self.pathColor.set()
        
        //著色
        context.strokePath()
        drawPathImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return drawPathImage
    }
    
    fileprivate func distanceA(pointA:CGPoint ,toB pointB:CGPoint) ->CGFloat {
        return sqrt(pow(abs(pointA.x - pointB.x), 2) + pow(abs(pointA.y - pointB.y), 2))
    }
}


//MARK: method override
extension CustomDrawPathView {
    //這邊主要就只負責把圖畫出來
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.pathImage?.draw(in: rect)
    }
}

//MARK: life cycle
class CustomDrawPathView: UIView {
    var length:CFTimeInterval = 0
    var pathColor:UIColor = UIColor.lightGray
    var pathImage:UIImage?
    var displayLink:CustomDisplayLink!
    let framePerSecond:CFTimeInterval = 60.0
    let lengthIteration:CFTimeInterval = 1.6
    let hudLineWidth:CGFloat = 3.0
    var drawPaths:[[CGPoint]] = [[CGPoint]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitValue()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        //從 newSuperview 的有無可以判斷現在是被加入或是被移除
        if (newSuperview == nil) {
            self.displayLink.removeDisplayLink()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
