//
//  Question.swift
//  SOPostDisplay
//
//  Created by Tom on 4/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import Foundation

struct questionContainer: Codable {
    var items: [Question]?
}

struct Question: Codable {
    var title: String
    var tags: [String]
    var owner: Owner
    var is_answered: Bool
    var link: String
}


struct Owner: Codable {
    var display_name: String
    var link: String?
    var profile_image: String?
    var reputation: Int?
}
