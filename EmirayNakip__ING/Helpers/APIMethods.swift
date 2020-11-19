//
//  APIMethods.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 16.11.2020.
//

import Foundation
import UIKit

//let baseURL : String = "https://api.themoviedb.org/3/movie/popular?language=en-US"
let baseURL : String = "https://api.themoviedb.org/3"

let apiKey : String = "fd2b04342048fa2d5f728561866ad52a"

class APIMethods {
    
    func fetchData( httpMethod: String,
                    page: String,
                    url: String,
                    endPoint: String,
                    complete: @escaping ( _ success: Bool, _ movies: Data, _ error: Error? )->() ) {
        
        
       // var urlStr : String = baseURL+url+"&api_key="+apiKey+"&page="+page
        
        var urlStr : String = baseURL+url+"?api_key="+apiKey+endPoint+"&page="+page
        
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print("URL => "+urlStr)
        
        let parameters = ["": ""]
        
        let url = URL(string: urlStr)!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if httpMethod != "GET" {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                complete(false, Data.init(), error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                complete(false, Data.init(), error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    complete(true, data, error)
                    
                }
            } catch let error {
                print(error.localizedDescription)
                complete(false, Data.init(), error)
            }
        })
        task.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from endpoint: String, imageview: UIImageView) {
        
        if endpoint == "" {
            imageview.image = UIImage(named: "Person")
            return
        }
        
        let urlStr : String = "https://image.tmdb.org/t/p/w220_and_h330_face/"+endpoint
        let url = URL(string: urlStr)!
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                imageview.image = UIImage(data: data)
            }
        }
    }
 
}


