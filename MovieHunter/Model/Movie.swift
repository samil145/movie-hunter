//
//  Movie.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 09.08.24.
//

import Foundation

struct MovieResponse: Codable
{
    var page: Int
    var results: [Movie]
    var total_pages: Int
    var total_results: Int
}

struct Movie: Codable, Hashable
{
    //let uuid = UUID()
    let id: Int
    var original_language: String?
    var original_title: String?
    var name: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var first_air_date: String?
    var title: String?
    var vote_average: Double?
    var vote_count: Int
    var genre_ids: [Int]?
    var genres: [Genre]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        //hasher.combine(uuid)
    }
}
