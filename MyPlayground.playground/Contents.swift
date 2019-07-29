import UIKit

let defaults = UserDefaults.standard

let dictionaryKey = "myDictionary"

defaults.set(0.24, forKey: "Volume")
defaults.set(true, forKey: "MusicOn")
defaults.set("Ario", forKey: "PlayerName")
defaults.set(Date(), forKey: "AppLastOpenedByUser")

let array = [1,2,3]
defaults.set(array, forKey: "myArray")

let dictionary = ["name" : "Ario"]
defaults.set(dictionary, forKey: "myDictionary")




let appLastOpen = defaults.object(forKey: "AppLastOpenedByUser")
let volume = defaults.float(forKey: "Volume")
let myArray = defaults.array(forKey: "myArray") as! [Int]


let myDictionary = defaults.dictionary(forKey: dictionaryKey)

