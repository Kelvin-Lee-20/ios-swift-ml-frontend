//
//  MessageModel.swift
//  ml-app
//
//  Created by Kelvin on 2/8/2025.
//

import UIKit
import SwiftyJSON

class MessageModel: NSObject {
    
    var text:String
    var image:UIImage?
    var isFromServer:Bool
    
    init(text: String, image: UIImage? = nil, isFromServer: Bool) {
        self.text = text
        self.image = image
        self.isFromServer = isFromServer
        super.init()
    }
    
}
