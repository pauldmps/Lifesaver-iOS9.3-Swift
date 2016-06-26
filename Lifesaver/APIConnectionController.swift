//
//  MainAPIConnectionController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 18/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit

class APIResponseObject{
    var responseCode:Int
    var responseData:NSData
    
    init(responseCode:Int,responseData:NSData){
        self.responseCode = responseCode
        self.responseData = responseData
    }
}

class APIConnectionController {

    private var requestMethod: String
    private var url: NSURL
    private var responseCode: Int = 200
    private var response: String?
    private var dataToSend:NSDictionary?
    
    convenience init(url:String,requestMethod:String) {
        self.init(url: url,requestMethod: requestMethod,dataToSend: nil)
    }
    
    convenience init(url:String,requestMethod:String,postData:NSDictionary) {
        self.init(url: url,requestMethod: requestMethod,dataToSend: postData)
    }
    
    init(url:String,requestMethod:String,dataToSend:NSDictionary?){
        self.requestMethod = requestMethod
        self.dataToSend = dataToSend
        self.url = NSURL(string: url)!
    }
    
    func getDataFromAPI(completion:(APIResponseObject) -> Void){
        
        if(requestMethod == "GET"){
            var temp:NSString = ""
            for(key,value) in dataToSend!{
                temp = temp.stringByAppendingString("\(key)=\(value)&")
            }
            temp = "?" + temp.substringToIndex(temp.length-1)
            temp = temp.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            url = NSURL(string: (url.absoluteString + (temp as String)))!
            // NSLog("GET: " + url.absoluteString)
        }

        
        let request = NSMutableURLRequest(URL: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = requestMethod
        var postParams:NSData?
        if(requestMethod == "POST"){
            if dataToSend != nil{
                var temp:NSString = ""
                for(key,value) in dataToSend!{
                    temp = temp.stringByAppendingString("\(key)=\(value)&")
                }
                
            temp = temp.substringToIndex(temp.length-1)
            temp = temp.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            postParams = temp.dataUsingEncoding(NSUTF8StringEncoding)
            let postLength = String(postParams?.length)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postParams
                
            //NSLog(String(data: postParams!, encoding: NSUTF8StringEncoding)!)
            }
            else{
                NSLog("Error: No data to POST")
            }
        }
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        var apiAccessTask: NSURLSessionDataTask?
        
        if apiAccessTask != nil{
            apiAccessTask?.cancel()
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        apiAccessTask = defaultSession.dataTaskWithRequest(request){
            (data, response, error) in dispatch_async(dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if error != nil{
                    NSLog((error?.localizedDescription)!)
                }
                else if let httpResponse = response as? NSHTTPURLResponse{
                    completion(APIResponseObject(responseCode: httpResponse.statusCode,responseData: data!))
                }
            }
        }
        apiAccessTask?.resume()
    }
}
