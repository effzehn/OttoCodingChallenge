//
//  ServiceTests.swift
//  OttoCodingChallenge
//
//  Created by Developer on 12.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import XCTest

class ServiceTests: XCTestCase {
    
    var service: Service!
    
    override func setUp() {
        super.setUp()
        
        service = Service(urlSession: FakeSuccessfulDataTaskURLSession())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRequestMenu() {
        var successBlockCalled = false
        var failureBlockCalled = false
        var responseDictionary: Dictionary<String, Any>?
        
        let success: RequestSuccess = { dict in
            successBlockCalled = true
            responseDictionary = dict
        }
        
        let failure: RequestFailure = { error in
            failureBlockCalled = true
        }
        
        service.requestMenu(success: success, failure: failure)
        
        // It should have called the success block / closure
        XCTAssertTrue(successBlockCalled)
        
        // It should not have called the failure block
        XCTAssertFalse(failureBlockCalled)
        
        // It should have created a dictionary
        XCTAssertNotNil(responseDictionary)
        
        // It should have used the JSON string correctly
        XCTAssertEqual(responseDictionary?.first?.key, "navigationEntries")
    }
}

class FakeSuccessfulDataTaskURLSession: URLSession {
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let data = testJSON.data(using: .utf8)
        completionHandler(data, nil, nil)
        
        return FakeURLSessionDataTask()
    }
}

class FakeURLSessionDataTask: URLSessionDataTask {
    
    var resumeCalled = false
    
    override func resume() {
        resumeCalled = true
    }
}

let testJSON = "{ \"navigationEntries\": [{ \"type\": \"section\", \"label\": \"Schnu00e4ppchen\", \"children\": [{ \"type\": \"link\", \"label\": \"Alle Angebote im u00dcberblick\", \"url\": \"http://www.mytoys.de/sale/\" }, { \"type\": \"link\", \"label\": \"Baby Schnu00e4ppchen\", \"url\": \"http://www.mytoys.de/baby-schwangerschaft/sale/\" }, { \"type\": \"link\", \"label\": \"Spielzeug & Spiele Sale\", \"url\": \"http://www.mytoys.de/spielzeug-spiele/sale/\" }, { \"type\": \"link\", \"label\": \"Mode & Schuhe Sale\", \"url\": \"http://www.mytoys.de/mode-schuhe/sale/\" }, { \"type\": \"link\", \"label\": \"Artikel aus der Werbung\", \"url\": \"http://www.mytoys.de/14e/\" }, { \"type\": \"link\", \"label\": \"Knaller der Woche\", \"url\": \"http://www.mytoys.de/mkt/knaller-der-woche\" }] }, { \"type\": \"section\", \"label\": \"Beratung & Inspiration\", \"children\": [{ \"type\": \"node\", \"label\": \"Geschenketipps\", \"children\": [{ \"type\": \"link\", \"label\": \"Geschenketipps fu00fcr Mu00e4dchen\", \"url\": \"http://www.mytoys.de/weiblich/geschenke/\" }, { \"type\": \"link\", \"label\": \"Geschenketipps fu00fcr Jungen\", \"url\": \"http://www.mytoys.de/maennlich/geschenke/\" }] }, { \"type\": \"node\", \"label\": \"Ratgeber\", \"children\": [{ \"type\": \"link\", \"label\": \"Alle Ratgeber\", \"url\": \"http://www.mytoys.de/c/ratgeber.html\" }, { \"type\": \"link\", \"label\": \"Baby\", \"url\": \"http://www.mytoys.de/c/babyratgeber.html\" }, { \"type\": \"link\", \"label\": \"Mode\", \"url\": \"http://www.mytoys.de/c/ratgeber-kindermode.html\" }, { \"type\": \"link\", \"label\": \"PC/Games\", \"url\": \"http://www.mytoys.de/c/einkaufsberatung-pc-und-games-einstiegsseite.html\" }, { \"type\": \"link\", \"label\": \"Reisen mit Kind\", \"url\": \"http://www.mytoys.de/c/ratgeber-reisen.html\" }, { \"type\": \"link\", \"label\": \"Einschulung\", \"url\": \"http://www.mytoys.de/c/einkaufsberatung-schule-einstiegsseite.html\" }, { \"type\": \"link\", \"label\": \"Sport\", \"url\": \"http://www.mytoys.de/c/einkaufsberatung-sport-einstiegsseite.html\" }] }] }] } "
