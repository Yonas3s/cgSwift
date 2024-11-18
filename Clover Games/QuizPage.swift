import SwiftUI

struct Question {
    let question: String
    let options: [String]
    let answer: String
}

struct QuizPage: View {
    // Вопросы для викторины
    let questions = [
        Question(question: "How many leaves does a four-leaf clover have?", options: ["4", "3", "5", "6"], answer: "4"),
        Question(question: "What color is considered a symbol of luck?", options: ["Blue", "Red", "Green", "Yellow"], answer: "Green"),
        Question(question: "In which country is the clover an official symbol of luck?", options: ["USA", "Ireland", "Japan", "France"], answer: "Ireland"),
        Question(question: "Which plant symbolizes luck?", options: ["Clover", "Rose", "Lily", "Tulip"], answer: "Clover"),
        Question(question: "What color is associated with luck?", options: ["Red", "Green", "Blue", "Yellow"], answer: "Green"),
        Question(question: "What item is often used to attract luck?", options: ["Horseshoe", "Key", "Coin", "Ring"], answer: "Horseshoe"),
        Question(question: "What day of the week is considered the luckiest?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Thursday"),
        Question(question: "What symbol is often used to attract luck?", options: ["Cross", "Star", "Heart", "Triangle"], answer: "Star"),
        Question(question: "What month is considered the luckiest to start new ventures?", options: ["January", "February", "March", "April"], answer: "March"),
        Question(question: "What item is often worn to attract luck?", options: ["Bracelet", "Ring", "Pendant", "Watch"], answer: "Pendant"),
        Question(question: "What color is often used to attract luck in Feng Shui?", options: ["Red", "Green", "Blue", "Yellow"], answer: "Red"),
        Question(question: "What item is often placed under a pillow to attract luck?", options: ["Coin", "Key", "Ring", "Stone"], answer: "Coin"),
        Question(question: "What day of the week is considered the unluckiest?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Monday"),
        Question(question: "What item is often hung above a door to attract luck?", options: ["Horseshoe", "Key", "Coin", "Ring"], answer: "Horseshoe"),
        Question(question: "What color is associated with luck in China?", options: ["Red", "Green", "Blue", "Yellow"], answer: "Red"),
        Question(question: "What item is often used to attract luck in Japan?", options: ["Horseshoe", "Key", "Hotei Coin", "Hotei Ring"], answer: "Hotei Coin"),
        Question(question: "What day of the week is considered the luckiest for weddings?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Thursday"),
        Question(question: "What item is often used to attract luck in India?", options: ["Horseshoe", "Key", "Ankush", "Ring"], answer: "Ankush"),
        Question(question: "What color is associated with luck in Ireland?", options: ["Red", "Green", "Blue", "Yellow"], answer: "Green"),
        Question(question: "What item is often used to attract luck in Russia?", options: ["Horseshoe", "Key", "Coin", "Ring"], answer: "Horseshoe"),
        Question(question: "What day of the week is considered the luckiest to start new projects?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Wednesday"),
        Question(question: "What item is often used to attract luck in Europe?", options: ["Horseshoe", "Key", "Coin", "Ring"], answer: "Horseshoe"),
        Question(question: "What day of the week is considered the luckiest for financial operations?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Wednesday"),
        Question(question: "What item is often used to attract luck in South America?", options: ["Horseshoe", "Key", "Amulet", "Ring"], answer: "Amulet"),
        Question(question: "What day of the week is considered the luckiest for travel?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Thursday"),
        Question(question: "What item is often used to attract luck in North America?", options: ["Horseshoe", "Key", "Amulet", "Ring"], answer: "Amulet"),
        Question(question: "What day of the week is considered the luckiest for romantic meetings?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Wednesday"),
        Question(question: "What item is often used to attract luck in Australia?", options: ["Horseshoe", "Key", "Amulet", "Ring"], answer: "Amulet"),
        Question(question: "What amulet is considered a symbol of luck in Egypt?", options: ["Eye of Horus", "Pentagram", "Scepter", "Ankh"], answer: "Eye of Horus"),
        Question(question: "What symbol is considered lucky in Feng Shui?", options: ["Dragon", "Lotus", "Butterfly", "Cat"], answer: "Dragon"),
        Question(question: "What day of the week is considered lucky for signing contracts?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Tuesday"),
        Question(question: "What color is associated with luck in Japan?", options: ["Red", "Green", "Blue", "Black"], answer: "Red"),
        Question(question: "What day of the week is considered lucky to start studying?", options: ["Monday", "Tuesday", "Wednesday", "Thursday"], answer: "Monday"),
        Question(question: "What talisman brings luck in Africa?", options: ["Horseshoe", "Stone", "Amulet", "Ancient symbol"], answer: "Amulet"),
        Question(question: "What item brings luck in Arab countries?", options: ["Horseshoe", "Stone", "Wonder Stone", "Incense"], answer: "Wonder Stone")
    ]
    
    @State private var shuffledQuestions: [Question]
        @State private var currentQuestionIndex = 0
        @State private var score = 0
        @State private var gameOver = false
        
        // Используем Environment для управления навигацией
        @Environment(\.presentationMode) var presentationMode
        
        init() {
            _shuffledQuestions = State(initialValue: questions.shuffled())
        }
        
        func handleAnswer(selectedOption: String) {
            // Проверяем правильность ответа
            if selectedOption == shuffledQuestions[currentQuestionIndex].answer {
                score += 1
            }
            
            if currentQuestionIndex < shuffledQuestions.count - 1 {
                currentQuestionIndex += 1
            } else {
                gameOver = true
            }
        }
        
        func resetGame() {
            shuffledQuestions = questions.shuffled()
            currentQuestionIndex = 0
            score = 0
            gameOver = false
        }
        
        var body: some View {
            ZStack {
                // Общий фон на весь экран
                Image("background") // Укажите путь к изображению для общего фона
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all) // Фон будет растягиваться на весь экран
                
                VStack {
                    if gameOver {
                        GameOverView(score: score, totalQuestions: shuffledQuestions.count, resetGame: resetGame)
                    } else {
                        QuizView(question: shuffledQuestions[currentQuestionIndex], handleAnswer: handleAnswer)
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true) // Убираем стандартную кнопку "Назад"
            .navigationBarItems(leading: Button(action: {
                // Этот код закроет текущий экран
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("home_icon") // Используем ваше изображение кнопки "Назад"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60) // Задайте нужный размер
                    .padding(10) // Отступы для кнопки
                    .padding(.top, 30)
            })
        }
    }

    struct QuizView: View {
        let question: Question
        let handleAnswer: (String) -> Void
        
        // Задаем ширину и высоту
        let questionWidth: CGFloat = 650
        let questionHeight: CGFloat = 200
        let answerButtonWidth: CGFloat = 270
        let answerButtonHeight: CGFloat = 70
        
        var body: some View {
            VStack {
                // Вопрос с фоновым изображением
                Text(question.question)
                    .font(.title)
                    .padding(.bottom, 20)
                    .frame(width: questionWidth, height: questionHeight, alignment: .center)
                    .background(
                        Image("frame_for_question") // Укажите путь к вашему изображению для фона вопроса
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    )
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем вопрос по горизонтали
                
                // Разделяем кнопки по 2 в строку
                VStack {
                    // Первая строка с двумя вариантами ответов
                    HStack {
                        ForEach(0..<2) { index in
                            if index < question.options.count {
                                Button(action: {
                                    handleAnswer(question.options[index])
                                }) {
                                    Text(question.options[index])
                                        .font(.title2)
                                        .padding()
                                        .frame(width: answerButtonWidth, height: answerButtonHeight, alignment: .center)
                                        .background(
                                            Image("frame_for_answer") // Укажите путь к вашему изображению для фона ответа
                                                .resizable()
                                                .scaledToFill()
                                                .clipped()
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                            }
                        }
                    }
                    // Вторая строка с двумя вариантами ответов
                    HStack {
                        ForEach(2..<4) { index in
                            if index < question.options.count {
                                Button(action: {
                                    handleAnswer(question.options[index])
                                }) {
                                    Text(question.options[index])
                                        .font(.title2)
                                        .padding()
                                        .frame(width: answerButtonWidth, height: answerButtonHeight, alignment: .center)
                                        .background(
                                            Image("frame_for_answer") // Укажите путь к вашему изображению для фона ответа
                                                .resizable()
                                                .scaledToFill()
                                                .clipped()
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопки
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
    }

    struct GameOverView: View {
        let score: Int
        let totalQuestions: Int
        let resetGame: () -> Void
        
        var body: some View {
            VStack {
                Text("Game Over!")
                    .font(.largeTitle)
                    .bold()
                
                Text("You answered \(score) out of \(totalQuestions) correctly.")
                    .font(.title2)
                    .padding()
                
                Button(action: resetGame) {
                    Text("Try Again")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center) // Центрируем все элементы
        }
    }

    struct QuizPage_Previews: PreviewProvider {
        static var previews: some View {
            QuizPage()
        }
    }
