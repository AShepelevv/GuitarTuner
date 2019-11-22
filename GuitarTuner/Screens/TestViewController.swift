//
//  TestViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 18/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Accelerate

enum Mode {
    case recording
    case playing
    case none
}

class TestViewController: UIViewController {

    var recorder : AVAudioRecorder!
    var player : AVAudioPlayer!
    var audioSession : AVAudioSession!
    
    let fileName = "audioFile.m4a"
    
    var mode : Mode = .none
    
    var recordButton : UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 100)
//        button.center = CGPoint(x: 200, y: 200)
        button.backgroundColor = .white
        button.setTitleColor(.purple, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.setTitle("Record", for: .normal)
        button.addTarget(self, action: #selector(record), for: .touchUpInside)
        return button
    }()
    
    var playButton : UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 100)
//        button.center = CGPoint(x: 200, y: 200)
        button.backgroundColor = .white
        button.setTitleColor(.purple, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        return button
    }()
    
    var label : UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 200, height: 100)
        label.center = CGPoint(x: 100, y: 400)
        label.textColor = .black
        label.text = "Пусто"
        return label
    }()
    
    var buttonsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        stackView.frame.size = CGSize(width: 208, height: 100)
        stackView.center = CGPoint(x: 200, y: 200)
        return stackView
    }()
    
    var graph : SpectrumView = {
        let view = SpectrumView()
        view.backgroundColor = .systemPurple
        view.frame.size = CGSize(width: 300, height: 200)
        view.center = CGPoint(x: 200, y: 500)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        setupAudioSession()
        buttonsStackView.addArrangedSubview(recordButton)
        buttonsStackView.addArrangedSubview(playButton)
        view.addSubview(buttonsStackView)
        view.addSubview(graph)
//        view.addSubview(label)
    }
    
    @objc
    private func record() {
        setupRecorder()
        switch mode {
        case .none:
            recorder.record()
            mode = .recording
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
        case .recording:
            recorder.stop()
            mode = .none
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            recorder = nil
            printAudio()
        case .playing:
            return
        }
    }
    
    @objc
    private func play() {
        setupPlayer()
        switch mode {
        case .none:
            player.play()
            mode = .playing
            playButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = false
        case .playing:
            player.stop()
            mode = .none
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = true
        case .recording:
            return
        }
    }
    
    private func printAudio() {
        let n = AVAudioFrameCount(32768)
        let halfN = Int(n / 2)
        
        let file = try! AVAudioFile(forReading: getFileURL())
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)
        let buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: n)
        try! file.read(into: buffer!)
        let floatArray = Array(UnsafeBufferPointer(start: buffer!.floatChannelData![0], count:Int(buffer!.frameLength)))
        
        var inputRe : [Float] = [Float](repeating: 0, count: halfN)
        var inputIm : [Float] = [Float](repeating: 0, count: halfN)
        let input = DSPSplitComplex(fromInputArray: floatArray, realParts: &inputRe , imaginaryParts: &inputIm)
        
        var outputRe = [Float](repeating: 0, count: halfN)
        var outputIm = [Float](repeating: 0, count: halfN)
        var output = DSPSplitComplex(realp: &outputRe , imagp: &outputIm)

        let log2n = vDSP_Length(log2(Float(n)))
        
        let fourierTransformer = vDSP.FFT(log2n: log2n, radix: .radix2, ofType: DSPSplitComplex.self)
        fourierTransformer?.forward(input: input, output: &output)

        let outputAbs = outputRe.enumerated().map({ (arg) -> Float in
            let (i, re) = arg
            let im = outputIm[i]
            return sqrt(re * re + im * im)
        })
        
//        print("im = \(outputIm)")
//        print("abss = \(outputAbs)")
        
        let max = outputAbs.max()!
        let values = outputAbs.enumerated().filter({ $0.element > 0.7 * max }).map({ $0.offset })
        let averageSample = values.reduce(0.0, { $0 + Double($1) }) / Double(values.count)
        let frequency = averageSample * 44100.0 / 32768.0
        print("\(averageSample) \(frequency)")
        
        graph.graphPoints = Array(outputAbs.prefix(upTo: 3000).map({ $0 }))
        graph.setNeedsDisplay()
    }
    
    
    private func setupAudioSession () {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true)
//            audioSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
////                        self.loadRecordingUI()
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
        } catch {
            print(error)
        }
    }
    
    private func setupRecorder() {
        let recordingSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100.0
        ] as [String : Any]
        
        do {
            recorder = try AVAudioRecorder(url: getFileURL() , settings: recordingSettings)
            recorder.delegate = self
        } catch {
            print(error)
        }
    }
    
    private func setupPlayer() {
        do {
            player = try AVAudioPlayer(contentsOf: getFileURL())
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
//        return Bundle.main.url(forResource: "A", withExtension: "wav")!
    }
}

extension TestViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        mode = .none
        playButton.setTitle("Play", for: .normal)
        recordButton.isEnabled = true
    }
}

extension TestViewController : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
}
