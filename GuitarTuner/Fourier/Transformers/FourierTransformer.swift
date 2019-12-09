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
        var input: DSPSplitComplex = {
            if #available(iOS 13.0, *) {
                return DSPSplitComplex(fromInputArray: data, realParts: &inputRe, imaginaryParts: &inputIm)
            } else {
                inputRe = data.enumerated().filter({ (i, _) in i % 2 == 0}).map({ (_, value) in value })
                inputIm = data.enumerated().filter({ (i, _) in i % 2 == 1}).map({ (_, value) in value })
                return DSPSplitComplex(realp: &inputRe, imagp: &inputIm)
            }
        }()
            
        var outputRe = [Float](repeating: 0, count: halfLength)
        var outputIm = [Float](repeating: 0, count: halfLength)
        var output = DSPSplitComplex(realp: &outputRe, imagp: &outputIm)

        let log2n = vDSP_Length(log2(Float(length)))
        
        if #available(iOS 13.0, *) {
            guard let fourierTransformer = vDSP.FFT(log2n: log2n, radix: .radix2, ofType: DSPSplitComplex.self) else { return nil }
            fourierTransformer.forward(input: input, output: &output)
        } else {
            guard let setup = vDSP_create_fftsetup(log2n, 2) else { return nil }
            vDSP_fft_zrop(setup, &input, 1, &output, 1, log2n, 1)
            vDSP_destroy_fftsetup(setup)
        }
        
        return zip(outputRe, outputIm).map({ (re, im) in
            return Double(sqrt(im * im + re * re))
        })
    }
}
