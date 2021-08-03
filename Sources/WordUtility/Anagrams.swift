//
//  Anagrams.swift
//  Anagrams
//
//  Created by Mark Tassinari on 8/2/21.
//

import Foundation
import Algorithms

enum AnagramError : Error {
    case invalidDataPath, dataInitializationError, notAWord
}

public class Anagram{
    
    
    private let trie : Trie
    
    
    public init(withDataURL url : URL ) throws{
        if !FileManager.default.fileExists(atPath: url.path){
            throw AnagramError.invalidDataPath
        }
        
        do{
            let data = try Data(contentsOf: url)
            self.trie = Trie(data: data)
           
        }catch  {
            throw AnagramError.dataInitializationError
            
        }
        
    }
    
    public func anagrams(of word : String, minimum : Int = 3) throws -> [String]{
        if !trie.isWord(word){
            throw AnagramError.notAWord
        }
        var answers : [String] = []
        let characters = word.map{Character(extendedGraphemeClusterLiteral: $0)}
        for perm in characters.permutations(ofCount: minimum...) {
            let string = String(perm)
            if trie.isWord(string){
                answers.append(string)
            }
        }
        let set = Set(answers)
        return Array(set)
    }
    
}
