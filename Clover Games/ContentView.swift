import SwiftUI

struct ContentView: View {
    @ObservedObject private var musicManager = MusicManager.shared  // Используем синглтон MusicManager

    var body: some View {
        NavigationView {
            ZStack {
                // Фоновое изображение
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Верхняя строка с кнопками Play и Quiz
                    HStack(spacing: 20) {
                        // Кнопка Play
                        NavigationLink(destination: PlayPage()) {
                            Text("Play")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60, alignment: .center)
                                .background(
                                    Image("button_frame")
                                        .resizable()
                                        .scaledToFill()
                                )
                                .cornerRadius(10)
                                .font(.system(size: 20))
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            musicManager.playButtonClickSound() // Воспроизведение звука при нажатии
                        })

                        // Кнопка Quiz
                        NavigationLink(destination: QuizPage()) {
                            Text("Quiz")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(
                                    Image("button_frame")
                                        .resizable()
                                        .scaledToFill()
                                )
                                .cornerRadius(10)
                                .font(.system(size: 20))
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            musicManager.playButtonClickSound() // Воспроизведение звука при нажатии
                        })
                    }
                    .padding(.top, 100)

                    Spacer()

                    // Нижняя строка с кнопками Rules и Progress
                    HStack(spacing: 20) {
                        // Кнопка Rules
                        NavigationLink(destination: RulesPage()) {
                            Text("Rules")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(
                                    Image("button_frame")
                                        .resizable()
                                        .scaledToFill()
                                )
                                .cornerRadius(10)
                                .font(.system(size: 20))
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            musicManager.playButtonClickSound() // Воспроизведение звука при нажатии
                        })

                        // Кнопка Progress
                        NavigationLink(destination: ProgressPage()) {
                            Text("Progress")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(
                                    Image("button_frame")
                                        .resizable()
                                        .scaledToFill()
                                )
                                .cornerRadius(10)
                                .font(.system(size: 20))
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            musicManager.playButtonClickSound() // Воспроизведение звука при нажатии
                        })
                    }
                    .padding(.bottom, 100)
                }

                // Кнопка настроек в левом верхнем углу
                VStack {
                    HStack {
                        NavigationLink(destination: SettingsPage()) {
                            Image("settings_icon")
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(10)
                                .frame(width: 60, height: 60)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            musicManager.playButtonClickSound() // Воспроизведение звука при нажатии
                        })

                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.leading, 20)
            }
        }
        .onAppear {
            // При загрузке, если музыка включена, начинаем её воспроизведение
            if musicManager.isMusicEnabled {
                musicManager.playMusic()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
