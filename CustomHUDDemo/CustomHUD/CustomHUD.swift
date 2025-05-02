//
//  CustomHUD.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/3/28.
//  Copyright © 2017年 AllenShiu. All rights reserved.
//

import UIKit

fileprivate struct RuntimeKey {
    static var customWindowKey:UInt8 = 0
}

public enum HUDType {
    case HUDTypeLoading
    case HUDTypeSuccess
    case HUDTypeFail
}

//MARK: CustomWindowProtocol
extension CustomHUD : CustomWindowProtocol{
    func shouldHandleTouchAtPoint (point:CGPoint)->Bool{
        // 如果 allowUserInteraction = YES, 表示這個 window 不需要 handle touch event, 因此, 回傳是反相的
        let hudViewController:HUDViewController = CustomHUD.customWindow()!.rootViewController as! HUDViewController;
        return !hudViewController.allowUserInteraction!
    }
}

//MARK: 載資料效果
extension CustomHUD {
    public static func show() {
        showMessage(message: nil)
    }
    
    public static func showMessage(message:String?) {
        showMessage(message: message, delay: -1)
    }
    
    public static func showMessage(message:String?,delay:TimeInterval) {
        customWindow()!.rootViewController = inboxViewController(type: .HUDTypeLoading, message: message)
        customWindow()!.makeKeyAndVisible()
        hideAfterDelay(delay: delay, completion: nil)
    }
}

//MARK: 打勾效果
extension CustomHUD {
    public static func showSuccess(completion:(()->())?) {
        showSuccessMessage(message: nil, completion: completion)
    }
    
    public static func showSuccessMessage(message:String?,completion:(()->())?) {
        customWindow()!.rootViewController  = inboxViewController(type: .HUDTypeSuccess, message: message)
        customWindow()!.makeKeyAndVisible()
        hideAfterDelay(delay: 1 ,completion:completion)
    }
}

//MARK: 打叉效果
extension CustomHUD {
    public static func showFail(completion:(()->())?) {
        showFailMessage(message: nil, completion:completion)
    }
    
    public static func showFailMessage(message:String?,completion:(()->())?) {
        customWindow()!.rootViewController  = inboxViewController(type: .HUDTypeFail, message: message)
        customWindow()!.makeKeyAndVisible()
        hideAfterDelay(delay: 1 , completion:completion)
    }
}

//MARK: misc
extension CustomHUD {
    
    static func checkCurrentHUDType(_ type:HUDType) -> Bool{
        var isCreatNewHUD:Bool = false
        let hudViewController = customWindow()!.rootViewController as? HUDViewController
        if hudViewController == nil {
            isCreatNewHUD = true
        }else{
            if hudViewController?.type != type {
                isCreatNewHUD = true
            }
        }
        return isCreatNewHUD
    }
    
    static func inboxViewController(type:HUDType ,message:String?) -> HUDViewController
    {
        let hudViewController:HUDViewController = HUDViewController()
        hudViewController.backgroundColor = CustomHUD.instance.backgroundColor
        hudViewController.maskColor = CustomHUD.instance.maskColor
        hudViewController.textColor = CustomHUD.instance.textColor
        hudViewController.allowUserInteraction = CustomHUD.instance.allowUserInteraction
        hudViewController.message = self.creatMutableString(message: message)
        hudViewController.type = type
        return hudViewController
    }
    
    static func creatMutableString(message:String?) -> NSMutableAttributedString?{
        if message == nil {
            return nil
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        let mutableString = NSMutableAttributedString(
            string: message!,
            attributes:attributes)
        return mutableString
    }
}

// MARK: 隱藏 hud
extension CustomHUD {
    public static func hide(completion:(()->())?) {
        self.hideAfterDelay(delay: 0.5, completion: completion)
    }
    
    public static func hideAfterDelay(delay:TimeInterval,completion:(()->())?) {
        if delay > 0 {
            let when = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: when) {
                    self.hideHUD(completion: {
                        if completion != nil {
                            completion!()
                        }
                    })
                }
        }
    }
    
    public static func hideHUD(completion:(()->())?) {
        let hudViewController:HUDViewController? = customWindow()!.rootViewController as? HUDViewController
        if hudViewController != nil {
            hudViewController?.hideHUD {
                customWindow()!.isHidden = true
                setCustomWindow(customWindow: nil)
                
                let keyWindow = UIApplication.shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
                if let findKeyWindow = keyWindow {
                    findKeyWindow.makeKey()
                }
                if (completion != nil) {
                    completion!()
                }
            }
        }
    }
}

// MARK: life cycle
public class CustomHUD {
    public var textColor: UIColor?
    public var backgroundColor: UIColor?
    public var maskColor: UIColor?
    public var allowUserInteraction:Bool?

    // 共用實例
    static let instance:CustomHUD = {
        let customHUD = CustomHUD()
        customHUD.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1).withAlphaComponent(0.9)
        customHUD.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        customHUD.maskColor = UIColor.black.withAlphaComponent(0.4)
        customHUD.allowUserInteraction = false
        return customHUD
    }()
}

// MARK - runtime objects
extension CustomHUD {
    static func customWindow() -> CustomWindow? {
        if objc_getAssociatedObject(self, &RuntimeKey.customWindowKey) == nil {
            if let windowScene = UIApplication.shared
                .connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                let hudWindow = CustomWindow(frame:UIScreen.main.bounds)
                hudWindow.windowScene = windowScene
                hudWindow.frame = UIScreen.main.bounds
                hudWindow.windowLevel = .alert + 1
                hudWindow.backgroundColor = .clear
                hudWindow.eventDelegate = instance
                setCustomWindow(customWindow: hudWindow)
            }
        }
        return objc_getAssociatedObject(self, &RuntimeKey.customWindowKey) as? CustomWindow
    }
    
   static func setCustomWindow(customWindow:CustomWindow?){
        objc_setAssociatedObject(self, &RuntimeKey.customWindowKey, customWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
