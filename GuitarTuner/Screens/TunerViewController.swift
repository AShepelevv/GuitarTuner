//
//  TestViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 18/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate

let MARGIN: CGFloat = 10

class TunerViewController: UIViewController {

    // MARK: - Properties

    var audioSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var timer: Timer!
    
    let fileName = "recording.m4a"
    
    // MARK: - UI

    let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.graphite
        label.textAlignment = .center
        label.font = UIFont(name: "Courier", size: 70)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    let gapLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.graphite
        label.textAlignment = .center
        label.font = UIFont(name: "Courier", size: 20)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.graphite
        label.textAlignment = .center
        label.font = UIFont(name: "Courier", size: 30)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    let graph: SpectrumView = {
        let view = SpectrumView()
        view.backgroundColor = .systemPurple
        return view
    }()

    let dialView: FrequencyDialView = {
        let dialView = FrequencyDialView()
        return dialView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Tuner"
        tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "tuner"), selectedImage: nil)
        tabBarItem.setTitleTextAttributes([.font: UIFont(name: "Courier", size: 10)!], for: .application)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        setupAudioSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        setupRecorder()
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        recorder.stop()
    }

    override func viewWillLayoutSubviews() {
        view.addSubview(graph)
        view.addSubview(dialView)
        view.addSubview(frequencyLabel)
        view.addSubview(noteLabel)
        view.addSubview(gapLabel)

        let safeArea = view.safeAreaLayoutGuide

        graph.translatesAutoresizingMaskIntoConstraints = false
        graph.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: MARGIN).isActive = true
        graph.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: MARGIN).isActive = true
        graph.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -MARGIN).isActive = true

        dialView.translatesAutoresizingMaskIntoConstraints = false
        dialView.topAnchor.constraint(equalTo: graph.bottomAnchor, constant: 2 * MARGIN).isActive = true
        dialView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: MARGIN).isActive = true
        dialView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -MARGIN).isActive = true
        dialView.heightAnchor.constraint(equalTo: graph.heightAnchor, multiplier: 0.5).isActive = true

        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.topAnchor.constraint(equalTo: dialView.bottomAnchor, constant: 4 *  MARGIN).isActive = true
        frequencyLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        frequencyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        frequencyLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: MARGIN).isActive = true
        noteLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true

        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        gapLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 0).isActive = true
        gapLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        gapLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        gapLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        gapLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -4 * MARGIN).isActive = true
    }
    
    // MARK: - Analyzing audio
    
    @objc
    private func update() {
        recorder.stop()
        do {
            let file = try AVAudioFile(forReading: getFileURL())
            
            guard let spectrum = analyseAudioFile(file) else { return }
            let (note, gap) = Notes().getNearestNote(for: spectrum.frequency)
            
            frequencyLabel.text = "\(String(format: "%.1f", spectrum.frequency)) Hz"
            noteLabel.text = note.name
            updateGapLabel(gap)
            
            graph.graphPoints = spectrum.spectrum
            graph.setNeedsDisplay()
            
            dialView.moveTo(spectrum.frequency)
        } catch {
            print("Could not get file from URL. Reason: \(error)")
        }
        recorder.record()
    }

    private func analyseAudioFile(_ file: AVAudioFile) -> Spectrum? {
        let spectralAnalyzer = SpectralAudioFileAnalyzer(transformer: FourierTransformer())
        return spectralAnalyzer.spectrum(file: file, duration: 1.5)
    }
    
    private func updateGapLabel(_ gap: Double) {
        if abs(gap) < 0.5 {
            noteLabel.textColor = .green
            gapLabel.text = ""
        } else {
            noteLabel.textColor = Color.graphite
            gapLabel.text = String(format: "\(gap < 0 ? "-" : "+")%.1f", abs(gap))
        }
    }
    
    // MARK: - Setup audio recording

    private func setupAudioSession () {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true)
        } catch {
            print("Could not setup AudioSession. Reason: \(error)")
        }
    }

    private func setupRecorder() {
        let recordingSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 44100.0
        ] as [String: Any]

        do {
            recorder = try AVAudioRecorder(url: getFileURL(), settings: recordingSettings)
        } catch {
            print("Could not setup AudioRecorder. Reason: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func getFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
}
