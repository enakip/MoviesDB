//
//  MovieDetailModel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 18.11.2020.
//

import Foundation

// MARK: - MovieDetailModel
struct MovieDetailModel: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: JSONNull?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID, original_language, original_title, overview: String?
    let popularity: Double?
    let poster_path: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let release_date: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case belongsToCollection
        case budget, genres, homepage, id
        case imdbID
        case original_language
        case original_title
        case overview, popularity
        case poster_path
        case productionCompanies
        case productionCountries
        case release_date
        case revenue, runtime
        case spokenLanguages
        case status, tagline, title, video
        case vote_average
        case vote_count
    }
}

// MARK: MovieDetailModel convenience initializers and mutators

extension MovieDetailModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MovieDetailModel.self, from: data)
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
        adult: Bool?? = nil,
        backdropPath: String?? = nil,
        belongsToCollection: JSONNull?? = nil,
        budget: Int?? = nil,
        genres: [Genre]?? = nil,
        homepage: String?? = nil,
        id: Int?? = nil,
        imdbID: String?? = nil,
        original_language: String?? = nil,
        original_title: String?? = nil,
        overview: String?? = nil,
        popularity: Double?? = nil,
        poster_path: String?? = nil,
        productionCompanies: [ProductionCompany]?? = nil,
        productionCountries: [ProductionCountry]?? = nil,
        release_date: String?? = nil,
        revenue: Int?? = nil,
        runtime: Int?? = nil,
        spokenLanguages: [SpokenLanguage]?? = nil,
        status: String?? = nil,
        tagline: String?? = nil,
        title: String?? = nil,
        video: Bool?? = nil,
        vote_average: Double?? = nil,
        vote_count: Int?? = nil
    ) -> MovieDetailModel {
        return MovieDetailModel(
            adult: adult ?? self.adult,
            backdropPath: backdropPath ?? self.backdropPath,
            belongsToCollection: belongsToCollection ?? self.belongsToCollection,
            budget: budget ?? self.budget,
            genres: genres ?? self.genres,
            homepage: homepage ?? self.homepage,
            id: id ?? self.id,
            imdbID: imdbID ?? self.imdbID,
            original_language: original_language ?? self.original_language,
            original_title: original_title ?? self.original_title,
            overview: overview ?? self.overview,
            popularity: popularity ?? self.popularity,
            poster_path: poster_path ?? self.poster_path,
            productionCompanies: productionCompanies ?? self.productionCompanies,
            productionCountries: productionCountries ?? self.productionCountries,
            release_date: release_date ?? self.release_date,
            revenue: revenue ?? self.revenue,
            runtime: runtime ?? self.runtime,
            spokenLanguages: spokenLanguages ?? self.spokenLanguages,
            status: status ?? self.status,
            tagline: tagline ?? self.tagline,
            title: title ?? self.title,
            video: video ?? self.video,
            vote_average: vote_average ?? self.vote_average,
            vote_count: vote_count ?? self.vote_count
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: Genre convenience initializers and mutators

extension Genre {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Genre.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil
    ) -> Genre {
        return Genre(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath
        case name
        case originCountry
    }
}

// MARK: ProductionCompany convenience initializers and mutators

extension ProductionCompany {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductionCompany.self, from: data)
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
        id: Int?? = nil,
        logoPath: String?? = nil,
        name: String?? = nil,
        originCountry: String?? = nil
    ) -> ProductionCompany {
        return ProductionCompany(
            id: id ?? self.id,
            logoPath: logoPath ?? self.logoPath,
            name: name ?? self.name,
            originCountry: originCountry ?? self.originCountry
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1
        case name
    }
}

// MARK: ProductionCountry convenience initializers and mutators

extension ProductionCountry {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductionCountry.self, from: data)
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
        iso3166_1: String?? = nil,
        name: String?? = nil
    ) -> ProductionCountry {
        return ProductionCountry(
            iso3166_1: iso3166_1 ?? self.iso3166_1,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1
        case name
    }
}

// MARK: SpokenLanguage convenience initializers and mutators

extension SpokenLanguage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SpokenLanguage.self, from: data)
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
        iso639_1: String?? = nil,
        name: String?? = nil
    ) -> SpokenLanguage {
        return SpokenLanguage(
            iso639_1: iso639_1 ?? self.iso639_1,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
