//
//  ViewController.swift
//  CBRoundedCornersDemo
//
//  Created by Bin on 17/1/30.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var isBtnCell: Bool = true
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "按钮圆角"
        self.view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = barBtn
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = self.view.bounds
    }

    //MARK: - BtnClicked Method
    func barBtnClicked() {
        
        self.navigationItem.title = self.navigationItem.title == "按钮圆角" ? "图片圆角" : "按钮圆角"
        isBtnCell = isBtnCell == true ? false : true
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isBtnCell == true {
            var btnCell: ButtonCell? = tableView.dequeueReusableCell(withIdentifier: "btn") as! ButtonCell?
            if btnCell == nil {
                btnCell = ButtonCell.init(style: .default, reuseIdentifier: "btn")
            }
            return btnCell!
        } else {
            var imgViewCell: ImageViewCell? = tableView.dequeueReusableCell(withIdentifier: "imgView") as! ImageViewCell?
            if imgViewCell == nil {
                imgViewCell = ImageViewCell.init(style: .default, reuseIdentifier: "imgView")
            }
            return imgViewCell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Lazy Methods
    lazy var tableView: UITableView = {
        var tempTableView = UITableView()
        tempTableView.dataSource = self
        tempTableView.delegate = self
        tempTableView.rowHeight = 54
        
        return tempTableView
    }()
    
    
    lazy var barBtn: UIBarButtonItem = {
       
        var tempBtn = UIButton()
        tempBtn.setTitleColor(.black, for: .normal)
        tempBtn.setTitle("切换", for: .normal)
        tempBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        tempBtn.addTarget(self, action: #selector(barBtnClicked), for: .touchUpInside)
        
        var tempBarBtn = UIBarButtonItem.init(customView: tempBtn)
        
        return tempBarBtn
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

