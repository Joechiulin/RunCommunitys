//
//  Comuser.swift
//  RunCommunity
//
class Comuser: Codable {
    var name: String
    var date: String
    
    public init(_ name: String,  _ date: String) {
        self.name = name
        self.date = date
        
    }
    
    
}
