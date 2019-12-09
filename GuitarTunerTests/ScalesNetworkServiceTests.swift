//
//  ScalesNetworkServiceTests.swift
//  GuitarTunerTests
//
//  Created by Aleksey Shepelev on 09/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import XCTest
import UIKit
import GuitarTuner

class ScalesNetworkServiceTests: XCTestCase {
    
    static let image = UIImage(named: "smile", in: Bundle.init(for: ScalesNetworkServiceTests.self), compatibleWith: nil)!
    
    class MockURLSessionDataTask: URLSessionDataTask {
        override func resume() {
            return
        }
    }
    
    class MockURLSession: URLSession {
        
        let data: Data?
        
        init(_ data: Data?) {
            self.data = data
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            completionHandler(data, nil, nil)
            return MockURLSessionDataTask()
        }
    }
    
    class MockNetworkService: ScalesNetworkService {
        
        let data: Data?
        
        init(_ data: Data?) {
            self.data = data
        }
        override var session: URLSession {
            return MockURLSession(data)
        }
    }
    
    func testThatGetImageDataReturnsDataIfTaskReturnsData() {
        //Arrange
        let service = MockNetworkService(ScalesNetworkServiceTests.image.pngData()!)
        var imageData: Data = Data()
        let validLink = "https://yandex.ru"
        
        //Act
        service.getImageData(from: validLink, with: { dataOrNil in
            guard let data = dataOrNil else {
                XCTAssert(false)
                return
            }
            imageData = data
        })
        
        //Assert
        XCTAssertEqual(ScalesNetworkServiceTests.image.pngData()!, imageData)
    }
    
    func testThatGetImageDataReturnsNilIfTaskreturnsNil() {
        //Arrange
        let service = MockNetworkService(nil)
        let validLink = "https://yandex.ru"
        
        //Act
        service.getImageData(from: validLink, with: { dataOrNil in
            
            // Assert
            XCTAssertEqual(nil, dataOrNil)
        })
    }
    
    func testThatGetImageDataReturnsNilIfImageLinkIsInvalid() {
           //Arrange
           let service = ScalesNetworkService()
           let invalidLink = "invalid link"
           
           //Act
           service.getImageData(from: invalidLink, with: { dataOrNil in
               guard dataOrNil != nil else {
                   
                   //Assert
                   XCTAssert(true)
                   return
               }
               
               XCTAssert(false)
           })
       }
    
    let json = """
[
        {
            "name": "Name",
            "imgLinkLight": "Link",
            "imgLinkDark": "",
            "notes": [
                "1",
                "2"
            ]
        }
    ]
"""
    
    func testThatGetScalesDataReturnsDataIfTaskReturnsData() {
        //Arrange
        let service = MockNetworkService(Data(json.utf8))
        var guitarScaleJSONs = [GuitarScaleJSON]()
        let scaleJSON = GuitarScaleJSON()
        scaleJSON.name = "Name"
        scaleJSON.imgLinkLight = "Link"
        scaleJSON.imgLinkDark = ""
        scaleJSON.notes = ["1", "2"]
        
        //Act
        service.getScalesData(completion: { guitarScaleJSONsOrNil in
            guard let unwrappedGuitarScaleJSONs = guitarScaleJSONsOrNil else {
                XCTAssert(false)
                return
            }
            guitarScaleJSONs = unwrappedGuitarScaleJSONs
        })
        
        //Assert
        XCTAssertEqual(1, guitarScaleJSONs.count)
        XCTAssertEqual(guitarScaleJSONs[0], scaleJSON)
    }
    
    func testThatGetScalesDataReturnsNilIfTaskReturnsDataOfInvalidJSON() {
        //Arrange
        let service = MockNetworkService(Data("invalid json".utf8))
        let scaleJSON = GuitarScaleJSON()
        scaleJSON.name = "Name"
        scaleJSON.imgLinkLight = "Link"
        scaleJSON.imgLinkDark = ""
        scaleJSON.notes = ["1", "2"]
        
        //Act
        service.getScalesData(completion: { guitarScaleJSONsOrNil in
            
            //Assert
            XCTAssertEqual(nil, guitarScaleJSONsOrNil)
        })
    }
    
    func testThatGetScalesDataReturnsNilIfTaskReturnsNil() {
        //Arrange
        let service = MockNetworkService(nil)
        
        //Act
        service.getScalesData(completion: { dataOrNil in
            // Assert
            XCTAssertEqual(nil, dataOrNil)
        })
    }
    
    class MockInvalidLinkNetworkService: ScalesNetworkService {
        override func link(of requestType: RequestType) -> String {
            "invalid link"
        }
    }
    
    func testThatGetScalesDataReturnsNilIfLinkIsInvalid() {
        //Arrange
        let service = MockInvalidLinkNetworkService()
        
        //Act
        service.getScalesData(completion: { dataOrNil in
            
            //Assert
            XCTAssertEqual(nil, dataOrNil)
        })
    }
}

extension GuitarScaleJSON: Equatable {
    static func == (lhs: GuitarScaleJSON, rhs: GuitarScaleJSON) -> Bool {
        return lhs.name == rhs.name && lhs.imgLinkLight == rhs.imgLinkLight && lhs.imgLinkDark == rhs.imgLinkDark &&
            zip(lhs.notes, rhs.notes).allSatisfy({ pair in
                let (lhsNote, rhsHote) = pair
                return (lhsNote == rhsHote)
            })
    }
}
