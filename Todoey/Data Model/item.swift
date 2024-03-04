import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init(_ title: String,_ done: Bool = false) {
        self.title = title
        self.done = done
    }
}
