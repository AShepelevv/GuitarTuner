//
//  Notes.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 26/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation

struct Note {
    let frequency: Double
    let name: String

    init(frequency: Double, name: String) {
        self.frequency = frequency
        self.name = name
    }
}

class Notes {

    private let unknownNote = Note(frequency: 0.0, name: "??")

    private let notes: [String: Note] = [
        "B5": Note(frequency: 987.767, name: "B5"),
        "A♯5": Note(frequency: 932.328, name: "A♯5/B♭5"),
        "A5": Note(frequency: 880.000, name: "A5"),
        "G♯5": Note(frequency: 830.609, name: "G♯5/A♭5"),
        "G5": Note(frequency: 783.991, name: "G5"),
        "F♯5": Note(frequency: 739.989, name: "F♯5/G♭5"),
        "F5": Note(frequency: 698.456, name: "F5"),
        "E5": Note(frequency: 659.255, name: "E5"),
        "D♯5": Note(frequency: 622.254, name: "D♯5/E♭5"),
        "D5": Note(frequency: 587.330, name: "D5"),
        "C♯5": Note(frequency: 554.365, name: "C♯5/D♭5"),
        "C5": Note(frequency: 523.251, name: "C5"),
        "B4": Note(frequency: 493.883, name: "B4"),
        "A♯4": Note(frequency: 466.164, name: "A♯4/B♭4"),
        "A4": Note(frequency: 440.000, name: "A4"),
        "G♯4": Note(frequency: 415.305, name: "G♯4/A♭4"),
        "G4": Note(frequency: 391.995, name: "G4"),
        "F♯4": Note(frequency: 369.994, name: "F♯4/G♭4"),
        "F4": Note(frequency: 349.228, name: "F4"),
        "E4": Note(frequency: 329.628, name: "E4"),
        "D♯4": Note(frequency: 311.127, name: "D♯4/E♭4"),
        "D4": Note(frequency: 293.665, name: "D4"),
        "C♯4": Note(frequency: 277.183, name: "C♯4/D♭4"),
        "C4": Note(frequency: 261.626, name: "C4"),
        "B3": Note(frequency: 246.942, name: "B3"),
        "A♯3": Note(frequency: 233.082, name: "A♯3/B♭3"),
        "A3": Note(frequency: 220.000, name: "A3"),
        "G♯3": Note(frequency: 207.652, name: "G♯3/A♭3"),
        "G3": Note(frequency: 195.998, name: "G3"),
        "F♯3": Note(frequency: 184.997, name: "F♯3/G♭3"),
        "F3": Note(frequency: 174.614, name: "F3"),
        "♭E3": Note(frequency: 164.814, name: "E3"),
        "D♯3": Note(frequency: 155.563, name: "D♯3/E♭3"),
        "D3": Note(frequency: 146.832, name: "D3"),
        "C♯3": Note(frequency: 138.591, name: "C♯3/D♭3"),
        "C3": Note(frequency: 130.813, name: "C3"),
        "B2": Note(frequency: 123.471, name: "B2"),
        "A♯2": Note(frequency: 116.541, name: "A♯2/B♭2"),
        "A2": Note(frequency: 110.000, name: "A2"),
        "G♯2": Note(frequency: 103.826, name: "G♯2/A♭2"),
        "G2": Note(frequency: 97.9989, name: "G2"),
        "F♯2": Note(frequency: 92.4986, name: "F♯2/G♭2"),
        "F2": Note(frequency: 87.3071, name: "F2"),
        "E2": Note(frequency: 82.4069, name: "E2"),
        "D♯2": Note(frequency: 77.7817, name: "D♯2/E♭2"),
        "D2": Note(frequency: 73.4162, name: "D2"),
        "C♯2": Note(frequency: 69.2957, name: "C♯2/D♭2"),
        "C2": Note(frequency: 65.406, name: "C2")
    ]

    func getNearestNote(for frequency: Double) -> (Note, Double) {
        var nearestNote: Note = unknownNote
        var minGap: Double = 10000.0
        for (_, note) in notes {
            let gap = frequency - note.frequency
            if abs(gap) < abs(minGap) {
                minGap = gap
                nearestNote = note
            }
        }
        return (nearestNote, minGap)
    }
}

//extension Note : Equatable {
//    
//    private static var eps: Double {
//        return pow(10, -9)
//    }
//    
//    static func == (lhs: Note, rhs: Note) -> Bool {
//        return abs(lhs.frequency - rhs.frequency) < eps  &&  lhs.name == rhs.name
//    }
//}
