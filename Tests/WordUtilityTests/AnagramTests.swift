import Foundation
import XCTest

@testable import WordUtility


class AnagramTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAnagramDoesntIncludeNonWords() throws {
        do{
            guard let url =  Bundle.module.url(forResource: "fullDictionary", withExtension: "data") else {
                XCTFail("no path to sample words")
                return
            }
            let anagrams = try Anagram(withDataURL: url )
            let perm = try anagrams.anagrams(of: "street")
            
            let data = try Data(contentsOf: url)
            let trie = Trie(data: data)
            for word in perm{
                XCTAssert(trie.isWord(word),"found a word not in dict (\(word))")
            }
        }catch{
            XCTFail()
        }
    }
    func testAnagramProducesAllAnagrams() throws {
        do{
            guard let url =  Bundle.module.url(forResource: "fullDictionary", withExtension: "data") else {
                XCTFail("no path to sample words")
                return
            }
            let ag = try Anagram(withDataURL: url )
            let anagrams = try ag.anagrams(of: "tough")
            let expected = ["ought","tough","goth","thug","thou","gout","hout","hog","hug","ugh","hot","hut","got","gut","tog","tug","out", "tho"]
            XCTAssert(expected.count == anagrams.count, "count off")
            for word in anagrams{
                XCTAssert(expected.contains(word), "\(word) not in expected)")
            }
           
        }catch{
            XCTFail()
        }
    }
    
    
    func testThatAnagramsThrowsOnBadPath(){
        

        let url = URL(fileURLWithPath: "/fake/path")
        XCTAssertThrowsError(try Anagram(withDataURL: url)) { error in
            guard let err = error as? AnagramError else {
                XCTFail("wrong error: \(type(of: error))")
                return
            }
            XCTAssert(err == AnagramError.invalidDataPath ,"wrong type its : \(err)")
        }
       
    }
    func testThatAnagramsThrowsOnBadWord(){
       
        do{
            guard let url =  Bundle.module.url(forResource: "fullDictionary", withExtension: "data") else {
                XCTFail("no path to sample words")
                return
            }
            let anagram = try Anagram(withDataURL: url)
            XCTAssertThrowsError(try anagram.anagrams(of: "sssss")) { error in
                guard let err = error as? AnagramError else {
                    XCTFail("wrong error: \(type(of: error))")
                    return
                }
                XCTAssert(err == AnagramError.notAWord,"wrong type its : \(err)")
            }
           
        }
        catch let e{
            XCTFail("bad setup: \(e)")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
