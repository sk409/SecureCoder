
struct SectionInfo: Decodable {
    let index: Int
    let title: String
    let description: String
}

struct Section {
    
    let index: Int
    let title: String
    let description: String
    let safeLesson: Lesson
    let unsafeLesson: Lesson
    
}
