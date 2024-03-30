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

func startGame() {
    // Interface utilisateur pour saisir le nom et sélectionner le niveau de difficulté
    let playerName = getPlayerName()
    let difficulty = selectDifficulty()
    
    // Charger les questions en fonction du niveau de difficulté
    guard let questions = loadQuestions(for: difficulty) else {
        print("Failed to load questions.")
        return
    }
    
    // Mélanger les questions
    let shuffledQuestions = shuffleQuestions(questions)
    
    var score = 0
    
    // Boucle à travers les questions
    for question in shuffledQuestions {
        // Afficher la question à l'utilisateur et obtenir sa réponse
        let userAnswer = getUserAnswer(for: question)
        
        // Vérifier si la réponse est correcte et attribuer des points
        if userAnswer == question.correctAnswerIndex {
            score += 1
            print("Correct!")
        } else {
            print("Incorrect.")
        }
        
        // Afficher le score actuel de l'utilisateur
        print("Score: \(score)")
    }
    
    // Afficher le score final de l'utilisateur
    print("Final score: \(score)")
    
    // Enregistrer le score de l'utilisateur
    saveUserScore(playerName: playerName, score: score, difficulty: difficulty)
}


// Fonctions d'interface utilisateur et de manipulation des données à implémenter

func getPlayerName() -> String {
    print("Entrez votre nom:")
    if let playerName = readLine() {
        return playerName
    } else {
        return "Joueur"
    }
}