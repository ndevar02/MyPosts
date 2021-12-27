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
    let getJsonData = "https://jsonplaceholder.typicode.com/posts"
    var delegate: JsonDataDelegate?
   
    public func performService()  {
        
        if let url = URL(string: getJsonData){
            let session = URLSession(configuration:.default)
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    
                    if let safeData = data {
                    let result = parsejson(jsonData: safeData)
                        self.delegate?.updateData(jsonDataArray: result!)
                    }
                   
                }
                
            }
            task.resume()
        }
    
        
    }
    private func parsejson(jsonData : Data) -> [JsonData]? {
        
        let decoder = JSONDecoder()
        do{
           
            let value = try decoder.decode([JsonData].self, from: jsonData)
            
            return value
        }
        catch{
            print(error)
           return nil
        }
        
    }
    
    
}
