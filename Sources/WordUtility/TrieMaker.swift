//
//  TrieMaker.swift
//  TrieMaker
//
//  Created by Mark Tassinari on 7/30/21.
//

import Foundation

internal let letterMask : UInt32 = 0xff
internal let wordMask : UInt32 = 0x100
internal let eolMask : UInt32 = 0x200
internal let offsetMask : UInt32 = 0xFFFFFC00

enum TrieError : Error{
    
    case noDecodeData
}


internal class Node {

    var isWord : Bool = false
    let letter : Character
    var children : [Node] = []
    var eol : Bool = false
    var offset : UInt32 = 0
    
    init(letter : Character){
        self.letter = letter
    }
    
    func childNode(_ c : Character) -> Node?{
        return children.first(where: {$0.letter == c})
    }
}
extension Node : CustomStringConvertible{
    public var description: String{
        return "(\(self.letter)) /  isword : \(self.isWord) / EOL : \(self.eol) / offset : \(self.offset)"
    }
}

public class TrieMaker{
    
    internal let root = Node(letter: " ")
    
    public convenience init(path: String){
      
        self.init()
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let words : [String] = data.components(separatedBy: .newlines)
                for word in words{
                    add(word)
                }
            } catch {
                print(error)
            }
    }
    public func isWord( _ word: String) -> Bool{
        var ptr = root
        for char in word{
            if let node = ptr.childNode(char){
                ptr = node
            }else{
                return false
            }
        }
        return ptr.isWord
    }
    
    
    public func add( _ word: String){
        var ptr = root
        for char in word{
            if let node = ptr.childNode(char){
                ptr = node
                continue
            }else{
                let node = Node(letter: char)
                ptr.children.append(node)
                ptr = node
            }
        }
        ptr.isWord = true
    }
    
    public func createData() -> Data?{
       
        let intvalues = addNode(root)
        
        return intvalues.withUnsafeBufferPointer {Data(buffer: $0)}
    }
    private func addNode(_ node : Node ) -> [UInt32] {
        node.eol = true
        var queue : [Node] = []
        var ordered : [Node] = []
        queue.append(node)
        repeat{
            let n = queue.removeFirst()
            if n.children.count > 0{
                n.offset = UInt32(queue.count) + 1
            }
            ordered.append(n)
            for (i,child) in n.children.enumerated(){
                if i == n.children.count - 1{
                    child.eol = true
                }
                queue.append(child)
            }
        }while queue.count > 0
        return ordered.map { UInt32(node: $0) }
    }
    internal func treeFromData(_ data : Data) throws -> Node{
        var nodeArray = Array<UInt32>(repeating: 0, count: data.count/MemoryLayout<UInt32>.stride)
        _ = nodeArray.withUnsafeMutableBytes { data.copyBytes(to: $0) }
        
        guard var root = nodeArray.first?.node else{
            throw TrieError.noDecodeData
        }
        attachchildren(node: &root, arr: nodeArray, index: 0)
        
        return root
    }
    private func attachchildren(node: inout Node, arr : [UInt32], index : Int) {
        var childrenInts : [(Int, UInt32)] = []
        if node.offset == 0{
            return
        }
        var internalIndex = Int( node.offset) + index
        while (arr[internalIndex]  & eolMask) != eolMask{
            childrenInts.append((internalIndex, arr[internalIndex]))
            internalIndex += 1
        }
        childrenInts.append((internalIndex, arr[internalIndex]))
        for prenode in childrenInts{
            var childnode = prenode.1.node
            node.children.append(childnode)
            attachchildren(node: &childnode, arr: arr, index: prenode.0)
        }
       
    }
      
}
private extension UInt32 {
    
    init(node : Node){
        self.init()
        self = 0
        self  = self | UInt32(node.letter.asciiValue!)
        if node.isWord{
            self  = self | wordMask
        }
        if node.eol{
            self  = self | eolMask
        }
        if node.children.count > 0 {
            self  = self | ( node.offset << 10) & offsetMask
        }
        
    }
    
    var node : Node{
        let node = Node(letter: Character(UnicodeScalar(UInt8(letterMask & self))))
        node.isWord = (self & wordMask) > 0
        node.offset = (self & offsetMask) >> 10
        node.eol =  (self & eolMask) > 0
        return node
        
    }
}
