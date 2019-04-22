class ChatMessage: Codable {
    var id :Int?
    var type :String?
    var sender :String?
    var receiver :String?
    var message :String?
    var timeStamp :String?
    
    init(type: String, sender: String, receiver: String, message: String) {
        self.type = type
        self.sender = sender
        self.receiver = receiver
        self.message = message
    }
    
    public init(_ id:Int,_ sender: String, _ receiver: String, _ message:String,_ timeStamp: String){
        self.id = id
        self.sender = sender
        self.receiver = receiver
        self.message = message
        self.timeStamp = timeStamp
    }
    
    
}
