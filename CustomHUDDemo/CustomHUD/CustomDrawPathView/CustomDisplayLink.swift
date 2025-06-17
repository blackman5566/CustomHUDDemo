//
//  CustomDisplayLink.swift
//  CustomHUD
//
//  Created by AllenShiu on 2017/5/22.
//  Copyright © 2017年 Ufispace. All rights reserved.
//

import UIKit

protocol CustomDisplayLinkDelegate: AnyObject {
    func displayWillUpdateWithDeltaTime(deltaTime:CFTimeInterval)
}

//MARK: setup
extension CustomDisplayLink {
    func setupDisplayLink() {
        //建立 displaylink
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkUpdated))
        self.displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
}

//當畫面的 frame 有變動時, 會進到這個地方
extension CustomDisplayLink {
    @objc func displayLinkUpdated() {
        //用時間戳記算出兩個 frame 的間隔時間
        let currentTime:CFTimeInterval = self.displayLink.timestamp
        var deltaTime:CFTimeInterval!
        if self.nextDeltaTimeZero == true {
            self.nextDeltaTimeZero = false
            deltaTime = 0.0
        }else{
            deltaTime = currentTime - self.previousTimestamp
        }
        self.previousTimestamp = currentTime
        
        //把這個數值用 delegate 帶回去
        self.delegate?.displayWillUpdateWithDeltaTime(deltaTime: deltaTime)
    }
    
    func removeDisplayLink(){
        //移除 displaylink
        self.displayLink.invalidate()
        self.removeNotificationCenter()
    }
}

//MARK: NotificationCenter
extension CustomDisplayLink {
    func setupNotificationCenter() {
        //監聽兩個 notification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func removeNotificationCenter(){
        //移除掉監聽
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActiveNotification() {
        //如果 app 要回來前景了, displaylink 則啟動
        self.displayLink.isPaused = false
        self.nextDeltaTimeZero = true
    }
    
    @objc func applicationWillResignActiveNotification() {
        //反之則暫停
        self.displayLink.isPaused = true
        self.nextDeltaTimeZero = true
    }
}

//MARK: life cycle
class CustomDisplayLink: NSObject {
    weak var delegate: CustomDisplayLinkDelegate?
    var displayLink: CADisplayLink!
    var nextDeltaTimeZero:Bool = true
    var previousTimestamp:CFTimeInterval = 0
    
    override init() {
        super.init()
        self.setupDisplayLink()
    }
}
