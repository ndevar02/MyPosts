//
//  Service.swift
//  myPosts
//
//  Created by Nithya Devarajan on 27/12/21.


import Foundation


struct MyPostsService {
    let myPostsUrl = "https://jsonplaceholder.typicode.com/posts"
    
    private func parsejson(myPostData : Data) -> [MyPostData]? {
        
        let decoder = JSONDecoder()
        do{
            let value = try decoder.decode([MyPostData].self, from: myPostData)
            return value
        }
        catch{
            ExceptionHandler.printError(message: error.localizedDescription)
            return nil
        }
        
    }
    
    //http get
    public func getMyPosts(completion:@escaping ([MyPostData],Error?)->()){
        
        guard let nsURL = URL(string:myPostsUrl) else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if error == nil {
                
                if let safeData = data {
                    let result = parsejson(myPostData: safeData)
                    if result != nil {
                        completion(result!,error)
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
    
    
    //http delete
    public func deleteMyPosts(id: Int, completion:@escaping(Error?)->()){
        
        guard let nsURL = URL(string:myPostsUrl+"/\(id)") else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "DELETE"
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            
            completion(error)
            
        }
        task.resume()
    }
    
    
    
    //http post
    public func createMyPost(title : String, description : String , completion:@escaping(Data?)->()){
        
        guard let nsURL = URL(string:myPostsUrl) else {return}
        
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "POST"
        
       urlRequest.httpBody = convertMyPostToJson(id: 0, title:title, description: description)
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            
            guard let data = data else {return}
            
            completion(data)
            
        }
        task.resume()
    }
    
    private func convertMyPostToJson(id : Int, title : String, description : String) -> Data?{
        
        let uploadDataModel = MyPostData(id: id, title: title, body: description,userId: 1)
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return nil
        }
        return jsonData
        
    }
    
    //http put
    public func updateMyPost(id: Int, title : String, description : String , completion:@escaping(Data?)->()){
        
        guard let nsURL = URL(string:myPostsUrl+"/\(id)") else {return}
        

        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "PUT"
        
        urlRequest.httpBody = convertMyPostToJson(id: id, title:title, description: description)
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            completion(data)
            
        }
        task.resume()
    }
    
}
