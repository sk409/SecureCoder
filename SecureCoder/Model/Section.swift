
struct SectionData: Decodable {
    let title: String
    let content: String
    let skills: [String]
}

struct Section {
    
    let title: String
    let content: String
    let skills: [String]
    var lessons: [Lesson]
    
}
