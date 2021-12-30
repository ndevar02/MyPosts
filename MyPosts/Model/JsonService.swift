//
//  Service.swift
//  myPosts
//
//  Created by Nithya Devarajan on 27/12/21.


import Foundation


struct JsonService {
    let jsonUrl = "https://jsonplaceholder.typicode.com/posts"
    //var delegate: JsonDataDelegate?
    
    private func parsejson(jsonData : Data) -> [JsonData]? {
        
        let decoder = JSONDecoder()
        do{
            
            let value = try decoder.decode([JsonData].self, from: jsonData)
            
            return value
        }
        catch{
            ExceptionHandler.printError(message: error.localizedDescription)
            return nil
        }
        
    }
    
    
    public func getJsonData(completion:@escaping (Result<[JsonData],Error>)->()){
        
        guard let nsURL = URL(string:jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "GET"
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if error == nil {
                
                if let safeData = data {
                    let result = parsejson(jsonData: safeData)
                    if result != nil {
                        completion(.success(result!))
                    }
                }
            }
            else
            {
                completion(.failure(error!))
            }
        }
        
        task.resume()
    }
    
    
    
    
    public func deleteJsonData(id: Int, completion:@escaping(Error?)->()){
        
        guard let nsURL = URL(string:jsonUrl+"/\(id)") else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "DELETE"
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            
            completion(error)
            
        }
        task.resume()
    }
    
    
    
    
    public func createJsonData(title : String, description : String , completion:@escaping(Error?)->()){
        
        guard let nsURL = URL(string:jsonUrl) else {return}
        let uploadDataModel = JsonData(id: 0, title: title, body: description,userId: 1)
       
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "POST"
        
        urlRequest.httpBody = jsonData
     
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
           
            completion(error)
            
        }
        task.resume()
    }
    
    
    
    public func updateJsonData(id: Int, title : String, description : String , completion:@escaping(Error?)->()){
        
        guard let nsURL = URL(string:jsonUrl+"/\(id)") else {return}
        let uploadDataModel = JsonData(id: id, title: title, body: description,userId: id)
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "PUT"
        
        urlRequest.httpBody = jsonData
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            completion(error)
            
        }
        task.resume()
    }
    
}
