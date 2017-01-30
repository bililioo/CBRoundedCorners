//
//  ImageViewCell.swift
//  CBRoundedCornersDemo
//
//  Created by Bin on 17/1/30.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(imgView)
        imgView.frame = CGRect.init(x: 15, y: 7, width: 40, height: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    lazy var imgView: UIImageView = {
        
        var tempImgView = UIImageView()
        tempImgView.cb_cornerRadiusRoundingRect()
        tempImgView.image = #imageLiteral(resourceName: "head")
        
        return tempImgView
    }()
    

}
