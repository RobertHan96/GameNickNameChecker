//
//  Codeable.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/30.
//

import Foundation

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

struct Fifa: Codable {
    let accessId: String
    let nickname: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case accessId
        case nickname
        case level
    }
}

struct Dnf: Codable {
    let rows: [DnfCharacter]
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
}

struct DnfCharacter: Codable {
    let serverId: String
    let characterId: String
    let characterName: String
    let level: Int
    let jobId: String
    let jobGrowId: String
    let jobName: String
    let jobGrowName: String
}

struct Cyphers: Codable {
    let rows: [CyphersCharacter]
    
    enum CodingKeys: String, CodingKey {
        case rows
    }
}

struct CyphersCharacter: Codable {
    let playerId: String
    let nickname: String
    let grade: Int
}

struct Lol: Codable {
    let id: String
    let accountId: String
    let puuid: String
    let name: String
    let profileIconId: Int
    let revisionDate: Int
    let summonerLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case puuid
        case name
        case profileIconId
        case revisionDate
        case summonerLevel
    }
}
