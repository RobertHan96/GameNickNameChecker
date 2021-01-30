//
//  RiotAPI.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import Foundation
import Alamofire

class RiotAPI {
    let decoder = JSONDecoder()
    let headers: HTTPHeaders = [
        "X-Riot-Token": APIs.Keys.lol.key
    ]

    func serachInLoL(nickname: String, completion:@escaping (Response) -> Void) {
        let baseUrl = APIs.BaseUrls.lol.url
        var encodedString = nickname.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let requsetUrl = baseUrl + encodedString!
        AF.request(requsetUrl, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decodedData = try self.decoder.decode(Lol.self, from: jsonData)
                        let generalInfo = GeneralInformation(nmae: decodedData.name, level: decodedData.summonerLevel, server: nil)
                        let response = Response(resultCount: 1, gameName: ResponseIds.lol.name, results: [generalInfo])
                        completion(response)
                    } catch {
                        print(error.localizedDescription)
                    }
                    }
            case .failure(_):
                print("LOG - 롤 API 조회 실패")
                debugPrint(response.result)
                let response = Response(resultCount: 0, gameName: ResponseIds.lol.name, results: [])
                completion(response)
                break;
            }
        }
    }
}
