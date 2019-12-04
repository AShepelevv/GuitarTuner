//
//  NetworkService.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

class NetworkService {
    let apiKey = "AIzaSyC0XRhbPofNoCRZNC_OFzufY6g2yGxULL4"
    private func link(of requestType: RequestType) -> String {
        return "https://cool-project-a6425.firebaseio.com/\(requestType).json"
    }
    
    func getScales(completion: @escaping ([GuitarScaleDTO]) -> Void) {
        let session = URLSession.shared
        let url = URL(string: link(of: .scales))!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        let task = session.dataTask(with: request) { data, response, error in
            do {
                let scales = try JSONDecoder().decode([GuitarScaleDTO].self, from: data!)
                completion(scales)
            } catch {
                print("Could not parse scales json. Reason: \(error)")
                completion([])
            }
        }
        task.resume()
    }
    
    func getImageData(from link: String, with completion: @escaping (Data?) -> Void) {
        let session = URLSession.shared
        let url = URL(string: link)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        let task = session.dataTask(with: request) { data, response, error in
            if let imageData = data {
                completion(imageData)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
