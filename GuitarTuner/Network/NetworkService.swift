//
//  Protocols.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 05/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

protocol NetworkService {
    associatedtype Object
    var session: URLSession { get }
    func get(completion: @escaping (Object?) -> Void)
}
