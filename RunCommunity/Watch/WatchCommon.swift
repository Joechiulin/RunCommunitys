//
//  Common.swift
//  RunCommunity
//
//  Created by PIG on 2019/3/14.
//  Copyright © 2019 PIG. All rights reserved.
//

import Foundation

//let common_url_watch = "http://192.168.1.32:8080/RunCommunity_MySQL/"
//public static String URL = "http://10.0.2.2:8080/Watch_MySQL";

func watchExecuteTask(_ url_server: URL, _ requsetParm: [String:Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // 將輸出資料列印出來除錯用
    //    print("output: \(user)")
    
    let jsonData = try! JSONSerialization.data(withJSONObject: requsetParm)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    //送出
    task.resume()
}

