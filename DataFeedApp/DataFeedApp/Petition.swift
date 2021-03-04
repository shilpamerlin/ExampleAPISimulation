//
//  Petition.swift
//  DataFeedApp
//
//  Created by Shilpa Joy on 2021-03-03.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
