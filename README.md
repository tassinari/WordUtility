# WordUtility

A word game library that does word lookups and anagrams.  Can confirm if a word is a dictionary word via a [trie](https://en.wikipedia.org/wiki/Triehttp:// "trie") data structure.  Also creates anagrams of any word.

## Classes

### Trie
The main class.  Instantiate with data constructed via the TrieMaker  class.

```swift
guard let url =  Bundle.module.url(forResource: "dictionary", withExtension: "data") else {
    return
}
let data = try Data(contentsOf: url)
let trie = Trie(data: data)
trie.isWord("word")
```

### Anagrams
Creates anagrams of any word.  Uses trie internally for confirmation.

### TrieMaker
Makes a trie from a word list to be used by the trie class

```swift
guard let path =  Bundle.main.path(forResource: "dictionary", ofType: "txt") else {
            return
}
let trieMaker = TrieMaker(path: path)
guard let data = trieMaker.createData() else{
    return
}
///Data can now be fed to Trie class
```





