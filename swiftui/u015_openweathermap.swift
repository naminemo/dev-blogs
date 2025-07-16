import SwiftUI

// MARK: WeatherResponse

// 頂層結構，包含主要的天氣資訊和天氣描述陣列
struct WeatherResponse: Decodable {
    let main: MainWeather
    let weather: [WeatherDescription]
    let name: String // 城市名稱
}

// MARK: JSON Model

// 主要天氣資訊，例如溫度、濕度
struct MainWeather: Decodable {
    let temp: Double
    let humidity: Int
}

// 天氣描述，例如晴朗、多雲
struct WeatherDescription: Decodable, Identifiable {
    let id: Int
    let main: String // 簡要描述，例如 "Clear", "Clouds"
    let description: String // 詳細描述，例如 "clear sky", "few clouds"
    let icon: String // 天氣圖標代碼
}

// 可能的錯誤模型
struct APIError: Decodable, Error, LocalizedError {
    let cod: String
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

// 在 WeatherService 這個案例中，
// 我們通常希望它能扮演一個服務角色 (Service Role)，
// 處理網路請求的行為 (Behavior)，而不是單純儲存資料。
//
// 1. 共享狀態和單例模式 (Shared State and Singleton Pattern)
//
// 服務的本質：
// WeatherService 是一個執行網路操作的服務。
// 在應用程式中，我們通常只需要一個 WeatherService 的實例來處理所有天氣相關的網路請求。
//
// 參考語義：
// 使用 class 意味著你總是在處理同一個 WeatherService 實例的參考。
// 這使得它非常適合用於共享和管理如底層 URLSession 等資源，而不需要擔心資料被意外複製。
//
// 2. 與 Objective-C 互操作性 (Interoperability with Objective-C)
// 如果未來需要與 Objective-C 程式碼進行互操作，
// 或者使用一些舊的 iOS 框架，class 通常是更好的選擇，
//
// MARK: WeatherService
class WeatherService {
    
    private let apiKey: String
    private let baseURL: String

    // 初始化器來安全地讀取 API 金鑰
    init() {
        // 從 Info.plist 中讀取 API 相關配置
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "OpenWeatherMapAPIKey"
        ) as? String else {
            // 立即終止程式的執行
            // 讓應用程式崩潰 (crash)
            // 把它想成能終止程式的 print
            fatalError("錯誤：未在 Info.plist 中找到 'OpenWeatherMapAPIKey' 或其類型錯誤。")
        }
        
        guard let baseURL = Bundle.main.object(
            forInfoDictionaryKey: "OpenWeatherMapBaseURL"
        ) as? String else {
            // 立即終止程式的執行
            // 讓應用程式崩潰 (crash)
            // 把它想成能終止程式的 print
            fatalError("錯誤：未在 Info.plist 中找到 'OpenWeatherMapBaseURL' 或其類型錯誤。")
        }
        
        self.apiKey = key
        self.baseURL = baseURL
    }
    
    
    
    // async throws：
    //
    // async (非同步)：
    // 這是 Swift 5.5 引入的 async/await 語法糖。
    // 它表示這個操作是非同步的，也就是說，當你的應用程式發送網路請求時，它不會停下來等待資料返回，
    // 而是會繼續執行其他任務。
    // 當資料回來後，程式碼會從 await 的地方繼續執行。
    // 這對於 UI 應用程式非常重要，可以防止網路請求阻塞主執行緒，導致介面卡住。
    //
    // throws (拋出錯誤)：
    // 表示這個方法在執行過程中可能會拋出錯誤。
    // 例如，網路連線失敗、伺服器找不到資源、或接收到的資料無效等。
    // 因此，你需要使用 try await 來呼叫它，並在 do-catch 區塊中處理這些潛在的錯誤。
    func fetchWeather(forCity city: String) async throws -> WeatherResponse {
        
        // 1. 對城市名稱進行 URL 編碼
        // 確保城市名稱中的特殊字元（如空格、中文等）能安全地放入 URL 中
        //
        // addingPercentEncoding 和 withAllowedCharacters: .urlQueryAllowed
        // 是 Swift 中處理 URL 字串時非常重要的兩個部分，它們主要用於URL 編碼。
        //
        // - 保留字元 (Reserved Characters):
        //   有些字元在 URL 中有特殊含義，
        //   例如 ? (查詢參數開始)、& (參數分隔)、/ (路徑分隔)、= (鍵值對) 等等。
        //   如果資料中包含這些字元，但不想讓它們被解釋為特殊含義，就必須對它們進行編碼。
        //
        // - 非法字元 (Unsafe Characters):
        //   有些字元在 URL 中是不允許直接出現的，
        //   例如空格、中文字符、一些符號等。如果直接使用它們，可能會導致 URL 無效或解析錯誤。
        //
        //   URL 編碼的過程就是將這些保留字元和非法字元轉換成一種百分號編碼 (Percent-encoding) 的形式，
        //   例如：
        //   空格 ( ) 會被編碼成 %20
        //   中文字符 你 可能會被編碼成 %E4%BD%A0
        //
        // CharacterSet.urlQueryAllowed 是一個預定義的字元集，
        // 它包含了所有在 URL 查詢參數部分中被允許的字元。
        // 簡單來說，它告訴編碼器：
        // - 保留字元和大多數字母數字字元（a-z, A-Z, 0-9）以及一些常用符號（如 -._~）不需要被編碼，
        // 因為它們在 URL 中是安全的。
        //
        // - 而其他字元，特別是空格、中文字符、以及一些
        // 特殊符號（如 &, =, ?，如果你想讓它們被當作資料而不是 URL 結構的一部分）需要被編碼。
        //
        //
        // 這樣做的原因主要有兩個：
        //
        // 1. 確保 URL 有效和正確解析：
        // 如果用戶輸入的城市名稱是 "New York"，直接拼接到 URL 中會變成 q=New York。
        // 但 URL 中不允許有空格，這會導致 URL 無效。
        // 經過 addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) 處理後，
        // "New York" 會變成 "New%20York"，這樣 URL 就變成了 q=New%20York，
        // 這是一個合法且可被正確解析的 URL。
        // 同樣，如果用戶輸入了 "北京" 或 "Tokyo, Japan"，這些字元或符號也需要被正確編碼。
        //
        // 2. 避免歧義和安全問題：
        // 假設你的城市名稱是 "London&Paris"。
        // 如果沒有編碼，URL 會變成 ?q=London&Paris&appid=...。
        // 這時，API 可能會錯誤地將 "Paris" 識別為一個新的參數，而不是城市名稱的一部分，導致查詢錯誤。
        // 通過編碼，& 會變成 %26，URL 就會是 ?q=London%26Paris&appid=...，
        // 確保 "London&Paris" 被完整地視為一個城市名稱。
        // 這也防止了潛在的 URL 注入攻擊，雖然在這種簡單的查詢中風險較低，但在處理用戶輸入時養成良好習慣非常重要。
        //
        // 總之，addingPercentEncoding 配合 withAllowedCharacters: .urlQueryAllowed
        // 的目的是為了安全、可靠地將用戶輸入或其他動態內容嵌入到 URL 中，避免因為特殊字元而導致 URL 無效或解析錯誤。
        let encodedCityName = city.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed
        ) ?? ""

        // 2. 構建完整的 URL 字串
        // 將基礎 URL、編碼後的城市名稱、API 金鑰和單位組合成一個完整的字串
        let urlString = "\(baseURL)?q=\(encodedCityName)&appid=\(apiKey)&units=metric"

        /*
         https://api.openweathermap.org/data/2.5/weather?q=Taipei&appid={your_api_key}&units=metric
         */
        print(urlString)
        
        // 3. 嘗試將字串轉換為 URL 物件，並處理潛在錯誤
        guard let url = URL(string: urlString) else {
            print("錯誤：無法建立有效的 URL，字串為：\(urlString)")
            throw URLError(.badURL)
        }
        
        print("==3.")
        do {
            // 1. URLSession
            // URLSession 是 Apple 提供的一個強大而靈活的 API，用於處理所有與網路相關的任務。
            // 它負責管理網路請求（例如下載網頁、上傳檔案、與 API 互動），並提供處理驗證、Cookie、緩存以及監控進度等功能。
            //
            // 把它想像成一個網路通信的總管家。你需要跟網路做任何溝通，基本上都會透過它。
            //
            // 2. .shared
            // .shared 是一個單例 (Singleton) 模式的實例。
            //
            // - 單例 (Singleton)：
            //   意思是這個應用程式在執行期間，只會有一個 URLSession.shared 的實例。
            //   它是一個預設配置好的、共用的會話 (session)。
            //
            // - 用途：
            //   對於大多數常見的網路請求（例如你現在做的這種簡單的 API 呼叫），
            //   使用 .shared 非常方便，因為你不需要自己去配置 URLSession 的細節（比如緩存策略、逾時時間等）。
            //   它已經被設定好，可以立即使用。
            //
            // 所以，URLSession.shared 指的就是那個系統為你準備好的、可以立即拿來用的網路總管家。
            //
            //
            // 3. .data(from: url)
            // 這是一個 URLSession 物件上的方法，它用於非同步地從指定的 URL 下載資料。
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 檢查 HTTP 狀態碼
            // 1. 嘗試將 response 轉換為 HTTPURLResponse 類型
            //    因為 response 可能是 URLResponse 的一般類型，我們需要確認它是一個 HTTP 回應
            if let httpResponse = response as? HTTPURLResponse {
                
                // 2. 檢查 HTTP 狀態碼是否在 200 到 299 之間 (表示成功)
                // 如果條件不滿足就立即退出
                guard (200...299).contains(httpResponse.statusCode) else {
                    
                    // HTTP 狀態碼不在成功範圍內 (例如 404 Not Found, 500 Internal Server Error)
                    print("HTTP 錯誤狀態碼: \(httpResponse.statusCode)") // 印出具體的錯誤碼

                    // 嘗試解析 API 回傳的錯誤訊息 (如果有的話)
                    if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("API 回傳錯誤訊息: \(apiError.message)") // 印出 API 提供的錯誤訊息
                        throw apiError // 拋出 API 錯誤
                    } else {
                        // 如果 API 沒有回傳標準的錯誤格式，則拋出一個通用的伺服器錯誤
                        print("無法解析 API 錯誤或非預期伺服器回應。")
                        throw URLError(.badServerResponse)
                    }
                }
            } else {
                // response 無法轉換為 HTTPURLResponse，表示這不是一個標準的 HTTP 回應
                print("接收到非 HTTP 協定回應。")
                throw URLError(.badServerResponse) // 拋出伺服器回應錯誤
            }
            
            // --- 在這裡加入印出原始 JSON 的程式碼 ---
            if let jsonString = String(data: data, encoding: .utf8) {
                print("--- 接收到的原始 JSON 資料 ---")
                print(jsonString)
                print("------------------------------")
            }
            // ------------------------------------------
            
            // 如果以上都沒有拋出錯誤，程式碼會繼續執行到這裡，進行 JSON 解析
            // 將外部的資料格式（例如 JSON、XML 等）轉換成 Swift 中定義的資料型別（例如 struct ）。
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
            
        } catch {
            // 處理錯誤
            if let decodingError = error as? DecodingError {
                print("Decoding error: \(decodingError)")
            }
            throw error // 拋出錯誤
        }
    }
}

// MARK: ViewModel

// 視圖模型 (ViewModel) 來處理邏輯和狀態
class WeatherViewModel: ObservableObject {
    // 使用 @Published 標記你希望在視圖之間共享並能觸發更新的屬性
    // 當我資料有異動時，我會發佈出去
    @Published var weather: WeatherResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    @MainActor // 確保 UI 更新在主執行緒
    func getWeather(forCity city: String) async {
        isLoading = true
        errorMessage = nil // 重置錯誤訊息
        
        do {
            let fetchedWeather = try await weatherService.fetchWeather(forCity: city)
            self.weather = fetchedWeather
        } catch {
            if let apiError = error as? APIError {
                errorMessage = "API 錯誤: \(apiError.message)"
                print(apiError.message)
            } else {
                errorMessage = "載入天氣資料失敗: \(error.localizedDescription)"
                print(error.localizedDescription)
            }
            self.weather = nil // 清除舊的天氣資料
        }
        isLoading = false
        
        
        // @MainActor 是簡潔且現代的作法
        // @MainActor 的作用和 DispatchQueue.main.async 類似，
        // 都是為了確保程式碼在主執行緒上執行。
        // 在 Swift 5.5 引入 async/await 之後，
        // @MainActor 提供了更現代、更簡潔也更安全的處理方式。
        //
        // 在 Swift 的 async/await 語法中，
        // @MainActor 是處理主執行緒操作的推薦方式，
        // 取代了傳統的 DispatchQueue.main.async。
        //
        //
        // 1. @MainActor 的優點
        // - 自動性與簡潔性：
        //   當你將一個 async 函數標記為 @MainActor 時，
        //   整個函數體內的所有程式碼都會被自動安排到主執行緒上執行。
        //   你不需要在每個需要更新 UI 的地方手動添加 DispatchQueue.main.async { ... } 閉包，
        //   這大大減少了冗餘程式碼，並避免了開發者忘記切換執行緒的問題。
        //
        // - 編譯時檢查：
        //   @MainActor 提供了編譯時的執行緒安全性檢查。
        //   如果你的程式碼嘗試在非主執行緒上訪問一個被 @MainActor 隔離的屬性或方法，
        //   編譯器會發出警告或錯誤，幫助你提前發現潛在的執行緒問題。
        //   這比 DispatchQueue.main.async 提供的執行緒安全更高，因為後者是在執行時才生效。
        //
        // - 數據競爭保護：
        //   @MainActor 就像一個鎖，確保被其修飾的程式碼或數據只在主執行緒上被訪問，
        //   從而有效防止了多執行緒讀寫同一個 UI 數據時可能發生的數據競爭 (Data Races) 問題。
        //
        // - 更符合結構化併發：
        //   它與 Swift 的結構化併發模型（Structured Concurrency）無縫整合，
        //   使得非同步程式碼的流動更清晰，錯誤處理也更直接。
        //
        //
        // 2. DispatchQueue.main.async 的限制
        // - 手動與冗餘：
        //   你必須手動將需要回到主執行緒的操作包裹在 DispatchQueue.main.async { ... } 閉包中。
        //   在一個函數裡有多個 UI 更新點時，這會導致很多重複的程式碼。
        //
        // - 無編譯時檢查：
        //   DispatchQueue.main.async 是一種運行時機制。
        //   編譯器無法檢查你是否正確地將所有 UI 相關操作都放在了主執行緒。
        //   如果忘記了，程式碼在非主執行緒上更新 UI，可能導致應用程式不穩定甚至崩潰。
        //
        // - 難以追蹤：
        //   對於複雜的非同步操作鏈，追蹤哪些部分在哪個執行緒上執行可能會變得困難。

                
         
    } // getWeather
    
    /*
    // 如果沒有 @MainActor，類似這樣寫
    func getWeather2(forCity city: String) async {
        // 1. UI 相關的初始化狀態更新：切換到主執行緒
        DispatchQueue.main.async { // 切換到主執行緒
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            // 2. 執行耗時的網路請求：這會自動在"背景執行緒"上執行
            // 因為 weatherService.fetchWeather(forCity:) 是一個 async 函數，
            // 它的執行會被系統安排在一個合適的背景執行緒上，不會阻塞主執行緒。
            let fetchedWeather = try await weatherService.fetchWeather(forCity: city)

            // 3. 網路請求完成後，更新 UI 相關狀態：切換回主執行緒
            DispatchQueue.main.async { // 切換到主執行緒
                self.weather = fetchedWeather
                self.isLoading = false // 確保在主執行緒更新
            }
        } catch {
            // 4. 錯誤處理並更新 UI：切換回主執行緒
            DispatchQueue.main.async { // 切換到主執行緒
                if let apiError = error as? APIError {
                    self.errorMessage = "API 錯誤: \(apiError.message)"
                    print(apiError.message)
                } else {
                    self.errorMessage = "載入天氣資料失敗: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
                self.weather = nil // 清除舊的天氣資料
                self.isLoading = false // 確保在主執行緒更新
            }
        }
    }
     */
}



// MARK: View

struct ContentView: View {
    // 創建 weatherViewModel 的實例，並使用 @StateObject 讓其生命週期與 ContentView 保持一致。
    // @StateObject 會在 ContentView 第一次被建立時初始化，並在 ContentView 運行期間保持存在。
    // 即使 ContentView 結構體本身因為某些原因被重新初始化，
    // @StateObject 會確保其包裝的對象的狀態不會丟失，除非應用程式終止。
    //
    // 它確保了你的 WeatherViewModel 作為一個參考型別，能夠可靠地持有並管理其內部的狀態和邏輯，
    // 並且這個實例的生命週期會與其所屬的 ContentView 的生命週期緊密關聯，
    // 保證狀態不會因為 View 的重建而丟失。
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var cityInput: String = "Taipei" // 預設城市
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("輸入城市名稱", text: $cityInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled() // 關閉自動校正
                
                Button("取得天氣") {
                    Task {
                        await weatherViewModel.getWeather(forCity: cityInput)
                        if let error = weatherViewModel.errorMessage {
                            alertMessage = error
                            showAlert = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                
                if weatherViewModel.isLoading {
                    ProgressView("載入中...")
                } else if let weather = weatherViewModel.weather {
                    WeatherDisplayView(weather: weather)
                } else if let errorMessage = weatherViewModel.errorMessage {
                    Text("錯誤：\(errorMessage)")
                        .foregroundStyle(.red)
                }
                
                Spacer()
            }
            .navigationTitle("天氣預報")
            .alert("錯誤", isPresented: $showAlert) {
                Button("確定") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

// 獨立的視圖來顯示天氣資訊
struct WeatherDisplayView: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(weather.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("溫度: \(weather.main.temp, specifier: "%.1f")°C")
                .font(.title2)
            
            Text("濕度: \(weather.main.humidity)%")
                .font(.title2)
            
            ForEach(weather.weather) { description in
                Text("天氣: \(description.description.capitalized)")
                    .font(.title2)
                // 可以根據 icon 代碼顯示不同的天氣圖標
                // 例如：Image(systemName: "cloud.fill")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
