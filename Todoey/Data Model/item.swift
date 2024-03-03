import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    init(_ title: String,_ done: Bool = false) {
        self.title = title
        self.done = done
    }
}
