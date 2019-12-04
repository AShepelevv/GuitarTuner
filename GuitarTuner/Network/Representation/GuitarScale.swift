//
//  GuitarScale.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

class GuitarScaleDTO: Decodable {
    var name: String = ""
    var imgLinkLight: String = ""
    var imgLinkDark: String = ""
    var notes: [String] = []
}

class GuitarScale: Decodable {
    var name: String = ""
    var notes: [String] = []
    var imageData: Data = Data()
}
