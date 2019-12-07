//
//  NotesTests.swift
//  GuitarTunerTests
//
//  Created by Aleksey Shepelev on 26/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import XCTest
import Foundation
@testable import GuitarTuner

class NotesTests: XCTestCase {

    func testThatNotesGetCorrectNearestNoteToGivenFrequency() {
        //Arrange
        let eps = Double(pow(10.0, -6))
        let frequency = 330.0
        let gap = 330.0 - 329.628

        //Act
        let actual = Notes().getNearestNote(for: frequency)

        //Assert
        XCTAssertEqual(329.628, actual.0.frequency, accuracy: eps)
        XCTAssertEqual("E4", actual.0.name)
        XCTAssertEqual(gap, actual.1, accuracy: eps)
    }

}
