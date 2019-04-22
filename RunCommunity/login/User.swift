class  User: Codable {
    var id :Int?
    var account :String?
    var password : String?
    var username : String?
    var phone : String?
    var email :String?
    var timestamp :String?
    
    public init(_ account: String, _ password: String, _ username: String? ,_ phone:String? , _ email : String?){
        self.account = account
        self.password = password
        self.username = username
        self.phone = phone
        self.email = email
    }
    
    public init( _ id:Int?,_ username: String? ,_ timestamp:String? ,_ phone:String?,_ email:String?){
        self.id = id
        self.username = username
        self.timestamp = timestamp
        self.phone = phone
        self.email = email
    }
    
    public init(_ account: String, _ password: String){
        self.account = account
        self.password = password
    }
    
    public init(_ account: String?,_ username: String?){
        self.account = account
        self.username = username
    }
    
}
