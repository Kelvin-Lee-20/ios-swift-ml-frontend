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
    
    class func sentimentAnalysis(withText text:String, completion:@escaping ((MessageModel)->()), fail:@escaping (()->())) {
        
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
                      completion(MessageModel(text: "\(label) \(score.trimmedToTwoDecimalPlaces())", isFromServer: true))
                  }
              case .failure(let error):
                  print("error - \(error.localizedDescription)")
              }
        }
    }
    
    class func imageClassification(withImage image:UIImage, completion:@escaping ((MessageModel)->()), fail:@escaping (()->())) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not convert UIImage to Data")
            fail()
            return
        }
        
        let url = "\(SERVER_API)api/image-classification"
        
        AF.upload(multipartFormData: { multipartFormData in
            // Append the image data
            multipartFormData.append(imageData,
                                    withName: "file",
                                    fileName: "image.jpg",
                                    mimeType: "image/jpeg")
            
            // If you need to send additional parameters
            // multipartFormData.append("value".data(using: .utf8)!, withName: "key")
            
        }, to: url, method: .post)
        .response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let json = JSON(data)
                    let label =  json["predictions"][0]["label"].string!
                    let score =  json["predictions"][0]["probability"].double!
                    print(json)
                    
                    completion(MessageModel(text: "\(label) \(score.trimmedToTwoDecimalPlaces())", isFromServer: true))
                    
                    // Parse your MessageModel from json here
                    // let model = MessageModel(from: json)
                    // completion(model)
                }
            case .failure(let error):
                print("error - \(error.localizedDescription)")
                fail()
            }
        }
        
    }
    
}
