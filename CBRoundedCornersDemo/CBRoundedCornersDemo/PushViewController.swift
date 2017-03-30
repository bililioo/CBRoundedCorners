//
//  PushViewController.swift
//  CBRoundedCornersDemo
//
//  Created by Bin on 2017/3/30.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    deinit {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        imageView.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        imageView.image = #imageLiteral(resourceName: "head")
        view.addSubview(imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var imageView: RoundedCornersImageView = {
        var imageview = RoundedCornersImageView()
        imageview.cornerRadiusRoundingRect()
        return imageview
    }()

    
}
