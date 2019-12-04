//
//  Double.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 30/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

infix operator ~

extension Double {

    static let eps: Double = pow(10, -6)
    
    static func ~ (lhs: Double, rhs: Double) -> Bool {
        return abs(lhs - rhs) < Double.eps
    }
}
