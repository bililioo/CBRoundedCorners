//
//  ViewController.swift
//  CBRoundedCornersDemo
//
//  Created by Bin on 17/1/30.
//  Copyright © 2017年 cb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var isBtnCell: Bool = true
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "按钮圆角"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = barBtn
        navigationItem.leftBarButtonItem = leftBarBtn
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = self.view.bounds
    }

    //MARK: - BtnClicked Method
    @objc private func barBtnClicked() {        
        self.navigationItem.title = self.navigationItem.title == "按钮圆角" ? "图片圆角" : "按钮圆角"
        isBtnCell = isBtnCell == true ? false : true
        tableView.reloadData()
    }
    
    @objc private func rightBarBtnClicked() {
        self.navigationController?.pushViewController(PushViewController(), animated: true)
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
            var btnCell: ButtonCell? = tableView.dequeueReusableCell(withIdentifier: "btn\(indexPath)") as! ButtonCell?
            if btnCell == nil {
                btnCell = ButtonCell.init(style: .default, reuseIdentifier: "btn\(indexPath)")
            }
            return btnCell!
        } else {
            var imgViewCell: ImageViewCell? = tableView.dequeueReusableCell(withIdentifier: "imgView\(indexPath)") as! ImageViewCell?
            if imgViewCell == nil {
                imgViewCell = ImageViewCell.init(style: .default, reuseIdentifier: "imgView\(indexPath)")
            }
            return imgViewCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if isBtnCell == false {
            let cell: ImageViewCell? = tableView.cellForRow(at: indexPath) as? ImageViewCell
            cell?.imgView?.removeFromSuperview()
            cell?.imgView = nil
        }
    }
    
    //MARK: - Lazy Methods
    private lazy var tableView: UITableView = {
        var tempTableView = UITableView()
        tempTableView.dataSource = self
        tempTableView.delegate = self
        tempTableView.rowHeight = 54
        
        return tempTableView
    }()
    
    private lazy var barBtn: UIBarButtonItem = {
        var tempBtn = UIButton()
        tempBtn.setTitleColor(.black, for: .normal)
        tempBtn.setTitle("切换", for: .normal)
        tempBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        tempBtn.addTarget(self, action: #selector(barBtnClicked), for: .touchUpInside)
        var tempBarBtn = UIBarButtonItem.init(customView: tempBtn)
        return tempBarBtn
    }()
    
    private lazy var leftBarBtn: UIBarButtonItem = {
        var tempBtn = UIButton()
        tempBtn.setTitleColor(.black, for: .normal)
        tempBtn.setTitle("Push", for: .normal)
        tempBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        tempBtn.addTarget(self, action: #selector(rightBarBtnClicked), for: .touchUpInside)
        var tempBarBtn = UIBarButtonItem.init(customView: tempBtn)
        return tempBarBtn
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

