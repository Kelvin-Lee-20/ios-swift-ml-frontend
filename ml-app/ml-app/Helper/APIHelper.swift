//
//  APIHelper.swift
//  ml-app
//
//  Created by Kelvin on 30/7/2025.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIHelper: NSObject {
    
    static var SERVER_API:String = "http://127.0.0.1:5000/"
    
    class func sentimentAnalysis(withText text:String, completion:@escaping ((Message)->()), fail:@escaping (()->())) {
        
        let parameters: [String: String] = [
            "text": text
        ]
        
        AF.request("\(SERVER_API)api/sa",
                   method: .get,
                   parameters: parameters)
          .response { response in
              switch response.result {
              case .success(let data):
                  if let data = data {
                      let json = JSON(data)
                      let label =  json["label"].string!
                      let score =  json["score"].double!
                      completion(Message(text: "\(label) \(score.trimmedToTwoDecimalPlaces())", isFromServer: true))
                  }
              case .failure(let error):
                  print("error - \(error.localizedDescription)")
              }
        }
    }
    
}
