import AVFoundation
import SwiftUI

// Это класс MusicManager, который управляет воспроизведением музыки и звуков
class MusicManager: ObservableObject {
    static let shared = MusicManager()  // Singleton для использования одного экземпляра во всем приложении
    @Published var isMusicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicEnabled") // Сохраняем состояние
            if isMusicEnabled {
                playMusic()
            } else {
                stopMusic()
            }
        }
    }
    
    @Published var isButtonSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isButtonSoundEnabled, forKey: "isButtonSoundEnabled") // Сохраняем состояние
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    // Инициализация значений
    init() {
        // Загрузка состояния из UserDefaults при запуске приложения
        self.isMusicEnabled = UserDefaults.standard.bool(forKey: "isMusicEnabled") // По умолчанию - выключено
        self.isButtonSoundEnabled = UserDefaults.standard.bool(forKey: "isButtonSoundEnabled") // По умолчанию - включено
    }
    
    // Функция для воспроизведения музыки в фоне
    func playMusic() {
        if isMusicEnabled, let soundURL = Bundle.main.url(forResource: "audio", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1 // Бесконечное воспроизведение
                audioPlayer?.play()
            } catch {
                print("Ошибка при воспроизведении музыки: \(error.localizedDescription)")
            }
        }
    }

    // Функция для остановки музыки
    func stopMusic() {
        audioPlayer?.stop()
    }

    // Функция для воспроизведения звука при нажатии на кнопки
    func playButtonClickSound() {
        // Проверка, включен ли звук
        if isButtonSoundEnabled, let soundURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.play()
            } catch {
                print("Ошибка при воспроизведении звука кнопки: \(error.localizedDescription)")
            }
        }
    }
}
