//
//  GuitarScale.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

class GuitarScaleJSON: Decodable {
    var name: String = ""
    var imgLinkLight: String = ""
    var imgLinkDark: String = ""
    var notes: [String] = []
    
    func toGuitarScale() -> GuitarScale {
        let scale = GuitarScale()
        scale.name = self.name
        scale.notes = self.notes
        return scale
    }
}

class GuitarScale: Decodable {
    var name: String = ""
    var notes: [String] = []
    var imageData: Data = Data()
}
