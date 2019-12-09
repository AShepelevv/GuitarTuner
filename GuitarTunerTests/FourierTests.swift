//
//  FourierTests.swift
//  GuitarTunerTests
//
//  Created by Aleksey Shepelev on 01/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import XCTest
import GuitarTuner
import AVFoundation

class FourierTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func getSpectrum(name: String) -> Spectrum? {
        //Arrange
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: "wav")!
        var file: AVAudioFile
        do {
            file = try AVAudioFile(forReading: url)
        } catch {
            return nil
        }
        let transformer = FourierTransformer()
        let analyzer = SpectralAudioFileAnalyzer(transformer: transformer)
        
        //Act
        return analyzer.spectrum(file: file, duration: 1.5, maxFrequency: Settings.maxFrequency)
    }

    func testThatTransformGetCorrectFrequencyFromMonohromeSignalFor300Hz() {
        //Arrange
        var data: [Float] = []
        let duration = 2 //sec
        let rate = 44100 //samples per sec
        let frequency = 330.0
        for sampleNumber in 1...(duration * rate) {
            let time = Double(sampleNumber) / Double(rate)
            let value = Float(sin(frequency * 2.0 * Double.pi * Double(time)))
            data.append(value)
        }

        //Act
        let spectrumData = FourierTransformer().transform(data)!
        let max = spectrumData.max()!
        let number = spectrumData.enumerated().filter({ arg in
            let (_, value) = arg
            return value ~ max
        })[0].0

        //Assert
        XCTAssertEqual(490, number)

    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_0Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_0")

        //Assert
        XCTAssertEqual(330.0, (spectrum?.frequency)!, accuracy: 0.3)
    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_1Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_1")

        //Assert
        XCTAssertEqual(330.1, (spectrum?.frequency)!, accuracy: 0.3)
    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_2Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_2")

        //Assert
        XCTAssertEqual(330.2, (spectrum?.frequency)!, accuracy: 0.3)
    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_3Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_3")

        //Assert
        XCTAssertEqual(330.3, (spectrum?.frequency)!, accuracy: 0.3)
    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_4Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_4")

        //Assert
        XCTAssertEqual(330.4, (spectrum?.frequency)!, accuracy: 0.3)
    }

    func testThatSpectrumReturnsCorrectSpectrumWithMainFrequency330_5Hz() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "330_5")

        //Assert
        XCTAssertEqual(330.5, (spectrum?.frequency)!, accuracy: 0.3)
    }
    func testThatSpectrumGetCoorrectFrequency300HzFrom300And200() {
        //Arrange & Act
        let spectrum = getSpectrum(name: "300&200")

        //Assert
        XCTAssertEqual(300.0, (spectrum?.frequency)!, accuracy: 0.3)
    }
}
