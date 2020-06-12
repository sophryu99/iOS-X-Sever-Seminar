//
//  YJItemsData.swift
//  iOS-Design-Project
//
//  Created by 이유진 on 2020/06/04.
//  Copyright © 2020 이주혁. All rights reserved.
//

import Foundation
import Alamofire

struct YJItemsData: Codable {
    var success: Bool
    var message: String
    var data: [itemData]

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([itemData].self, forKey: .data)) ?? []
    }
}

struct itemData: Codable {
    var id: Int
    var name: String
    var price: Int
    var wow: Bool
    var delivery: Bool
    var fresh: Bool
    var basket: Bool
    var img: String
    var bannerimg: String
}
