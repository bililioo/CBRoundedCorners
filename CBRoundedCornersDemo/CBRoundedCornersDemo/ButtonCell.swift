//
//  ButtonCell.swift
//  CBRoundedCornersDemo
//
//  Created by Bin on 17/1/30.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(btn)
        btn.setBackgroundImage(bgImg, for: .normal)
        btn.frame = CGRect.init(x: 15, y: 7, width: 100, height: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lazy Methods
    private lazy var btn: UIButton = {
        var tempBtn = UIButton()
        tempBtn.setTitle("Button", for: .normal)
        tempBtn.setTitleColor(.black, for: .normal)
        return tempBtn
    }()

    private lazy var bgImg: UIImage = {
        let size = CGSize.init(width: 100, height: 40)
        var radius = Radius.init(topLeftRadius: 15, topRightRadius: 15, bottomLeftRadius: 15, bottomRightRadius: 15)
        let tempImg = UIImage.drawImage(size:size, borderWidth: 0.5, borderColor: .red, radius: &radius, backgroundColor: .white)
        return tempImg
    }()
    
}
