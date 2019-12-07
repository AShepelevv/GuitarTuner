//
//  File.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 29/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

struct Point2D {
    var x: Double
    var y: Double

    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
}

struct Spectrum {
    var spectrum: [Point2D]
    var frequency: Double
}
