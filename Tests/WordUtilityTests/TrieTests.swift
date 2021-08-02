//
//  Trie.swift
//  WordUtilityTests
//
//  Created by Mark Tassinari on 7/29/21.
//

import XCTest
@testable import WordUtility

class TrieTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrieAgainstFullDictionarAndFakeWords() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data"))
            let trie = Trie(data: data)
            let dict = try String(contentsOfFile: "/Users/tassinari/Developer/wordLists/words.txt", encoding: .utf8)
            let words : [String] = dict.components(separatedBy: .newlines)
            for word in words{
                XCTAssert(trie.isWord(word),"Error: word: \(word) is returning false")
         
            }
            
            let dict2 = try String(contentsOfFile: "/Users/tassinari/Developer/wordLists/fakeWords.txt", encoding: .utf8)
            let fakewords : [String] = dict2.components(separatedBy: .newlines)
            for fakeword in fakewords{
                XCTAssertFalse(trie.isWord(fakeword),"Error: word: \(fakeword) is returning true")
         
            }
        }
        catch let e {
            XCTFail("exception : \(e)")
        }
       
       
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data"))
                let _ = Trie(data: data)
               
            }catch let e {
                XCTFail("exception : \(e)")
            }
        }
    }

}
