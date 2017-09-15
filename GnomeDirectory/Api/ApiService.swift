//
//  ApiService.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import Foundation

enum requestMethod:String {
    case get = "GET"
}

class ApiService {
    
    private static var shareInstance:ApiService = {
        let instance = ApiService()
        return instance
    }()
    
    private init(){}
    
    class func shared()->ApiService{
        return shareInstance
    }
    
    func fetchGnomes(completion:@escaping (_ response:[Gnome]) -> Void, error:((AnyObject?)->Void)?){
        let url = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
        
        doRequest(url: url, method: .get, resultHandler: { response in
        
            if let unwrappedResponse = response?["Brastlewark"] as? [AnyObject] {
                completion(unwrappedResponse.map { Gnome(dictionary: $0 as! [String:AnyObject]) })
            } else {
                if let unwrappedErrorHandler = error {
                    unwrappedErrorHandler("Response is invalid" as AnyObject)
                }
            }
            
        }, errorHandler: error)
        
    }
    
    private func doRequest(url:String,
                   method:requestMethod,
                   resultHandler:@escaping (_ response:AnyObject?) -> Void,
                   errorHandler:((AnyObject?)->Void)?){
    
        guard let urlAux = URL(string: url) else {
            if let unwrappedErrorHandler = errorHandler {
                unwrappedErrorHandler("invalid URL" as AnyObject?)
            }
            return
        }
        let session = URLSession.shared
        
        DispatchQueue.global(qos: .background).async {
        
            let task = session.dataTask(with: urlAux, completionHandler: { (data,_,error) in
                
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
                    if error != nil {
                        if let unwrappedErrorHandler = errorHandler {
                            var descriptionError = "Unknow error"
                            if let aux = error {
                                descriptionError = aux.localizedDescription
                            }
                            unwrappedErrorHandler("Error doing request: "+descriptionError as AnyObject)
                        }
                        return
                    }
                    
                    do {
                    
                        if let unwrappedData = data {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData)
                            
                            if let dictionary = json as? [String:AnyObject] {
                                resultHandler(dictionary as AnyObject)
                                return
                            } else if let array = json as? [AnyObject] {
                                resultHandler(array as AnyObject)
                                return
                            } else {
                                resultHandler(nil)
                                return
                            }
                        } else {
                            if let unwrappedErrorHandler = errorHandler {
                                unwrappedErrorHandler("Data is invalid" as AnyObject)
                            }
                        }
                        
                    
                    } catch let err {
                        if let unwrappedErrorHandler = errorHandler {
                            unwrappedErrorHandler("Error doing request: "+err.localizedDescription as AnyObject)
                        }
                    }
                })
                
                
            })
            task.resume()
        }
        
    }

}
