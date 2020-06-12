//
//  HomeDataRanking_TH.swift
//  iOS-Design-Project
//
//  Created by 김태훈 on 2020/06/05.
//  Copyright © 2020 이주혁. All rights reserved.
//
import Foundation
struct HomeDataRanking_TH: Codable{
    var success : Bool
    var message : String
    var data : [Rank]
    
    enum CodingKeys: String, CodingKey{
        case success = "success"
        case message = "message"
        case data = "data"
    }
    
    init (from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([Rank].self, forKey: .data)) ?? [Rank(name: "")]
    }
}
struct Rank:Codable {
    var name:String
}
