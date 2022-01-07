//
//  myPostsTests.swift
//  myPostsTests
//
//  Created by Nithya Devarajan on 05/01/22.
//

import XCTest
@testable import myPosts

class MyPostsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        MockUrlProtocol.stubResponseData = nil
        MockUrlProtocol.stubErrorData = nil
    }

    
    
    
    func testMyPostService_whenGetMyPost_shouldReturnArrayCountGreaterThan0(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        let jsonString = "[{\"id\":1,\"title\":\"title\",\"body\":\"description\",\"userId\":1},{\"id\":2,\"title\":\"mytitle\",\"body\":\"mydescription\",\"userId\":1}]"
        MockUrlProtocol.stubResponseData = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        sut.getMyPosts { myResponse, error in
            XCTAssertGreaterThan(myResponse!.count, 0)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_whenGetResponseIsNil_shouldThrowError(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        let jsonString = "[]"
        MockUrlProtocol.stubResponseData = jsonString.data(using:.utf8)
        let error : Error? = MyPostError.getError
        MockUrlProtocol.stubErrorData = error
        
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        sut.getMyPosts { myResponse, error in
            XCTAssertNotNil(error)
            XCTAssertNil(myResponse)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testMyPostService_whenCreatedNewMyPost_ReturnsIdCreated(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
       var myResponse = MyPostResponse(id: 101, title: "title", body: "description", userId: 1)
        let jsonString = "{\"id\":101,\"title\":\"title\",\"body\":\"description\",\"userId\":1}"
        MockUrlProtocol.stubResponseData = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        
        sut.createMyPost(title: "mytitle", description: "mydescription"){ myPostResponse, error in
            XCTAssertEqual(myPostResponse?.id, 101)
            XCTAssertEqual(myPostResponse, myResponse)
            
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_whenCreatedNewMyPost_ReturnsResponseAsNilWhenNotSuccess(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        MockUrlProtocol.stubResponseData = nil
        let error : Error? = MyPostError.createError
        MockUrlProtocol.stubErrorData = error

        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
    
        let expectation = self.expectation(description: "web service response expectation")
        
        
        sut.createMyPost(title: "mytitle", description: "mydescription"){ myPostResponse, error in
           
            XCTAssertNil(myPostResponse)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_whenDeleted_shouldThrowNoError(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        let error :Error? = nil
        MockUrlProtocol.stubErrorData = error
      
        
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        sut.deleteMyPosts(id: 1) { myPostResponse, error in
           
            print(error)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testMyPostService_whenDeletedWithInvalidId_shouldThrowError(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
    
        let error :Error? = MyPostError.deleteError
        MockUrlProtocol.stubErrorData = error

        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        sut.deleteMyPosts(id: 0) { myPostResponse, error in
           XCTAssertNotNil(error)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_whenEdited_shouldReturnTheSameAsResponseObject(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        let jsonString = "{\"id\":1,\"title\":\"title\",\"body\":\"description\",\"userId\":1}"
        MockUrlProtocol.stubResponseData = jsonString.data(using:.utf8)
        
       
        let myResponse = MyPostResponse(id: 1, title: "title", body: "description", userId: 1)
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        
        sut.updateMyPost(id: 1, title: "title", description: "description") { myPostResponse,error in
            XCTAssertEqual( myPostResponse?.id,1)
            XCTAssertEqual(myResponse, myPostResponse!)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_whenEdited_shouldThrowErrorWhenResponseIsNil(){
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlsession = URLSession(configuration: config)
        MockUrlProtocol.stubResponseData = nil
        
        let error :Error? = MyPostError.editError
        MockUrlProtocol.stubErrorData = error
        
        let sut = MyPostServiceClass(urlString: "https://jsonplaceholder.typicode.com/posts",urlSession: urlsession)
        let expectation = self.expectation(description: "web service response expectation")
        
        
        sut.updateMyPost(id: 1, title: "title", description: "description") { myPostResponse,error in
            
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
    }
    
    func testMyPostService_shouldConvertMyPostToData_shouldReturnTrue(){
        
        let jsonString = "{\"id\":1,\"title\":\"myTitle\",\"body\":\"myDescription\",\"userId\":1}"
        let response = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myResponse = sut.convertMyPostToData(id: 1, title: "myTitle", description: "myDescription")
        
        XCTAssertEqual(response?.jsonSerialized(), myResponse?.jsonSerialized())
    }
    
    func testMyPostService_shouldConvertMyPostToData_shouldReturnNotEqualWhenResponseIsNotMatching(){
        
        let jsonString = "{\"id\":1,\"title\":\"myTitle\",\"body\":\"myDescription\",\"userId\":1}"
        let response = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myResponse = sut.convertMyPostToData(id: 0, title: "myTitle", description: "myDescription")
        
        XCTAssertNotEqual(response?.jsonSerialized(), myResponse?.jsonSerialized())
    }
    
    func testMyPostService_shouldConvertDataToMyPost_shouldReturnTrue(){
        
        let response = MyPostResponse(id: 0, title: "myTitles", body: "myDescription", userId: 1)
        let jsonString = "{\"id\":0,\"title\":\"myTitles\",\"body\":\"myDescriptions\",\"userId\":1}"
        let request = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myResponse = sut.convertDataToMyPost(data: request!)
        
        XCTAssertEqual(response, myResponse!)
    }
    
    func testMyPostService_shouldConvertDataToMyPost_shouldReturnNotEqualWhenResponseIsNotMatching(){
        
        let response = MyPostResponse(id: 0, title: "myTitles", body: "myDescription", userId: 1)
        let jsonString = "{\"id\":1,\"title\":\"myTitles\",\"body\":\"myDescriptions\",\"userId\":1}"
        let request = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myResponse = sut.convertDataToMyPost(data: request!)
        
        XCTAssertNotEqual(response, myResponse!)
    }
    
    func testMyPostService_shouldConvertDataToMyPostArray_shouldReturnArrayCountGreaterThan0(){
        
        
        let jsonString = "[{\"id\":0,\"title\":\"myTitles\",\"body\":\"myDescriptions\",\"userId\":1}]"
        let request = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myPostData = sut.convertToMyPostArray(myPostData: request!)
        XCTAssertGreaterThan(Int(myPostData!.count), 0)
        
    }
    
    
    func testMyPostService_shouldConvertDataToMyPostArray_shouldReturnArrayCount0(){
        
        let response = MyPostResponse(id: 0, title: "myTitles", body: "myDescription", userId: 1)
        let jsonString = "[]"
        let request = jsonString.data(using:.utf8)
        
        let sut = MyPostServiceClass()
        let myPostData = sut.convertToMyPostArray(myPostData: request!)
        
        XCTAssertEqual(Int(myPostData!.count), 0)
    }
    
    
    
}
