//
//  Trailer.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 02.10.24.
//

import Foundation

struct Trailer: Codable
{
    let id: String
    let key: String
    let site: String
    let official: Bool
    let type: String
}

struct TrailerResponse: Codable
{
    let id: Int
    let results: [Trailer]
}
