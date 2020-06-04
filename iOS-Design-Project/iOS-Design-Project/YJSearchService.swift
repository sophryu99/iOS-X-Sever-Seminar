//
//  YJSearchService.swift
//  iOS-Design-Project
//
//  Created by 이유진 on 2020/06/04.
//  Copyright © 2020 이주혁. All rights reserved.
//

import Foundation
import Alamofire

struct YJSearchService {
    static let shared = YJSearchService()

//    private func makeParameter(_ product1: String, _ product2: String, _ product3: String) -> Parameters {
//        return ["product1": product1, "product2": product2, "product3": product3]
//        }

    func makesearch(completion: @escaping (NetworkResult<Any>) -> Void) {
            let header: HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = Alamofire.request(APIConstants.searchURL, method: .get, encoding:
    JSONEncoding.default, headers: header)
        
            dataRequest.responseData { dataResponse in
                switch dataResponse.result {
                case .success:
                    guard let statusCode = dataResponse.response?.statusCode else { return }
                    guard let value = dataResponse.result.value else { return }
                    let networkResult = self.judge(by: statusCode, value)
                    completion(networkResult)
                case .failure: completion(.networkFail)
                }
            }
        }
        private func judge(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
            switch statusCode {
            case 200: return isProduct(by: data)
            case 400: return .pathErr
            case 500: return .serverErr
            default: return .networkFail
            }
        }

        private func isProduct(by data: Data) -> NetworkResult<Any> {
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(YJSearchData.self, from: data) else { return .pathErr }
            guard let productData: [ProductData] = decodedData.data else { return .requestErr(decodedData.message) }
            return .success(productData)
        }
}
