//
//  NexonAPI.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import Foundation
import Alamofire

class NexonAPI {
    let decoder = JSONDecoder()
    
    func serachInFifaKartRider(nickname: String, completion:@escaping (Response) -> Void) {
        let baseUrl = APIs.BaseUrls.kartRider.url
        let headers: HTTPHeaders = [
            "Authorization": APIs.Keys.kartRider.key
        ]
        let encodedString = nickname.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let requsetUrl = baseUrl + encodedString!
        AF.request(requsetUrl, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decodedData = try self.decoder.decode(KartRider.self, from: jsonData)
                        let generalInfo = GeneralInformation(nmae: decodedData.name, level: decodedData.level, server: nil)
                        let response = Response(resultCount: 1, gameName: ResponseIds.kartRider.name, results: [generalInfo])
                        completion(response)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let e):
                print("LOG - 카트라이더 API 조회 실패", e.localizedDescription)
                debugPrint(response.result)
                let response = Response(resultCount: 0, gameName: ResponseIds.kartRider.name, results: [])
                completion(response)
                break;
            }
        }
    }

    func serachInFifaOnline(nickname: String, completion:@escaping (Response) -> Void) {
        let url = APIs.BaseUrls.fifaOnline.url
        let params = ["nickname": nickname]
        let headers: HTTPHeaders = [
            "Authorization": APIs.Keys.fifaOnline.key
        ]

        AF.request(url, method: .get, parameters: params, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decodedData = try self.decoder.decode(Fifa.self, from: jsonData)
                        let generalInfo = GeneralInformation(nmae: decodedData.nickname, level: decodedData.level, server: nil)
                        let response = Response(resultCount: 1, gameName: ResponseIds.fifaOnline.name, results: [generalInfo])
                        completion(response)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(_):
                print("LOG - 피파 API 조회 실패")
                debugPrint(response.result)
                let response = Response(resultCount: 0, gameName: ResponseIds.fifaOnline.name, results: [])
                completion(response)
                break;
            }
        }
    }

    func serachInDnf(nickname: String, completion:@escaping (Response) -> Void) {
        let url = APIs.BaseUrls.dnf.url
        let params = ["characterName": nickname, "wordType" : "match", "apikey" : APIs.Keys.dnf.key]
        AF.request(url, method: .get, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decodedData = try self.decoder.decode(Dnf.self, from: jsonData)
                        let rows = decodedData.rows
                        var generalInfos: [GeneralInformation] = []
                        for row in rows {
                            let character = GeneralInformation(nmae: row.characterName, level: row.level, server: row.serverId)
                            generalInfos.append(character)
                        }
                        let response = Response(resultCount: 1, gameName: ResponseIds.dnf.name, results: generalInfos)
                        completion(response)
                    } catch {
                        print(error.localizedDescription)
                        }
                    }
            case .failure(_):
                print("LOG - 던파 API 조회 실패")
                debugPrint(response.result)
                let response = Response(resultCount: 0, gameName: ResponseIds.dnf.name, results: [])
                completion(response)
                break;
                }
            }
        }

    func serachCyphers(nickname: String, completion:@escaping (Response) -> Void) {
        let url = APIs.BaseUrls.cyphers.url
        let params = ["nickname": nickname, "wordType" : "match", "apikey" : APIs.Keys.cyphers.key]
        AF.request(url, method: .get, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let decodedData = try self.decoder.decode(Cyphers.self, from: jsonData)
                        let rows = decodedData.rows
                        var generalInfos: [GeneralInformation] = []
                        for row in rows {
                            let character = GeneralInformation(nmae: row.nickname, level: row.grade, server: nil)
                            generalInfos.append(character)
                        }
                        let response = Response(resultCount: 1, gameName: ResponseIds.cyphers.name, results: generalInfos)
                        completion(response)
                    } catch {
                        print(error.localizedDescription)
                        }
                    }
            case .failure(_):
                print("LOG - 싸이퍼즈 API 조회 실패")
                debugPrint(response.result)
                let response = Response(resultCount: 0, gameName: ResponseIds.cyphers.name, results: [])
                completion(response)
                break;
            }
        }
    }
    
}
