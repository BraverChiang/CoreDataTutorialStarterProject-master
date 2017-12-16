//
//  APIService.swift
//  CoreDataTutorial
//
//  Created by Braver Chiang on 12/16/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

//110: 声明返回结果的枚举类型
enum Result <T>{
    case Success(T)
    case Error(String)
}

//111: 声明Service类
class APIService: NSObject {
    
    //112: url
    let query = "dogs"
    lazy var endPoint: String = { return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#" }()
    
    //113: 声明requestData()
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        guard let url = URL(string: endPoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show")) }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    guard let itemsJsonArray = json["items"] as? [[String: AnyObject]] else {  return  }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
//                print(error)
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    
}
