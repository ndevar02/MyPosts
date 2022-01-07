//
//  MyPostResponse.swift
//  myPosts
//
//  Created by Nithya Devarajan on 05/01/22.
//

import Foundation

struct MyPostResponse : Codable, Equatable{
   
    var id : Int?
    var title : String?
    var body : String?
    var userId : Int?
    
    static func ==(lhs: MyPostResponse, rhs: MyPostResponse) -> Bool {
        return lhs.id == rhs.id
    }

   
}
