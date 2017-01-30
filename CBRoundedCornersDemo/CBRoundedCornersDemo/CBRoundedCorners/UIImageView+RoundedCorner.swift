//
//  UIImageView+RoundedCorner.swift
//  CBRoundedCorners
//
//  Created by Bin on 17/1/20.
//  Copyright © 2017年 CB. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private struct sharedInstance {
        static var dellocShared : NSObject?
        static var layoutShared : NSObject?
    }
    
    //MARK: - Property
    private struct propertyKey {
        static var hadAddObserverKey : Void?
        static var isRoundingKey : Void?
        static var borderColorKey : Void?
        static var borderWidthKey : Void?
        static var roundingCornersKey : Void?
        static var radiusKey : Void?
        static var processedImageKey : Void?
    }
    
    private var cb_radius : CGFloat? {
        set {
            objc_setAssociatedObject(self, &propertyKey.radiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.radiusKey) as! CGFloat?
        }
    }
    
    private var roundingCorners : UIRectCorner? {
        set {
            objc_setAssociatedObject(self, &propertyKey.roundingCornersKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.roundingCornersKey) as? UIRectCorner
        }
    }
    
    private var cb_borderWidth : CGFloat? {
        set {
            objc_setAssociatedObject(self, &propertyKey.borderWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.borderWidthKey) as! CGFloat?
        }
    }
    
    private var cb_borderColor : UIColor? {
        set {
            objc_setAssociatedObject(self, &propertyKey.borderColorKey, newValue!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.borderColorKey) as? UIColor
        }
    }
    
    private var cb_hadAddObserver : Bool? {
        set {
            objc_setAssociatedObject(self, &propertyKey.hadAddObserverKey, Bool.init(newValue!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.hadAddObserverKey) as? Bool
        }
    }
    
    private var cb_isRounding : Bool? {
        set {
            objc_setAssociatedObject(self, &propertyKey.isRoundingKey, Bool.init(newValue!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &propertyKey.isRoundingKey) as? Bool
        }
    }
    
    //MARK: - Public Methods
    /// 初始化设置圆角半径, 需要设置圆角的角
    ///
    /// - Parameters:
    ///   - cornerRadius: 半径
    ///   - rectCornerType: 需要设置圆角的角
    convenience init(CornerRadiusAdvance cornerRadius: CGFloat, CornerType rectCornerType: UIRectCorner){
        self.init()
        self.cb_cornerRadiusAdvance(cornerRadius: cornerRadius, rectcornerType: rectCornerType)
    }
    
    /// 设置边框大小, 颜色bv
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - color: 颜色
    func cb_attachBorder(width: CGFloat, color: UIColor) {
        cb_borderColor = color
        cb_borderWidth = width
    }
    
    /// 给图片设置圆角半径, 需要设置圆角的角
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - rectcornerType: 需要设置圆角的角
    func cb_cornerRadiusAdvance(cornerRadius: CGFloat, rectcornerType: UIRectCorner) {
        
        self.cb_radius = cornerRadius
        self.roundingCorners = rectcornerType
        self.cb_isRounding = false
        
        if self.cb_hadAddObserver != true {
            UIImageView.self.swizzleDealloc()
            self.addObserver(self, forKeyPath: "image", options: .new, context: nil)
            self.cb_hadAddObserver = true
        }
        
        //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
        self.layoutIfNeeded()
    }
    
    /// 调用此方法默认绘制圆形, 无边框
    func cb_cornerRadiusRoundingRect() {
        
        cb_isRounding = true
        if cb_hadAddObserver == nil {
            UIImageView.self.swizzleDealloc()
            self.addObserver(self, forKeyPath: "image", options: .new, context: nil)
            self.cb_hadAddObserver = true
        }
        
        //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
        self.layoutIfNeeded()
        
    }
    
    //MARK: - Kernel
    private func cb_cornerRadius(setImage image: UIImage, cornerRadius: CGFloat, rectCornerType: UIRectCorner) {
        
        let size : CGSize = self.bounds.size
        let scale = UIScreen.main.scale
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let currentContext = UIGraphicsGetCurrentContext()
        if currentContext == nil {
            return
        }
        
        let cornerPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: rectCornerType, cornerRadii: cornerRadii)
        cornerPath.addClip()
        
        self.layer.render(in: currentContext!)
        self.drawBorder(path: cornerPath)
        
        let processedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        if processedImage != nil {
            objc_setAssociatedObject(processedImage, &propertyKey.processedImageKey, 1, objc_AssociationPolicy(rawValue: 1)!)
        }
        self.image = processedImage
    }
    
    private func cb_cornerRadius(withImage image: UIImage, cornerRadius: CGFloat, rectCornerType: UIRectCorner, backgroundColor: UIColor) {
        
        let size: CGSize = self.bounds.size
        let scale = UIScreen.main.scale
        let cornerRadii = CGSize.init(width: cornerRadius, height: cornerRadius)
        
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        let currentContext = UIGraphicsGetCurrentContext()
        if currentContext == nil {
            return
        }
        let cornerPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: rectCornerType, cornerRadii: cornerRadii)
        let backgroundRect = UIBezierPath.init(rect: self.bounds)
        backgroundColor.setFill()
        backgroundRect.fill()
        cornerPath.addClip()
        
        self.layer.render(in: currentContext!)
        self.drawBorder(path: cornerPath)
        
        let processedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        if processedImage != nil {
            objc_setAssociatedObject(processedImage, &propertyKey.processedImageKey, 1, objc_AssociationPolicy(rawValue: 1)!)
        }
        
        self.image = processedImage
        
        
    }
    
    //MARK: - Private
    private func drawBorder(path: UIBezierPath) {
        if cb_borderWidth != 0 && cb_borderColor != nil {
            path.lineWidth = 2 * cb_borderWidth!
            cb_borderColor?.setStroke()
            path.stroke()
        }
    }
    
    @objc private func cb_dealloc() {
        if cb_hadAddObserver == true {
            self.removeObserver(self, forKeyPath: "image")
            self.cb_dealloc()
        }
    }
    
    private func validateFrame() {
        if self.frame.size.width == 0 {
            UIImageView.self.swizzleLayoutSubviews()
        }
    }
    
    private class func swizzleMethod(oneSel: Selector, antherSel: Selector) {
        
        let oneMethod: Method = class_getInstanceMethod(self, oneSel)
        let antherMethod: Method = class_getInstanceMethod(self, antherSel)
        method_exchangeImplementations(oneMethod, antherMethod)
    }
    
    private class func swizzleDealloc() {
        
        if sharedInstance.dellocShared == nil {
            self.swizzleMethod(oneSel: NSSelectorFromString("dealloc"), antherSel: #selector(cb_dealloc))
            sharedInstance.dellocShared = NSObject()
        }
        
    }
    
    private class func swizzleLayoutSubviews() {
        
        if sharedInstance.layoutShared == nil {
            self.swizzleMethod(oneSel:NSSelectorFromString("layoutSubviews"), antherSel: #selector(cb_LayoutSubviews))
            sharedInstance.layoutShared = NSObject()
        }
        
    }
    
    @objc private func cb_LayoutSubviews() {
        self.cb_LayoutSubviews()
        if cb_isRounding == true {
            
            self.cb_cornerRadius(setImage: self.image!, cornerRadius: self.frame.width / 2, rectCornerType: UIRectCorner.allCorners)
            
        } else if self.cb_radius != 0 && self.image != nil && (self.roundingCorners == .topRight
            || self.roundingCorners == .topLeft
            || self.roundingCorners == .bottomRight
            || self.roundingCorners == .bottomLeft
            || self.roundingCorners == .allCorners) {
            self.cb_cornerRadius(setImage: self.image!, cornerRadius: self.cb_radius!, rectCornerType: self.roundingCorners!)
        }
    }
    
    //MARK: - KVO for .image
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "image" {

            let index = change?.index(forKey: .newKey)
            let newImage : AnyObject = change![index!].value as AnyObject
            
            if newImage.isMember(of: NSNull.self) {
                return
            } else if objc_getAssociatedObject(newImage, &propertyKey.processedImageKey) != nil {
                return
            }
            self.validateFrame()
            
            if self.cb_isRounding == true {
                
                self.cb_cornerRadius(setImage: newImage as! UIImage, cornerRadius: self.frame.size.width / 2, rectCornerType: UIRectCorner.allCorners)
                
            } else if self.cb_radius != 0
                && self.image != nil
                && (self.roundingCorners == .topRight
                    || self.roundingCorners == .topLeft
                    || self.roundingCorners == .bottomRight
                    || self.roundingCorners == .bottomLeft
                    || self.roundingCorners == .allCorners) {
                
                self.cb_cornerRadius(setImage: newImage as! UIImage, cornerRadius: self.cb_radius!, rectCornerType: self.roundingCorners!)
                
            }
        }
    }
    
}

