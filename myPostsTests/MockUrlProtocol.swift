//
//  MockUrlProtocol.swift
//  myPostsTests
//
//  Created by Nithya Devarajan on 05/01/22.
//

import Foundation
class MockUrlProtocol : URLProtocol {
    
    static var stubResponseData : Data?
    static var stubErrorData : Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
       
        self.client?.urlProtocol(self, didLoad:MockUrlProtocol.stubResponseData ?? Data())
        if let error = MockUrlProtocol.stubErrorData {
        self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() { }
        
    
}
