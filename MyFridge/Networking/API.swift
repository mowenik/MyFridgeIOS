import Alamofire

struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

class PaginationModel<T: Codable>: Codable {
    let total: Int
    let data: [T]

    enum CodingKeys: String, CodingKey {
        case total = "count"
        case data = "results"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.data = (try container.decode([FailableDecodable<T>].self, forKey: .data)).compactMap { $0.base }
    }
}

enum API { }
