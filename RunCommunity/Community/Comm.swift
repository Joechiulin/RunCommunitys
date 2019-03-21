class Comm: Codable {
    var id: Int
    var name: String
    var location: String?
    var tvtext: String?
    var lblike: Int?
    
    public init(_ id: Int, _ name: String, _ location: String, _ tvtext: String, _ lblike: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.tvtext = tvtext
        self.lblike = lblike

    }
    
}
