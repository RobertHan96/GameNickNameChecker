//
//  Response.swift
//  GameNicknameChecker
//
//  Created by HanaHan on 2021/01/29.
//

import Foundation

struct Response: Codable {
    let resultCount: Int
    let gameName: String
    let results: [GeneralInformation]
}

struct GeneralInformation: Codable {
    let nmae: String
    let level: Int
    let server: String?
}
