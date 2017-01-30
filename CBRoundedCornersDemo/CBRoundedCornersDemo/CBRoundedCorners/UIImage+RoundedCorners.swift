//
//  UIImage+RoundedCorners.swift
//  testRuntime
//
//  Created by Bin on 17/1/20.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

struct Radius {
    var topLeftRadius : CGFloat?
    var topRightRadius : CGFloat?
    var bottomLeftRadius : CGFloat?
    var bottomRightRadius : CGFloat?
    
    init(topLeftRadius : CGFloat, topRightRadius : CGFloat, bottomLeftRadius : CGFloat, bottomRightRadius : CGFloat) {
        self.topLeftRadius = topLeftRadius
        self.topRightRadius = topRightRadius
        self.bottomLeftRadius = bottomLeftRadius
        self.bottomRightRadius = bottomRightRadius
    }
}

extension UIImage {
    
    //MARK: - Public Method
    class func drawImage(size : CGSize, borderWidth : CGFloat, borderColor : UIColor, radius : inout Radius, backgroundColor : UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let halfBorderWidth : CGFloat = borderWidth / 2
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(borderWidth)
        context?.setStrokeColor(borderColor.cgColor)
        context?.setFillColor(backgroundColor.cgColor)
        
        let height : CGFloat = size.height
        let width : CGFloat = size.width
        
        radius = UIImage.self.transFormationRadius(radius: &radius, size: size, borderWidth: borderWidth)
        
        var startPointY : CGFloat?
        
        if radius.topRightRadius! >= height - borderWidth {
            startPointY = height
        } else if (radius.topRightRadius! > 0) {
            startPointY = halfBorderWidth + radius.topRightRadius!
        } else {
            startPointY = 0
        }
        
        // 开始坐标右边开始
        context?.move(to: CGPoint.init(x: width - halfBorderWidth, y: startPointY!))
        // 右下角角度
        context?.addArc(tangent1End: CGPoint.init(x: width - halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint.init(x: width / 2, y: height - halfBorderWidth) , radius: radius.bottomRightRadius!)
        // 左下角角度
        context?.addArc(tangent1End: CGPoint.init(x: halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint.init(x: halfBorderWidth, y: height / 2), radius: radius.bottomLeftRadius!)
        // 左上角角度
        context?.addArc(tangent1End: CGPoint.init(x: halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint.init(x: width / 2, y: halfBorderWidth), radius: radius.topLeftRadius!)
        // 右上角角度
        context?.addArc(tangent1End: CGPoint.init(x: width - halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint.init(x: width - halfBorderWidth, y: height / 2), radius: radius.topRightRadius!)
        
        context?.drawPath(using: .fillStroke)
        
        let outImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outImage!
    }
    
    //MARK: - Private Methods
    private class func transFormationRadius( radius : inout Radius, size : CGSize, borderWidth : CGFloat) -> Radius {
        
        radius.topLeftRadius = minimum(a: size.width - borderWidth, b: size.height - borderWidth, c: radius.topLeftRadius! - borderWidth / 2)
    
        radius.topRightRadius = minimum(a: size.width - borderWidth - radius.topLeftRadius!, b: size.height - borderWidth, c: radius.topRightRadius! - borderWidth / 2)
        
        radius.bottomLeftRadius = minimum(a: size.width - borderWidth, b: size.height - borderWidth - radius.topLeftRadius!, c: radius.bottomLeftRadius! - borderWidth / 2)
        
        radius.bottomRightRadius = minimum(a: size.width - borderWidth - radius.bottomLeftRadius!, b: size.height - borderWidth - radius.topRightRadius!, c: radius.bottomRightRadius! - borderWidth / 2)
    
        return radius
    }
    
}

@inline(__always) func minimum(a : CGFloat, b : CGFloat, c : CGFloat) -> CGFloat {
    let minimum = min(min(a, b), c)
    return max(minimum, 0)
    
}


