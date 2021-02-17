//
//  Defaults.swift
//  MovieListMachineTest
//
//  Created by siddhesh on 17/02/21.
//  Copyright © 2021 siddhesh. All rights reserved.
//

import Foundation

struct Global {
    static var movies: [Movies.Movie] = []
    static var imgUrl =  "https://image.tmdb.org/t/p/w500"
}

struct Movies {
  struct  Movie{
    var title: String
    var synopsis: String
    var rating: NSNumber
    var releaseDate: String
    var imgUrl: String
    var bgImgUrl: String
    }
}
