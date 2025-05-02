//
//  CustomWindow.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/3/29.
//  Copyright © 2017年 AllenShiu. All rights reserved.
//

import UIKit

protocol CustomWindowProtocol {
    func shouldHandleTouchAtPoint (point:CGPoint)->Bool
}

//MARK: method to override
extension CustomWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
         return self.eventDelegate!.shouldHandleTouchAtPoint(point: point)
    }
}

//MARK: life cycle
class CustomWindow: UIWindow {
     var eventDelegate:CustomWindowProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear;
        self.windowLevel = UIWindow.Level.alert - 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
