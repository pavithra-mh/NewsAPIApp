//
//  ServiceRequestResponse.swift
//  NewsApp
//
//  Created by Mac - 1 on 04/02/21.
//


import UIKit
import SystemConfiguration

class ServiceRequestResponse: NSObject{
    
    // 1
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    // 2
    var dataTask: URLSessionDataTask?
    
    static let sharedInstance = ServiceRequestResponse()
    
    
    func requestService(_ url:String, data: [String: AnyObject], completion: @escaping ([String: AnyObject]) -> ()) {
        
        if dataTask != nil {
            dataTask!.cancel()
        }
        
        //POST parameter
        var request = URLRequest(url: URL(string: url)!)
        //        request.httpMethod = "POST"
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)            
        }catch{
            print("\(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if (error != nil) {
                print("Json error = \(error!.localizedDescription)")
                return
            } else {
                do {
                    if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                        completion(response)
                        
                    } else {
                        print("JSON Error")
                    }
                } catch let error as NSError {
                    print("Error parsing results: \(error.localizedDescription)")
                }
            }
        })
        
        task.resume()
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
