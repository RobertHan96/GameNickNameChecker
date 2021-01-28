//
//  RiotAPI.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import Foundation
import Alamofire


class RiotAPI {
    let headers: HTTPHeaders = [
        "X-Riot-Token": APIs.Keys.lol.key
    ]

    func serachInLoL(nickname: String, completion:@escaping ([KartRider]) -> Void) {
        let baseUrl = APIs.BaseUrls.lol.url
        var encodedString = nickname.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let requsetUrl = baseUrl + encodedString!
        AF.request(requsetUrl, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("LOG - 롤 API 조회 결과\n")
                    debugPrint(data)
                    }
            case .failure(_):
                print("LOG - 롤 API 조회 실패", response.request)
                debugPrint(response.result)
                break;
            }
        }
    }
}
