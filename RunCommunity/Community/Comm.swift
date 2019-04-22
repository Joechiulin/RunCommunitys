
class Comm: Codable {
    
    var id: Int
    var account: String
    var text: String?
    var likes: Int
    var date : String
    
    public init(_ id: Int, _ account: String, _ text: String, _ likes: Int,_ date: String) {
        self.id = id
        self.account = account
        self.text = text
        self.likes = likes
        self.date = date
    }
   
    
}
