//
//  HomeService_TH.swift
//  iOS-Design-Project
//
//  Created by 김태훈 on 2020/06/02.
//  Copyright © 2020 이주혁. All rights reserved.
//

import Foundation
import Alamofire

var toggle:Bool = true
struct HomeService {
    static let shared = HomeService()
    
    func setUI(completion: @escaping (NetworkResult<Any>) -> Void){
        toggle = true
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let dataRequest = Alamofire.request(APIConstants.baseURL + "/items", method: .get, parameters:nil, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    func getRank(completion: @escaping (NetworkResult<Any>) -> Void){
        toggle = false
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        let dataRequest = Alamofire.request(APIConstants.baseURL + "/search", method: .get, parameters:nil, encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    private func judge(by statusCode:Int, _ data:Data) -> NetworkResult<Any> {
        
        switch statusCode {
        case 200:
            return setData(by: data)
        case 400:
            return .pathErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    private func setData(by data:Data) ->NetworkResult<Any> {
        let decoder = JSONDecoder()
        if toggle {
            guard let decodedData = try? decoder.decode(HomeData_TH.self, from: data) else { return .pathErr }
            return .success(decodedData.data)

        }
        else {
            guard let decodedData = try? decoder.decode(HomeDataRanking_TH.self, from: data) else { return .pathErr }
            return .success(decodedData.data)
        }
    }
}
