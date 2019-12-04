//
//  Int.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 29/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

extension Int {
    static func ^ (lhs: Int, rhs: Int) -> Int {
        var result = 1
        for _ in 1...rhs {
            result *= lhs
        }
        return result
    }
}
