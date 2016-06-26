//
//  ViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 11/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    var userList:Array<User> = Array<User>()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight,left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0,y: -kTableHeaderHeight)
        updateHeaderView()
        updateTableView()
    }

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = userList[indexPath.row].name as String
        cell.detailTextLabel?.text = userList[indexPath.row].email as String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0,y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if(tableView.contentOffset.y < -kTableHeaderHeight){
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    
    func updateTableView(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let prefsEmail = prefs.stringForKey("email")
        let prefsToken = prefs.stringForKey("token")
        let url = "https://lifesaver-paulshantanu.rhcloud.com/auth/nearbyusers"
        let dataTosend = NSMutableDictionary()
        
        dataTosend.setValue(prefsEmail, forKey: "email")
        dataTosend.setValue(prefsToken, forKey: "token")
        
        if(prefsEmail != nil && prefsToken != nil){
            APIConnectionController(url:url, requestMethod: "GET", dataToSend:dataTosend).getDataFromAPI({(response:APIResponseObject)->Void in
            
                if response.responseCode == 200{
                    var jsonData:Array<NSDictionary>?
                    do{
                        jsonData = try NSJSONSerialization.JSONObjectWithData(response.responseData, options: NSJSONReadingOptions.MutableContainers) as? Array
                    }catch let error as NSError{
                    
                        NSLog("\(error)")
                    }
                    
                    for user in jsonData! {
                        self.userList.append(User(name: user["name"] as! NSString, address:"", bloodType:user["bloodGroup"] as! NSString, distance:""))
                    }
                    
                    for item in self.userList{
                        NSLog("\(item.name)  \(item.email) \(item.bloodType)")
                    }
                    
                    self.tableView.reloadData()
                }
                else if response.responseCode == 401{
                    //TODO Segue to login screen
                }
                else {
                    //TODO show error
                }
            
            })
        }
        else{
            //TODO Segue back to login
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }

}

