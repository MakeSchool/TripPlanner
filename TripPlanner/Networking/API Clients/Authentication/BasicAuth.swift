//
//  BasicAuth.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

// Thanks to Nate Cook: http://stackoverflow.com/questions/24379601/how-to-make-an-http-request-basic-auth-in-swift

struct BasicAuth {
  static func generateBasicAuthHeader(username: String, password: String) -> String {
    let loginString = NSString(format: "%@:%@", username, password)
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    let authHeaderString = "Basic \(base64LoginString)"
    
    return authHeaderString
  }
}