//
//  VideoModel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 19.11.2020.
//

import Foundation

// MARK: - VideoModel
struct VideoModel: Codable {
    let id: Int?
    let results: [Results]?
}

// MARK: VideoModel convenience initializers and mutators

extension VideoModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VideoModel.self, from: data)
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
        results: [Results]?? = nil
    ) -> VideoModel {
        return VideoModel(
            id: id ?? self.id,
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
struct Results: Codable {
    let id, iso639_1, iso3166_1, key: String?
    let name, site: String?
    let size: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1
        case iso3166_1
        case key, name, site, size, type
    }
}

// MARK: Result convenience initializers and mutators

extension Results {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Results.self, from: data)
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
        id: String?? = nil,
        iso639_1: String?? = nil,
        iso3166_1: String?? = nil,
        key: String?? = nil,
        name: String?? = nil,
        site: String?? = nil,
        size: Int?? = nil,
        type: String?? = nil
    ) -> Results {
        return Results(
            id: id ?? self.id,
            iso639_1: iso639_1 ?? self.iso639_1,
            iso3166_1: iso3166_1 ?? self.iso3166_1,
            key: key ?? self.key,
            name: name ?? self.name,
            site: site ?? self.site,
            size: size ?? self.size,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

