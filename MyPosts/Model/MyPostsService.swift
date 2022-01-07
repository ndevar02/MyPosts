//
//  Service.swift
//  myPosts
//
//  Created by Nithya Devarajan on 27/12/21.


import Foundation



class MyPostServiceClass {
    
    private var urlString : String
    private var urlsession : URLSession
    
    init(urlString : String = "https://jsonplaceholder.typicode.com/posts", urlSession : URLSession = .shared){
        self.urlString = urlString
        self.urlsession = urlSession
    }
    
    public func createMyPost(title : String, description : String , completion:@escaping(MyPostResponse?,Error?)-> Void) {
        
        guard let nsURL = URL(string:urlString) else {
            //todo
            return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = convertMyPostToData(id: 0, title: title, description: description)
        
        let task =  urlsession.dataTask(with: urlRequest as URLRequest) {
            (data,response,error) in
            if let safeData = data {
             let myResponse = self.convertDataToMyPost(data: safeData) 
                completion(myResponse,nil)
            }
            else
            {
                completion(nil,error)
            }
            
        }
        
        task.resume()
    }
   
    
    //http get
    public func getMyPosts(completion:@escaping ([MyPostResponse]?,Error?)->()){
        
        guard let nsURL = URL(string:urlString) else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "GET"
        
        let task = urlsession.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in

                if let safeData = data {
                   
                    let result = self.convertToMyPostArray(myPostData: safeData)
                    if result != nil {
                        completion(result,error)
                    }
                }
                else
                {
                    completion(nil,error)
                }

        }
        
        task.resume()
    }
    
   
   
    
    
    //http delete
    public func deleteMyPosts(id: Int, completion:@escaping(MyPostResponse?,Error?)->()){
        
        guard let nsURL = URL(string:urlString+"/\(id)") else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "DELETE"
        
        // Add other verbs here
        let task = urlsession.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if let safeData = data {
               
               completion(nil,nil)
            }
            else
            {
                completion(nil,error)
            }
            
           
            
        }
        task.resume()
    }
    
    //http put
    public func updateMyPost(id: Int, title : String, description : String , completion:@escaping(MyPostResponse?,Error?)->()){
        
        guard let nsURL = URL(string:urlString+"/\(id)") else {return}
        
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "PUT"
        
        urlRequest.httpBody = convertMyPostToData(id: id, title:title, description: description)
        
        // Add other verbs here
        let task = urlsession.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if let safeData = data {
            let myResponse = self.convertDataToMyPost(data: safeData)
                completion(myResponse,nil)
            }
            else{
                completion(nil,error)
            }
            
        }
        task.resume()
    }
    
    public func convertMyPostToData(id : Int, title : String, description : String) -> Data?{
        
        let uploadDataModel = MyPostResponse(id: id, title: title, body: description,userId: 1)
        // Convert model to JSON data
        do {
            let jsonData = try JSONEncoder().encode(uploadDataModel)
            return jsonData
        }
        catch{
            print("Error: convertMyPostToJson")
            return nil
        }
       
     
       
        
    }
    
    
    public func convertDataToMyPost(data : Data) -> MyPostResponse?{
        
        do{
            // Convert json to model
            let myResponse = try JSONDecoder().decode(MyPostResponse.self, from: data)
            return myResponse
            
        }
        catch{
            print(error)
            print("error in convertjsontomypost")
            return nil
        }
        
        
    }
    public func convertToMyPostArray(myPostData : Data) -> [MyPostResponse]? {
        
        let decoder = JSONDecoder()
        do{
            let value = try decoder.decode([MyPostResponse].self, from: myPostData)
            return value
        }
        catch{
            ExceptionHandler.printError(message: error.localizedDescription)
            return nil
        }
        
    }
}
