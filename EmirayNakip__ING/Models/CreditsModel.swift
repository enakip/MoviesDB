//
//  CreditsModel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 19.11.2020.
//

import Foundation

// MARK: - CreditsModel
struct CreditsModel: Codable {
    let id: Int?
    let cast, crew: [Cast]?
}

// MARK: CreditsModel convenience initializers and mutators

extension CreditsModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CreditsModel.self, from: data)
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
        cast: [Cast]?? = nil,
        crew: [Cast]?? = nil
    ) -> CreditsModel {
        return CreditsModel(
            id: id ?? self.id,
            cast: cast ?? self.cast,
            crew: crew ?? self.crew
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, original_name: String?
    let popularity: Double?
    let profile_path: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment
        case name
        case original_name
        case popularity
        case profile_path
        case castID
        case character
        case creditID
        case order, department, job
    }
}

// MARK: Cast convenience initializers and mutators

extension Cast {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Cast.self, from: data)
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
        gender: Int?? = nil,
        id: Int?? = nil,
        knownForDepartment: String?? = nil,
        name: String?? = nil,
        original_name: String?? = nil,
        popularity: Double?? = nil,
        profile_path: String?? = nil,
        castID: Int?? = nil,
        character: String?? = nil,
        creditID: String?? = nil,
        order: Int?? = nil,
        department: String?? = nil,
        job: String?? = nil
    ) -> Cast {
        return Cast(
            adult: adult ?? self.adult,
            gender: gender ?? self.gender,
            id: id ?? self.id,
            knownForDepartment: knownForDepartment ?? self.knownForDepartment,
            name: name ?? self.name,
            original_name: original_name ?? self.original_name,
            popularity: popularity ?? self.popularity,
            profile_path: profile_path ?? self.profile_path,
            castID: castID ?? self.castID,
            character: character ?? self.character,
            creditID: creditID ?? self.creditID,
            order: order ?? self.order,
            department: department ?? self.department,
            job: job ?? self.job
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

