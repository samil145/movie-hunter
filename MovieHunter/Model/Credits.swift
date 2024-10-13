//
//  Credits.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 09.08.24.
//

import Foundation

let gender: [Int: String] =
[
    0: "Actor",
    1: "Actress",
    2: "Actor",
    3: "Actor"
]

struct CreditsResponse: Codable
{
    var id: Int
    var cast: [Cast]
    var crew: [Crew]
}

struct Cast: Codable
{
    var id: Int?
    var gender: Int?
    var known_for_department: String?
    var name: String?
    var profile_path: String?
    var character: String?
}

struct Crew: Codable
{
    var id: Int?
    var gender: Int?
    var name: String?
    var profile_path: String?
    var job: String?
}

struct CastAndCrew
{
    var actors: [Cast]
    var director: [Crew]
}

struct CastCollectionModel
{
    var id: Int
    var posterURL: String
    var name: String
    var roleName: String
}

extension CastCollectionModel {
    init(from cast: Cast) {
        self.id = cast.id!
        self.posterURL = cast.profile_path ?? ""
        self.name = cast.name ?? ""
        self.roleName = cast.character != "" ? cast.character!.capitalized : gender[cast.gender!]!
    }
    
    init(from crew: Crew) {
        self.id = crew.id!
        self.posterURL = crew.profile_path ?? ""
        self.name = crew.name ?? ""
        self.roleName = crew.job ?? ""
    }
}

extension CastAndCrew {
    func toCastCollectionModels() -> [CastCollectionModel] {
        let castModels = actors.map { CastCollectionModel(from: $0) }
        let crewModels = director.map { CastCollectionModel(from: $0) }
        return crewModels + castModels
    }
}
