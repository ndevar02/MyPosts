//
//  Service.swift
//  myPosts
//
//  Created by Nithya Devarajan on 27/12/21.
//

import Foundation


protocol JsonDataDelegate{
    func updateData(jsonDataArray : [JsonData])
}

struct JsonService {
    let jsonUrl = "https://jsonplaceholder.typicode.com/posts"
    var delegate: JsonDataDelegate?
    
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
    
    
    public func getJsonData(completion:@escaping(Error?)->()){
        
        guard let nsURL = URL(string:jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "GET"
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if error == nil {
                
                if let safeData = data {
                    let result = parsejson(jsonData: safeData)
                    self.delegate?.updateData(jsonDataArray: result!)
                }
                
            }
            else
            {
                ExceptionHandler.printError(message: error!.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    
    
    
    public func deleteJsonData(id: Int, completion:@escaping(URLResponse?)->()){
        
        guard let nsURL = URL(string:jsonUrl+"/\(id)") else {return}
        
        var urlRequest = URLRequest(url: nsURL)
        urlRequest.httpMethod = "DELETE"
        
        // Add other verbs here
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) in
            if error != nil {
                ExceptionHandler.printError(message: error!.localizedDescription)
            }
            
        }
        task.resume()
    }
    
}
