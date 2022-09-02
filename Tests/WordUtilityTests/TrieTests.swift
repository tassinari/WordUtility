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
    func testTrieAgainstCapsWord() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let path =  Bundle.module.path(forResource: "fullDictionary", ofType: "txt") else {
            XCTFail("no path to sample words")
            return
        }
        let trieMaker = TrieMaker(path: path)
        guard let data = trieMaker.createData() else{
            XCTFail("cant create data")
            return
        }
        let trie = Trie(data: data)
        
        let words = ["Street","HeLLo","CAPITAL","loweR"]
        for word in words{
            XCTAssert(trie.isWord(word),"\(word) not a word")
        }
        
    }
    func testAgainstExtraLetterAtEnd(){
        //noticed an extra s at the end of thaws -> thawss
        guard let path =  Bundle.module.path(forResource: "fullDictionary", ofType: "txt") else {
            XCTFail("no path to sample words")
            return
        }
        let trieMaker = TrieMaker(path: path)
        guard let data = trieMaker.createData() else{
            XCTFail("cant create data")
            return
        }
        let trie = Trie(data: data)
        XCTAssertTrue(trie.isWord("thaws"),"thaw is a word")
        XCTAssertFalse(trie.isWord("thawss"),"thawss not a word")
    }
    func testTrieDoesntBlowUpWithWhiteSpaceAndNumerals() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        guard let path =  Bundle.module.path(forResource: "fullDictionary", ofType: "txt") else {
            XCTFail("no path to sample words")
            return
        }
        let trieMaker = TrieMaker(path: path)
        guard let data = trieMaker.createData() else{
            XCTFail("cant create data")
            return
        }
        let trie = Trie(data: data)
        
        let words = ["Stre   et","HeLL2o","2CAPITAL","l1oweR","😁",  "             "]
        for word in words{
            XCTAssert(!trie.isWord(word),"\(word) not a word")
        }

    }
    func testTrieAgainstFullDictionarAndFakeWords() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        do{
            guard let url =  Bundle.module.url(forResource: "fullDictionary", withExtension: "data") else {
                XCTFail("no path to sample words")
                return
            }
            guard let path =  Bundle.module.path(forResource: "fullDictionary", ofType: "txt") else {
                XCTFail("no path to sample words")
                return
            }
            let data = try Data(contentsOf: url)
            let trie = Trie(data: data)
            let dict = try String(contentsOfFile: path, encoding: .utf8)
            let words : [String] = dict.components(separatedBy: .newlines)
            for word in words{
                XCTAssert(trie.isWord(word),"Error: word: \(word) is returning false")
         
            }
            guard let nonWordsPath =  Bundle.module.path(forResource: "fakeWords", ofType: "txt") else {
                XCTFail("no path to sample words")
                return
            }
            let dict2 = try String(contentsOfFile: nonWordsPath, encoding: .utf8)
            let fakewords : [String] = dict2.components(separatedBy: .newlines)
            for fakeword in fakewords{
                XCTAssertFalse(trie.isWord(fakeword),"Error: word: \(fakeword) is returning true")
         
            }
        }
        catch let e {
            XCTFail("exception : \(e)")
        }
       
       
    }


}
