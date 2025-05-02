//
//  HUDViewController.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/3/29.
//  Copyright © 2017年 AllenShiu. All rights reserved.
//

import UIKit
let CosmedColor02:UIColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0, alpha: 1) 
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let ScreenWidth15:CGFloat = ScreenWidth / 15

extension HUDViewController {
    fileprivate func centerInOrientation(_ originFrame:CGRect) -> CGRect{
        let screenBounds:CGRect = UIScreen.main.bounds
        let halfScreenWidth:CGFloat = screenBounds.width / 2
        let halfScreenHeight:CGFloat = screenBounds.height / 2
        var newFrame:CGRect = originFrame
        let halfFrameWidth:CGFloat = newFrame.width / 2
        let halfFrameHeight:CGFloat = newFrame.height / 2
        newFrame.origin.x = halfScreenWidth - halfFrameWidth
        newFrame.origin.y = halfScreenHeight - halfFrameHeight
        return newFrame
    }
    
    fileprivate func toastDismissFrame(_ originFrame:CGRect) -> CGRect{
        // toast 縮下去時的 frame
        var dismissFrame = originFrame
        dismissFrame.origin = CGPoint(x: ScreenWidth15, y: ScreenHeight)
        return dismissFrame

    }
    
    fileprivate func toastShowFrame(_ originFrame:CGRect) -> CGRect{
        // toast 顯示時的 frame
        var showFrame:CGRect = originFrame
        let bottomGap:CGFloat = 10
        showFrame.origin = CGPoint(x: ScreenWidth15, y: ScreenHeight - (originFrame.height + bottomGap))
        return showFrame
    }
}

// MARK: private instance method
extension HUDViewController {
    fileprivate func setupInitValue() {
        self.view.backgroundColor = UIColor.clear
        self.maskViews.backgroundColor = self.maskColor
        self.maskViews.frame = self.view.frame
        self.maskViews.alpha = 0
        self.view.insertSubview(self.maskViews, at: 0)
    }
    
    fileprivate func setupHUD() {
        var hudMessageLabel:UILabel?
        var messageLabelWidth:CGFloat = 0
        var messageLabelHeight:CGFloat = 0
        let screenWidth3:CGFloat = ScreenWidth / 3
        
        //如果 hud message 有東西, 先算他的 size
        if (message != nil) {
            let hudMessageLabelWidth:CGFloat = screenWidth3 - 20
            hudMessageLabel = UILabel()
            hudMessageLabel?.frame = CGRect(x: 10, y: 10, width: hudMessageLabelWidth, height: 16)
            hudMessageLabel?.attributedText = self.message
            hudMessageLabel?.textAlignment = .center
            hudMessageLabel?.numberOfLines = 0
            hudMessageLabel?.sizeToFit()
            messageLabelWidth = (hudMessageLabel?.frame.width)!
            messageLabelHeight = (hudMessageLabel?.frame.height)!
            messageLabelHeight += borderGap
        }
        
        //設定 centerview 的大小
        //寬度的算法, 取 hud 本身或是 label 的最大者, 加上左右兩旁的邊框
        let centerViewWidth:CGFloat = ScreenWidth / 3
        
        //高度的算法, 只有 hud 的時候就是 hud 本身加上上下的邊框, 多 label 的話, 要在 hud 跟 label 之間多塞一個一半大小的 gap
        let height:CGFloat = HUDSize + messageLabelHeight + borderGap * 2 + ((message != nil) ? borderGap * 0.5 : 0)
        let centerViewHeight:CGFloat = max(centerViewWidth,height)
        centerView = UIView(frame:CGRect(x: 0, y: 0, width: centerViewWidth, height: centerViewHeight))
        centerView?.frame = (self.centerInOrientation((centerView?.frame)!))
        centerView?.backgroundColor = backgroundColor;
        centerView?.layer.cornerRadius = 30
        centerView?.layer.masksToBounds = true
        
        //開始把東西加入 centerView
        let halfCenterWidth:CGFloat = (centerView?.frame.width)! / 2
        let halfCenterHeight:CGFloat = (centerView?.frame.height)! / 2
        var objectHeight:CGFloat = borderGap
        var hudMessageLabelHeight:CGFloat = 0
        
        //如果有 label 的話就加
        if (self.message != nil) {
            hudMessageLabel?.frame = CGRect( x: halfCenterWidth - messageLabelWidth / 2, y: objectHeight, width: messageLabelWidth, height: messageLabelHeight)
            
            hudMessageLabel?.textColor = self.textColor
            centerView?.addSubview(hudMessageLabel!)
            hudMessageLabelHeight = (hudMessageLabel?.frame.height)!
        }
        
        //加入 hud 主體
        if (message != nil) {
            objectHeight = objectHeight + hudMessageLabelHeight + ((message != nil) ? borderGap * 0.5 : 0)
        }else{
            objectHeight = halfCenterHeight - (HUDSize / 2)
        }
        
        var hudView:UIView?
        
        switch type! {
        case .HUDTypeLoading:
            objectHeight = halfCenterHeight - (LoadViewSize / 2)
            let loadView:LoadView = LoadView.init(frame: CGRect(x: halfCenterWidth - LoadViewSize / 2, y: objectHeight, width: LoadViewSize, height: LoadViewSize))
            hudView = loadView
            loadView.startAnimation()
            break
        case .HUDTypeSuccess:
            let successView:CustomDrawPathView = CustomDrawPathView.init(frame: CGRect(x: halfCenterWidth - HUDSize / 2, y: objectHeight, width: HUDSize, height: HUDSize))
            successView.backgroundColor = UIColor.clear
            successView.pathColor = CosmedColor02
            successView.drawPaths = [[CGPoint(x: HUDSize * 0.25, y: HUDSize * 0.5),CGPoint(x: HUDSize * 0.5, y: HUDSize * 0.75),CGPoint(x: HUDSize * 0.85, y: HUDSize * 0.25)]]
            hudView = successView
            break
        case .HUDTypeFail:
            let failView:CustomDrawPathView = CustomDrawPathView.init(frame: CGRect(x: halfCenterWidth - HUDSize / 2, y: objectHeight, width: HUDSize, height: HUDSize))
            failView.backgroundColor = UIColor.clear
            failView.pathColor = UIColor.red
            failView.drawPaths = [[CGPoint(x: HUDSize * 0.15, y: HUDSize * 0.15),CGPoint(x: HUDSize * 0.85, y: HUDSize * 0.85)],[CGPoint(x: HUDSize * 0.85, y: HUDSize * 0.15),CGPoint(x: HUDSize * 0.15, y: HUDSize * 0.85)]]
            hudView = failView
            break
        }
        
        self.centerView?.addSubview(hudView!)
        self.view.addSubview(centerView!)
        
        // 顯示 
        self.showHUD()
    }
    
    func setupToast() {
        let messageLabel:UILabel = UILabel()
        messageLabel.frame = CGRect(x: 0, y: 0, width: ScreenWidth - (ScreenWidth15 * 2), height: 44)
        messageLabel.attributedText = self.message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.white
        self.centerView = UIView(frame:CGRect(x: ScreenWidth15, y: ScreenHeight, width: ScreenWidth - (ScreenWidth15 * 2), height: 44))
        self.centerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.centerView?.layer.cornerRadius = 5.0
        self.centerView?.addSubview(messageLabel)
        self.maskViews.alpha = 0
        self.view.addSubview(self.centerView!)
        // 顯示
        self.showHUD()
    }
}


// hud 帶個動畫
extension HUDViewController {
    // hide hud 然後帶個動畫
    public func hideHUD(completion:@escaping ()->()){
            UIView.animate(withDuration: 0.3/1.5, animations: {
                self.maskViews.alpha = 0
                self.centerView?.transform = CGAffineTransform(scaleX: 0.9,y: 0.9)
            }) { (Bool) in
                UIView.animate(withDuration: 0.3/2, animations: {
                    self.centerView?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1)
                }) { (Bool) in
                    UIView.animate(withDuration: 0.3/2, animations: {
                        self.centerView?.alpha = 0
                        self.centerView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }, completion: { (Bool) in
                        completion()
                    })
                }
            }
    }

    
    public func showHUD(){
            //一開始的彈出動畫效果
            centerView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            UIView.animate(withDuration: 0.3/1.5, animations: {
                self.maskViews.alpha = 1
                self.centerView?.transform = CGAffineTransform(scaleX: 1.1,y: 1.1)
            }) { (Bool) in
                    UIView.animate(withDuration: 0.3/2, animations: {
                        self.centerView?.transform = CGAffineTransform(scaleX: 0.9,y: 0.9)
                    }) { (Bool) in
                        UIView.animate(withDuration: 0.3/2, animations: {
                            self.centerView?.transform = .identity
                        })
                    }
            }
    }
}

// MARK: life cycle
class HUDViewController: UIViewController {
    // 外部帶入參數
    public var textColor: UIColor?
    public var backgroundColor: UIColor?
    public var maskColor: UIColor?
    public var allowUserInteraction:Bool?
    public var message:NSAttributedString?
    public var type:HUDType?
    public var HUDSize:CGFloat = 45
    public var borderGap:CGFloat = 10.0
    let maskViews:UIView = UIView()
    
    // 內部參數
    fileprivate var centerView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitValue()
        setupHUD()
    }
}
