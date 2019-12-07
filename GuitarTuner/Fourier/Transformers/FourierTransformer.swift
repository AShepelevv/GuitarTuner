//
//  FourierTransformer.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 29/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Accelerate

class FourierTransformer: Transformative {
    func transform(_ data: [Float]) -> [Double]? {
        let length = data.count
        let halfLength = length / 2

        var inputRe: [Float] = [Float](repeating: 0, count: halfLength)
        var inputIm: [Float] = [Float](repeating: 0, count: halfLength)
        let input = DSPSplitComplex(fromInputArray: data, realParts: &inputRe, imaginaryParts: &inputIm)

        var outputRe = [Float](repeating: 0, count: halfLength)
        var outputIm = [Float](repeating: 0, count: halfLength)
        var output = DSPSplitComplex(realp: &outputRe, imagp: &outputIm)

        let log2n = vDSP_Length(log2(Float(length)))

        guard let fourierTransformer = vDSP.FFT(log2n: log2n, radix: .radix2, ofType: DSPSplitComplex.self) else { return nil }
        fourierTransformer.forward(input: input, output: &output)

        return zip(outputRe, outputIm).map({ (re, im) in
            return Double(sqrt(im * im + re * re))
        })
    }
}
