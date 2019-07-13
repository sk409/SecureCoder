
struct Guide: Decodable, Equatable {
    let index: Int
    let fileName: String
    var explainers: [Explainer]
}
