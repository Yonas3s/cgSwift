import SwiftUI

struct SettingsPage: View {
    // Получаем ссылку на глобальный MusicManager
    @ObservedObject private var musicManager = MusicManager.shared

    // Состояния для переключателей
    @State private var isMusicEnabled = MusicManager.shared.isMusicEnabled
    @State private var isButtonSoundEnabled = MusicManager.shared.isButtonSoundEnabled

    // Для отслеживания положения переключателей
    @State private var firstSwitchOffset: CGFloat = -20 // Изначально слева
    @State private var secondSwitchOffset: CGFloat = 20 // Изначально справа (звук включен)

    // Определим максимальное смещение для активного состояния
    private let switchOffset: CGFloat = 20 // Расстояние, на которое двигается бегунок

    var body: some View {
        ZStack {
            // Фон
            Image("background") // Используйте своё изображение для фона
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Блок с фоном для переключателей
                ZStack {
                    Image("frame") // Замените на ваше изображение для блока
                        .resizable()
                        .scaledToFill()
                        .frame(width: 330, height: 300) // Размер блока
                        .cornerRadius(20) // Радиус скругления углов
                    
                    VStack(spacing: 30) { // Уменьшил отступы между переключателями
                        // Первый переключатель для включения/выключения музыки
                        HStack(spacing: 30) {
                            Image("sound_icon") // Путь до первого изображения
                                .resizable()
                                .frame(width: 60, height: 60)

                            ZStack {
                                Image("switch_frame") // Изображение основания для переключателя
                                    .resizable()
                                    .frame(width: 100, height: 40)

                                Image("switch_button") // Изображение бегунка
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .offset(x: isMusicEnabled ? switchOffset : -switchOffset) // Смещение в зависимости от состояния
                                    .onTapGesture {
                                        // Логика переключения при нажатии
                                        withAnimation {
                                            isMusicEnabled.toggle()
                                            musicManager.isMusicEnabled = isMusicEnabled // Обновляем состояние в MusicManager
                                        }
                                    }
                            }

                            Spacer()
                        }
                        .padding(.leading, 50)

                        // Второй переключатель для включения/выключения звуков кнопок
                        HStack(spacing: 30) {
                            Image("music_icon") // Путь до второго изображения
                                .resizable()
                                .frame(width: 60, height: 60)

                            ZStack {
                                Image("switch_frame") // Изображение основания для переключателя
                                    .resizable()
                                    .frame(width: 100, height: 40)

                                Image("switch_button") // Изображение бегунка
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .offset(x: isButtonSoundEnabled ? switchOffset : -switchOffset) // Смещение для второго переключателя
                                    .onTapGesture {
                                        // Логика переключения при нажатии
                                        withAnimation {
                                            isButtonSoundEnabled.toggle()
                                            musicManager.isButtonSoundEnabled = isButtonSoundEnabled // Обновляем состояние в MusicManager
                                        }
                                    }
                            }

                            Spacer()
                        }
                        .padding(.leading, 50)
                    }
                    .padding(20)
                }
                .frame(width: 330, height: 300)

                Spacer()
            }
        }
        .onAppear {
            // При появлении страницы проверим, нужно ли воспроизводить музыку
            if isMusicEnabled {
                musicManager.playMusic()
            }
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
