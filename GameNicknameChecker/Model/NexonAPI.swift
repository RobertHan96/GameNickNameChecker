//
//  NexonAPI.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import Foundation
import Alamofire


struct Response: Codable {
    let resultCount: Int
    let results: [KartRider]
}

struct KartRider: Codable {
    let accessId: String
    let name: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case accessId
        case name
        case level
    }
}


class NexonAPI {
    let cartRiderHeaders: HTTPHeaders = [
        "Authorization": APIs.Keys.kartRider.key
    ]
    let fifaOnlineHeaders: HTTPHeaders = [
        "Authorization": APIs.Keys.fifaOnline.key
    ]

    // url인코딩된 스트리을 붙이면 해결
    func serachInFifaKartRider(nickname: String, completion:@escaping ([KartRider]) -> Void) {
        let baseUrl = APIs.BaseUrls.kartRider.url
        let encodedString = nickname.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let requsetUrl = baseUrl + encodedString!
        AF.request(requsetUrl, method: .get, headers: cartRiderHeaders).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("LOG - 카트라이더 API 조회 결과\n")
                    debugPrint(data)
                    }
            case .failure(_):
                print("LOG - 카트라이더 API 조회 실패", response.request)
                debugPrint(response.result)
                break;
            }
        }
    }

    func serachInFifaOnline(nickname: String, completion:@escaping ([KartRider]) -> Void) {
        let url = APIs.BaseUrls.fifaOnline.url
        let params = ["nickname": nickname]
        AF.request(url, method: .get, parameters: params, headers: fifaOnlineHeaders).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("LOG - 피파 API 조회 결과\n")
                    debugPrint(data)
                    }
            case .failure(_):
                print("LOG - 피파 API 조회 실패")
                debugPrint(response.result)
                break;
            }
        }
    }

    func serachInDnf(nickname: String, completion:@escaping ([KartRider]) -> Void) {
        let url = APIs.BaseUrls.dnf.url
        let params = ["characterName": nickname, "wordType" : "match", "apikey" : APIs.Keys.dnf.key]
        AF.request(url, method: .get, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("LOG - 던파 API 조회 결과\n")
                    debugPrint(data)
                    }
            case .failure(_):
                print("LOG - 던파 API 조회 실패", response.request)
                debugPrint(response.result)
                break;
            }
        }
    }
    
    func serachCyphers(nickname: String, completion:@escaping ([KartRider]) -> Void) {
        let url = APIs.BaseUrls.cyphers.url
        let params = ["nickname": nickname, "wordType" : "match", "apikey" : APIs.Keys.cyphers.key]
        AF.request(url, method: .get, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("LOG - 싸이퍼즈 API 조회 결과\n")
                    debugPrint(data)
                    }
            case .failure(_):
                print("LOG - 싸이퍼즈 API 조회 실패", response.request)
                debugPrint(response.result)
                break;
            }
        }
    }
    
}
