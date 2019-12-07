//
//  FourierTransformService.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 29/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import AVFoundation

class SpectralAudioFileAnalyzer {

    let cutLevel = 0.8  // Minimum level to account for average

    var transformer: Transformative

    init(transformer: Transformative) {
        self.transformer = transformer
    }

    func spectrum(file: AVAudioFile, duration: Double, maxFrequency: Double = 1000.0) -> Spectrum? {
        guard let data = fileToData(file: file, duration: duration) else { return nil }
        guard let spectrumData = transformer.transform(data) else { return nil }
        let length = getLengthPowerTwo(file: file, duration: duration)
        var spectrum = spectrumData.enumerated().map({ arg -> Point2D in
            let (i, amplitude) = arg
            return Point2D(file.fileFormat.sampleRate / Double(length) * Double(i), amplitude)
        })
        let max = spectrumData.max() ?? spectrum[0].y
        let frequences = spectrum.filter({ $0.y / max > cutLevel }).map({ $0.x })

        let frequency = frequences.reduce(0, { $0 + $1 }) / Double(frequences.count)
        spectrum = spectrum.filter({ $0.x < maxFrequency })

        return Spectrum(spectrum: spectrum, frequency: frequency)
    }

    private func fileToData(file: AVAudioFile, duration: Double) -> [Float]? {
        let sampleRate = file.fileFormat.sampleRate
        let length = getLengthPowerTwo(file: file, duration: duration)
        guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false) else { return nil }
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(length)) else { return nil }
        do {
            try file.read(into: buffer)
        } catch {
            print("Could not read from AudioFile to AudioBuffer. Reason: \(error)")
            return nil
        }
        guard let floatChannelData = buffer.floatChannelData else { return nil }
        return Array(UnsafeBufferPointer(start: floatChannelData[0], count: length))
    }

    private func getLengthPowerTwo(file: AVAudioFile, duration: Double) -> Int {
        return 2 ^ Int(log2(file.fileFormat.sampleRate * duration))
    }
}
