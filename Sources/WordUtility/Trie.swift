//
//  Trie.swift
//  Trie
//
//  Created by Mark Tassinari on 7/29/21.
//

import Foundation

public class  Trie{
    
    private let nodes : [UInt32]
    
    public init(data : Data){
        var nodeArray = Array<UInt32>(repeating: 0, count: data.count/MemoryLayout<UInt32>.stride)
        _ = nodeArray.withUnsafeMutableBytes { data.copyBytes(to: $0) }
        self.nodes = nodeArray
    }
    
    public func isWord(_ word : String) -> Bool{
        
        //start at data root an walk the tree
       
        var childPointer = 0
        
        //move current to end of tree
        for char in word.lowercased(){
            guard let index = indexOf(char: char, parentIndex: childPointer) else {
                return false
            }
            childPointer = index
        }
        
        return nodes[childPointer] & wordMask == wordMask
    }
    fileprivate func indexOf(char : Character, parentIndex : Int) -> Int?{
        let offset = Int(((offsetMask & nodes[parentIndex]) >> 10))
        if offset == 0 {
            return nil
        }
        var internalIndex = parentIndex + offset
        while (nodes[internalIndex]  & eolMask) != eolMask{
            if Character(UnicodeScalar(UInt8(letterMask & nodes[internalIndex]))) == char {
                return internalIndex
            }
            internalIndex += 1
        }
        return Character(UnicodeScalar(UInt8(letterMask & nodes[internalIndex]))) == char ? internalIndex : nil
    }
}


