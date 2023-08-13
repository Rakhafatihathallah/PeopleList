//
//  UserResponse.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 05/12/22.
//

import Foundation

struct UserResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}

