//
//  ViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 11/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight,left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0,y: -kTableHeaderHeight)
        updateHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0,y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if(tableView.contentOffset.y < -kTableHeaderHeight){
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }

}

