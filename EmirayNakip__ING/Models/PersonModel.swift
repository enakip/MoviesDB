//
//  PersonModel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 20.11.2020.
//

import Foundation

// MARK: - PersonModel
struct PersonModel: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let deathday: JSONNull?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, place_of_birth: String?
    let popularity: Double?
    let profile_path: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs
        case biography, birthday, deathday, gender, homepage, id
        case imdbID
        case knownForDepartment
        case name
        case place_of_birth
        case popularity
        case profile_path
    }
}

// MARK: PersonModel convenience initializers and mutators

extension PersonModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PersonModel.self, from: data)
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
        alsoKnownAs: [String]?? = nil,
        biography: String?? = nil,
        birthday: String?? = nil,
        deathday: JSONNull?? = nil,
        gender: Int?? = nil,
        homepage: String?? = nil,
        id: Int?? = nil,
        imdbID: String?? = nil,
        knownForDepartment: String?? = nil,
        name: String?? = nil,
        place_of_birth: String?? = nil,
        popularity: Double?? = nil,
        profile_path: String?? = nil
    ) -> PersonModel {
        return PersonModel(
            adult: adult ?? self.adult,
            alsoKnownAs: alsoKnownAs ?? self.alsoKnownAs,
            biography: biography ?? self.biography,
            birthday: birthday ?? self.birthday,
            deathday: deathday ?? self.deathday,
            gender: gender ?? self.gender,
            homepage: homepage ?? self.homepage,
            id: id ?? self.id,
            imdbID: imdbID ?? self.imdbID,
            knownForDepartment: knownForDepartment ?? self.knownForDepartment,
            name: name ?? self.name,
            place_of_birth: place_of_birth ?? self.place_of_birth,
            popularity: popularity ?? self.popularity,
            profile_path: profile_path ?? self.profile_path
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

