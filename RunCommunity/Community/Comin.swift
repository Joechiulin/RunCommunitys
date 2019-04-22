class Comin: Codable {
   
    var account: String
    var text: String?
    var date: String?


    public init(_ text: String ,_ account: String, _ date: String ){
        self.text = text
        self.account = account
        self.date = date
    }
    
}
