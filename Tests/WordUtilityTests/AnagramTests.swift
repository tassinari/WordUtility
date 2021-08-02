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
    func testAnagramWorks() throws {
        do{
            let anagrams = try Anagram(withDataPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data")
            let perm = try anagrams.anagrams(of: "street")
            
            let data = try Data(contentsOf: URL(fileURLWithPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data"))
            let trie = Trie(data: data)
            for word in perm{
                print(word)
                XCTAssert(trie.isWord(word),"found a word not in dict (\(word))")
            }
        }catch{
            XCTFail()
        }
    }
    func testThatAnagramsThrowsOnBadPath(){
        


        XCTAssertThrowsError(try Anagram(withDataPath: "/fake/path.data")) { error in
            guard let err = error as? AnagramError else {
                XCTFail("wrong error: \(type(of: error))")
                return
            }
            XCTAssert(err == AnagramError.invalidDataPath ,"wrong type its : \(err)")
        }
       
    }
    func testThatAnagramsThrowsOnBadFile(){
        


        XCTAssertThrowsError(try Anagram(withDataPath: "/Users/tassinari/Developer/wordLists/empty.data")) { error in
            guard let err = error as? AnagramError else {
                XCTFail("wrong error: \(type(of: error))")
                return
            }
            XCTAssert(err == AnagramError.invalidDataPath ,"wrong type its : \(err)")
        }
       
    }
    func testThatAnagramsThrowsOnBadWord(){
       
        do{
            let anagram = try Anagram(withDataPath: "/Users/tassinari/Developer/wordLists/fullDictionary.data")
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
