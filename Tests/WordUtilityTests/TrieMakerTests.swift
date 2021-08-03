//
//  TrieMakerTests.swift
//  TrieMakerTests
//
//  Created by Mark Tassinari on 7/30/21.
//

import Foundation
import XCTest

@testable import WordUtility

//Equatable here because it recurses the whole tree, dont want to do this in an app
extension Node : Equatable{
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.letter == rhs.letter && lhs.isWord == rhs.isWord && rhs.children == lhs.children
    }
}

class TrieMakerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCreateDataWorksAndCanRecreate() throws {
        guard let path =  Bundle.module.path(forResource: "fullDictionary", ofType: "txt") else {
            XCTFail("no path to sample words")
            return
        }
        let test = TrieMaker(path:path)
        guard let data = test.createData() else{
            XCTFail("bad data")
            return
        }
        guard let url =  Bundle.module.url(forResource: "fullDictionary", withExtension: "data") else {
            XCTFail("no path to sample words")
            return
        }
       
        do{
            let expected = try Data(contentsOf: url)
            XCTAssert(data == expected)
            let recoveredTree = try test.treeFromData(data)
            XCTAssert(recoveredTree == test.root)
            
        }catch let e{
            XCTFail("exception : \(e)")
        }
    }

  
}
