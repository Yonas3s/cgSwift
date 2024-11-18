import SwiftUI
import WebKit

// Обертка для WKWebView
struct WebView: UIViewRepresentable {
    var htmlFileName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Загружаем локальный HTML файл из Bundle
        if let url = Bundle.main.url(forResource: htmlFileName, withExtension: "html") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct RulesPage: View {
    // Для отслеживания состояния навигации и возможности вернуться на предыдущий экран
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                // Вставляем WebView для отображения локального HTML файла
                WebView(htmlFileName: "rules") // Указываем имя HTML файла без расширения
                    .edgesIgnoringSafeArea(.all) // Чтобы WebView заполнил весь экран
            }
            // Скрываем стандартную кнопку "Назад"
            .navigationBarBackButtonHidden(true)
            // Добавляем кастомную кнопку "Назад"
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss() // Закрываем текущую страницу
            }) {
                Image("home_icon") // Используем изображение из ассетов для кнопки
                    .resizable() // Масштабируем изображение
                    .scaledToFit() // Сохраняем пропорции
                    .frame(width: 60, height: 60) // Размер кнопки
                    .padding(10) // Отступы для кнопки
                    .padding(.top, 30)
            })
        }
        .navigationBarHidden(true)
    }
}

struct RulesPage_Previews: PreviewProvider {
    static var previews: some View {
        RulesPage()
    }
}
