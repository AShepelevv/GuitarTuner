//
//  NetworkService.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

class ScalesNetworkService {
    let apiKey = "AIzaSyC0XRhbPofNoCRZNC_OFzufY6g2yGxULL4"
    private func link(of requestType: RequestType) -> String {
        return "https://cool-project-a6425.firebaseio.com/\(requestType).json"
    }
    let session: URLSession = {
        return URLSession.shared
    }()
    
    func get(completion: @escaping ([GuitarScale]?) -> Void) {
        var scales = [GuitarScale]()
        getScalesData(completion: { scalesDataOrNil in
            guard let scaleJSONs = scalesDataOrNil else {
                completion(nil)
                return
            }
            scales = scaleJSONs.map({ $0.toGuitarScale() })
            let queue = DispatchQueue(label: "", attributes: .concurrent)
            queue.async {
                let group = DispatchGroup()
                for (scale, scaleJSON) in zip(scales, scaleJSONs) {
                    group.enter()
                    self.getImageData(from: scaleJSON.imgLinkLight, with: { data in
                        guard let imageData = data else { return }
                        scale.imageData = imageData
                        group.leave()
                    })
                }
                group.wait()
                completion(scales)
            }
        })
    }
    
    func getScalesData(completion: @escaping ([GuitarScaleJSON]?) -> Void) {
        let url = URL(string: link(of: .scales))!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        let task = session.dataTask(with: request) { dataOrNil, _, error in
            guard let data = dataOrNil else {
                print("\(Date()) Empty data gotten")
                completion(nil)
                return
            }
            do {
                let scales = try JSONDecoder().decode([GuitarScaleJSON].self, from: data)
                completion(scales)
            } catch {
                print("Could not parse scales json. Reason: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

    func getImageData(from link: String, with completion: @escaping (Data?) -> Void) {
        let url = URL(string: link)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        let task = session.dataTask(with: request) { data, _, _ in
            if let imageData = data {
                completion(imageData)
            } else {
                print("\(Date()) No image found")
                completion(nil)
            }
        }
        task.resume()
    }
}
