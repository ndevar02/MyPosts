//
//  Error.swift
//  myPostsTests
//
//  Created by Nithya Devarajan on 07/01/22.
//

import Foundation

enum MyPostError : Error , Equatable {
    case deleteError //delete
    case getError //get
    case editError // put
    case createError//post
}
