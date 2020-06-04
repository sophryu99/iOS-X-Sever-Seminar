//
//  YJSearchData.swift
//  iOS-Design-Project
//
//  Created by 이유진 on 2020/06/04.
//  Copyright © 2020 이주혁. All rights reserved.
//

import Foundation
import Alamofire

struct YJSearchData: Codable {
    //var status: Int
    var success: Bool
    var message: String
    var data: [ProductData]

    enum CodingKeys: String, CodingKey {
        //case status = "status"
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([ProductData].self, forKey: .data)) ?? []
    }
}

struct ProductData: Codable {
    var name: String
}
