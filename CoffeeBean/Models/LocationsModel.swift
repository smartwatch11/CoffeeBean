
struct LocationModel: Codable {
    let id: Int
    let name: String
    let point: Point
}

struct Point: Codable {
    let latitude: String
    let longitude: String
}
