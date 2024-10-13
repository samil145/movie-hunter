//
//  ErrorMessage.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 11.08.24.
//

import Foundation

enum MHError: String, Error
{
    // Movie Errors
    case invalidMovieTitle  = "This movie title created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    
    // Person Errors
    case invalidPersonURL = "Invalid request. Please try again."
    
    // Favorites
    case unableToFavorite = "There was an error favoriting this movie. Please try again."
    case alreadyInFavorites = "You have already favorited this movie."
    
}
