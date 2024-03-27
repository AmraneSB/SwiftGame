import Foundation

// Structure représentant une question
struct Question: Codable {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let difficulty: Difficulty
    let category: String
}

// Enumération pour le niveau de difficulté
enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
}

// Structure représentant le classement des scores des utilisateurs
struct UserScore: Codable {
    let playerName: String
    let score: Int
    let difficulty: Difficulty
}

func loadQuestions(from file: String) -> [Question]? {
    if let url = Bundle.main.url(forResource: file, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let questions = try decoder.decode([Question].self, from: data)
            return questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    } else {
        print("File not found")
        return nil
    }
}


// Utilisation :
if let questions = loadQuestions(from: "questions") {
    // Utilisez les questions chargées ici
    for question in questions {
        print(question.question)
        // Traitez les questions comme vous le souhaitez
    }
} else {
    print("Failed to load questions.")
}
