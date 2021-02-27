//
//  APIs.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/28.
//

import Foundation


class APIs {

    func getNicknameData(nickname: String, completion:@escaping ([Response]) -> Void) {
        let group = DispatchGroup()
        let apiQueue = DispatchQueue(label: "api")
        var result: [Response] = []
        
        group.enter()
        apiQueue.async {
            NexonAPI().serachInFifaKartRider(nickname: nickname) { (data) in
                result.append(data)
                group.leave()
            }
        }
        
        group.enter()
        apiQueue.async {
            NexonAPI().serachInFifaOnline(nickname: nickname) { (data) in
                result.append(data)
                group.leave()
            }

        }

        group.enter()
        apiQueue.async {
            NexonAPI().serachInDnf(nickname: nickname) { (data) in
                result.append(data)
                group.leave()
            }
        }
        
        group.enter()
        apiQueue.async {
            NexonAPI().serachCyphers(nickname: nickname) { (data) in
                result.append(data)
                group.leave()
            }
        }

        group.enter()
        apiQueue.async {
            RiotAPI().serachInLoL(nickname: nickname) { (data) in
                result.append(data)
                group.leave()
            }
        }

        
        group.notify(queue: .global(qos: .userInteractive)) {
            print("LOG - 모든 API 확인 완료 결과 반환...")
            print(result)
            completion(result)
        }
    }
    
    enum BaseUrls {
        case kartRider
        case fifaOnline
        case dnf
        case cyphers
        case lol

        var url: String {
            switch self {
            case .kartRider : return "https://api.nexon.co.kr/kart/v1.0/users/nickname/"
            case .fifaOnline : return "https://api.nexon.co.kr/fifaonline4/v1.0/users"
            case .dnf : return "https://api.neople.co.kr/df/servers/all/characters"
            case .cyphers : return "https://api.neople.co.kr/cy/players"
            case.lol : return "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/"
            }
        }
    }
    
    enum Keys {
        case kartRider
        case fifaOnline
        case dnf
        case cyphers
        case lol

        var key: String {
            switch self {
            case .kartRider : return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiMzM2MDY1MTI0IiwiYXV0aF9pZCI6IjIiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4iLCJzZXJ2aWNlX2lkIjoiNDMwMDExMzkzIiwiWC1BcHAtUmF0ZS1MaW1pdCI6IjUwMDoxMCIsIm5iZiI6MTYwODE4NzgzOCwiZXhwIjoxNjIzNzM5ODM4LCJpYXQiOjE2MDgxODc4Mzh9.7YTZ3J7wFtOGJkuNmsPEw0ngG_sitvJ_f8n1hUlWPDs"
            case .fifaOnline : return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiMzM2MDY1MTI0IiwiYXV0aF9pZCI6IjIiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4iLCJzZXJ2aWNlX2lkIjoiNDMwMDExNDgxIiwiWC1BcHAtUmF0ZS1MaW1pdCI6IjUwMDoxMCIsIm5iZiI6MTYwODE4NzgxNywiZXhwIjoxNjIzNzM5ODE3LCJpYXQiOjE2MDgxODc4MTd9.BiE07iCB7qNOx2RWLqBEN1MNez9QRuAdxUoDHnv60uc"
            case .dnf : return "nUtGaA6q0UqHfw4gk70uQsTsb4Ux7WvC"
            case .cyphers : return "6R4gMMSE1vdc3ZEOnUCUlahMzimYcdyD"
            case .lol : return "RGAPI-93bf5c99-695e-43fd-be13-7ba783080d60"

            }
        }
    }
    
}

enum ResponseIds {
    case kartRider
    case fifaOnline
    case dnf
    case cyphers
    case lol

    var name: String {
        switch self {
        case .kartRider : return "kart"
        case .fifaOnline : return "fifa"
        case .dnf : return "dnf"
        case .cyphers : return "cyphers" 
        case.lol : return "lol"
        }
    }
}
