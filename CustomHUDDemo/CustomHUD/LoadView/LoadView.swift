//
//  LoadView.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/3/23.
//  Copyright © 2017年 AllenShiu. All rights reserved.
//

import UIKit

let LoadViewSize:CGFloat = 35

// MARK: public func
extension LoadView {
    func startAnimation()  {
        // 開始動畫
        for index in 0...(self.mainCircle.sublayers?.count)! - 1 {
            let circle:CALayer = self.mainCircle.sublayers![index]
            self.transformAnimation(circle: circle, index: index)
        }
        self.rotateAnimation()
    }
    
    func stopAnimation()  {
        // 停止動畫
        for index in 0...(self.mainCircle.sublayers?.count)! - 1 {
            let circle:CALayer = self.mainCircle.sublayers![index]
            circle.removeAllAnimations()
        }
        self.mainCircle.sublayers?.removeAll()
        self.mainCircle.removeFromSuperlayer()
    }
    
}

// MARK: setup
extension LoadView :CAAnimationDelegate{
    func setupInitvalue() {
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.setupAnimation()
    }
    
    func setupAnimation() {
        self.setupAnimationLayer()
    }
    
    func setupAnimationLayer() {
        let size:CGSize = self.bounds.size
        let circleSize = size.width / 5
        // 設定主要的 Circle
        // 4 個點點都會放在他身上與設定轉動效果
        self.mainCircle.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.layer.addSublayer(mainCircle)
        
        // 長出 4 個點點
        let widthHalf = size.width/2
        let circleHalf = circleSize / 2
        let circleGap = circleSize + circleHalf
        let centerGap = widthHalf - circleGap
        let gap = size.height - circleSize
        
        // 4個點初始位置
        let xPoint = [(centerGap - circleHalf),(widthHalf + circleSize),(gap/2),(gap/2)]
        let yPoint = [(gap/2),(gap/2),(widthHalf + circleSize),(centerGap - circleHalf)]
        
        for index in 0...3 {
            let circle:CALayer = CALayer()
            let x = xPoint[index]
            let y = yPoint[index]
            circle.frame = CGRect(x: x, y: y, width: circleSize, height: circleSize)
            let color:UIColor = self.colors()[index] as! UIColor
            circle.backgroundColor = color.cgColor
            circle.opacity = 1.0
            circle.cornerRadius = circle.bounds.size.height / 2.0
            self.mainCircle.addSublayer(circle)
        }
    }
}

//MARK: misc
extension LoadView {
    func frameAnimationWithKeyPath(keyPath:String) -> CAKeyframeAnimation {
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func valuesTx(tx:CGFloat,ty:CGFloat) -> NSArray{
        // 設定每個點的移動的位置
        var transform1:CATransform3D = CATransform3DMakeTranslation(0, 0, 0)
        transform1 = CATransform3DScale(transform1, 1, 1, 0.0)
        var transform2:CATransform3D = CATransform3DMakeTranslation(tx, ty, 0)
        transform2 = CATransform3DScale(transform2, 1.0, 1.0, 0.0)
        var transform3:CATransform3D = CATransform3DMakeTranslation(-tx, -ty, 0)
        transform3 = CATransform3DScale(transform3, 1, 1, 0)
        var transform4:CATransform3D = CATransform3DMakeTranslation(0, 0, 0)
        transform4 = CATransform3DScale(transform4, 1, 1, 0)
        return [NSValue.init(caTransform3D: transform1),NSValue.init(caTransform3D: transform2), NSValue.init(caTransform3D: transform3), NSValue.init(caTransform3D: transform4)]
    }
    
    func colors() -> NSArray{
        return [UIColor.init(netHex: 0xFFA300),UIColor.init(netHex: 0xFF671b),UIColor.init(netHex: 0x59cbe8),UIColor.init(netHex: 0xf277c6)]
    }
    
    func rotateAnimation(){
        let rotateAnimation:CAKeyframeAnimation = frameAnimationWithKeyPath(keyPath:"transform.rotation.z")
        rotateAnimation.keyTimes = [0.0, 0.5, 1.0]
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        rotateAnimation.values = [0, Double.pi, (2 * Double.pi)]
        rotateAnimation.duration = CFTimeInterval(duration)
        rotateAnimation.repeatCount = HUGE
        self.mainCircle.add(rotateAnimation, forKey: "animation")
    }
    
    func transformAnimation(circle:CALayer ,index:Int){
        let size:CGSize = self.bounds.size
        let circleSize = size.width / 5
        let beginTime:TimeInterval = CACurrentMediaTime()
        
        // 長出 4 個點點 並設定動畫
        let widthHalf = size.width/2
        let circleHalf = circleSize / 2 + 4
        let circleGap = circleSize + circleHalf
        let centerGap = widthHalf - circleGap
        
        // 4個點移動的位置
        let centerX = [centerGap,-centerGap,0,0]
        let centerY = [0,0,-centerGap,centerGap]
        
        let transformAnimation:CAKeyframeAnimation  = frameAnimationWithKeyPath(keyPath:"transform")
        let x = centerX[index]
        let y = centerY[index]
        transformAnimation.values = valuesTx(tx: x, ty: y) as? [Any]
        transformAnimation.keyTimes = [0.0, 0.25,0.75, 1]
        transformAnimation.beginTime = beginTime
        transformAnimation.repeatCount = HUGE
        transformAnimation.duration = CFTimeInterval(duration / 7)
        transformAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circle.add(transformAnimation, forKey: "animation")
    }
}

// MARK - life cycle
class LoadView: UIView {
    var mainCircle:CALayer = CALayer()
    let duration:CGFloat = 4.9
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitvalue()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitvalue()
    }
}
