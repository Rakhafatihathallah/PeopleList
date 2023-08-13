//
//  Models.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 05/12/22.
//
// MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
