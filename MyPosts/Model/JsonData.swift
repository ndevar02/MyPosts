//
//  JsonPlaceHolder.swift
//  myPosts
//
//  Created by Nithya Devarajan on 27/12/21.
//

import Foundation

struct JsonData : Codable{
    let id : Int
    let title : String
    let body : String
    let userId : Int
}

struct listJsonData {
    static var lstJson = [JsonData]()
}

