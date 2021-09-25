//
//  GetDataFromVK.swift
//  SecondVkClient
//
//  Created by Ilona Skerberga on 20/08/2021.
//


import Foundation

class GetDataFromVK {
    
    enum parametersAPI {
        case namesAndAvatars
        case photos
        case groups
        case searchGroups
    }
    
    //data for authorization in VK
    func loadData(_ parameters: parametersAPI) {
        
        // Default configuration
        let configuration = URLSessionConfiguration.default
        // own session
        let session =  URLSession(configuration: configuration)
        
        // URL
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.120")
        ]
        
        switch parameters { // changing constructor parameters depending on the request
        case .namesAndAvatars:
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems?.append(URLQueryItem(name: "user_id", value: String(Session.instance.userId)))
            urlConstructor.queryItems?.append(URLQueryItem(name: "fields", value: "photo_50"))
        case .photos:
            urlConstructor.path = "/method/photos.getAll"
            urlConstructor.queryItems?.append(URLQueryItem(name: "owner_id", value: String(Session.instance.userId)))
        case .groups:
            urlConstructor.path = "/method/groups.get"
            urlConstructor.queryItems?.append(URLQueryItem(name: "user_id", value: String(Session.instance.userId)))
            urlConstructor.queryItems?.append(URLQueryItem(name: "extended", value: "1"))
        case .searchGroups:
            urlConstructor.path = "/method/groups.search"
            urlConstructor.queryItems?.append(URLQueryItem(name: "q", value: "video")) // need to use search phrase
            urlConstructor.queryItems?.append(URLQueryItem(name: "type", value: "group"))
        }
        
        // task to run
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            //            print("Request to API: \(urlConstructor.url!)")
            
            // in the closure, we convert the data received from the server to json
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data) else { return }
            print("Json output from response: \(String(describing: json))")
            
            //            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print(str) // prints Cyrillic normally
            
        }
        // we start the task
        task.resume()
    }
    
}
