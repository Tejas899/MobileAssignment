//
//  ApiService.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation

class ApiService : NSObject {
    private let baseUrl = ""
    
    private let sourcesURL = URL(string: "https://api.restful-api.dev/objects")!
    
    func fetchDeviceDetails(completion : @escaping ([DeviceData]) -> ()){
        // checks for offline stored data
        if !Reachability.isConnectedToNetwork(){
            guard let data = UserDefaults.standard.value( forKey: sourcesURL.absoluteString) as? Data else { return }
            let jsonDecoder = JSONDecoder()
            let empData = try! jsonDecoder.decode([DeviceData].self, from: data)
            completion(empData)
            return
        }
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion([]) // Return an empty array on network failure
                return
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode([DeviceData].self, from: data)
                completion(empData)
                
                UserDefaults.standard.set(data, forKey: self.sourcesURL.absoluteString)
            }
        }.resume()
    }
}
