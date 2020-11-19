//
//  MoviesModel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 16.11.2020.
//

import Foundation

// MARK: - MoviesModel
struct MoviesModel: Codable {
    let page, totalResults, totalPages: Int?
    let results: [Result]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults
        case totalPages
        case results
    }
}

// MARK: MoviesModel convenience initializers and mutators

extension MoviesModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoviesModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        page: Int?? = nil,
        totalResults: Int?? = nil,
        totalPages: Int?? = nil,
        results: [Result]?? = nil
    ) -> MoviesModel {
        return MoviesModel(
            page: page ?? self.page,
            totalResults: totalResults ?? self.totalResults,
            totalPages: totalPages ?? self.totalPages,
            results: results ?? self.results
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Result
struct Result: Codable {
    let popularity: Double?
    let vote_count: Int?
    let video: Bool?
    let poster_path: String?
    let id: Int?
    let adult: Bool?
    let backdropPath: String?
    let originalLanguage: OriginalLanguage?
    let originalTitle: String?
    let genreIDS: [Int]?
    let title: String?
    let vote_average: Double?
    let overview, release_date: String?

    enum CodingKeys: String, CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id, adult
        case backdropPath
        case originalLanguage
        case originalTitle
        case genreIDS
        case title
        case vote_average
        case overview
        case release_date
    }
}

// MARK: Result convenience initializers and mutators

extension Result {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Result.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        popularity: Double?? = nil,
        vote_count: Int?? = nil,
        video: Bool?? = nil,
        poster_path: String?? = nil,
        id: Int?? = nil,
        adult: Bool?? = nil,
        backdropPath: String?? = nil,
        originalLanguage: OriginalLanguage?? = nil,
        originalTitle: String?? = nil,
        genreIDS: [Int]?? = nil,
        title: String?? = nil,
        vote_average: Double?? = nil,
        overview: String?? = nil,
        release_date: String?? = nil
    ) -> Result {
        return Result(
            popularity: popularity ?? self.popularity,
            vote_count: vote_count ?? self.vote_count,
            video: video ?? self.video,
            poster_path: poster_path ?? self.poster_path,
            id: id ?? self.id,
            adult: adult ?? self.adult,
            backdropPath: backdropPath ?? self.backdropPath,
            originalLanguage: originalLanguage ?? self.originalLanguage,
            originalTitle: originalTitle ?? self.originalTitle,
            genreIDS: genreIDS ?? self.genreIDS,
            title: title ?? self.title,
            vote_average: vote_average ?? self.vote_average,
            overview: overview ?? self.overview,
            release_date: release_date ?? self.release_date
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ja = "ja"
    case ko = "ko"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
