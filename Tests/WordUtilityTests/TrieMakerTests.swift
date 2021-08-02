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
    func testCreateDataWorks() throws {
        let test = TrieMaker(path: "/Users/tassinari/Developer/wordLists/words.txt")
        XCTAssert(test.isWord("bat"))
        guard let data = test.createData() else{
            XCTFail("bad data")
            return
        }
        do{
            try data.write(to: URL(fileURLWithPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data"))
            let recoveredTree = try test.treeFromData(data)
            XCTAssert(recoveredTree == test.root)
            
        }catch let e{
            XCTFail("exception : \(e)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
