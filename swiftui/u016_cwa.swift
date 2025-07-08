import SwiftUI

// MARK: WeatherForecast 資料結構

// 解析 Wx（天氣現象）、PoP（降雨機率）、MinT/MaxT（溫度）、CI（體感）
// 組成 WeatherForecast 結構供畫面顯示
//
// 每個預報區段包含開始與結束時間、天氣描述、圖示、溫度、降雨機率與體感建議
//
//
// descriptionCode:
//
// （資料來自 CWA 的 Wx 說明）
//
// Code    現象說明    emoji
// 1        晴天        ☀️
// 2        晴時多雲     🌤
// 3        多雲時晴     🌤
// 4        多雲        ☁️
// 5        多雲時陰     🌥
// 6        陰天        🌥
// 7        陰時多雲     🌥
// 8~x      各類陣雨/雷雨等    🌧 ⛈ 等
struct WeatherForecast {
    let startTime: String
    let endTime: String
    let description: String
    let descriptionCode: String?    // 對應 parameterValue
    let pop: String
    let popUnit: String?
    let minTemp: String
    let maxTemp: String
    let comfort: String

    var weatherEmoji: String {
        if description.contains("雷") {
            return "⛈"
        } else if description.contains("雨") {
            return "🌧"
        } else if description.contains("雲") {
            return "☁️"
        } else if description.contains("晴") {
            return "☀️"
        } else {
            return "🌈"
        }
    }
}

// MARK: - 中央氣象署 (CWA) API 的 Codable 資料模型

// 這些結構體根據氣象署 API 的 JSON 結構定義，用於 Codable 解碼。
// 這裡僅包含程式碼中會用到的部分，你可以根據需求擴充。
struct CWAWeatherResponse: Decodable {
    let records: CWARecords
}

struct CWARecords: Decodable {
    let location: [CWALocation]
}

struct CWALocation: Decodable {
    let locationName: String
    let weatherElement: [CWAWeatherElement] // 氣象要素陣列
}

struct CWAWeatherElement: Decodable {
    let elementName: String // 例如 "Wx" (天氣現象)
    let time: [CWATime]
}

struct CWATime: Decodable {
    let startTime: String
    let endTime: String
    let parameter: CWAParameter
}

struct CWAParameter: Decodable {
    let parameterName: String
    let parameterValue: String?
    let parameterUnit: String?
}

// MARK: - 天氣視圖模型 (WeatherViewModel)

@MainActor // 確保此 ViewModel 的所有屬性更新與方法執行都在主執行緒
class WeatherViewModel: ObservableObject {
    @Published var weatherForecasts: [WeatherForecast] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    func fetchDomesticWeather(for city: String) async {
        isLoading = true
        errorMessage = ""
        weatherForecasts = []
        
        // 在方法內部取得 API Key
        guard let cwaApiKey = Bundle.main.object(
            forInfoDictionaryKey: "APIKey"
        ) as? String else {
            errorMessage = "無法取得 API Key"
            isLoading = false
            return
        }
        
        print(cwaApiKey)

        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=\(cwaApiKey)&locationName=\(encodedCity)"

        guard let url = URL(string: urlString) else {
            errorMessage = "網址無效，請檢查城市名稱或 API 設定。"
            isLoading = false
            return
        }
        
        print("==== url ===")
        print(url)
        print("==== end of url ===")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                errorMessage = "伺服器錯誤: HTTP \(statusCode)。"
                if let errorBody = String(data: data, encoding: .utf8) {
                    print("API 錯誤內容: \(errorBody)")
                    errorMessage += " 詳情: \(errorBody)"
                }
                isLoading = false
                return
            }

            let decoder = JSONDecoder()
            let cwaResponse = try decoder.decode(CWAWeatherResponse.self, from: data)

            guard let location = cwaResponse.records.location.first else {
                errorMessage = "找不到城市資料"
                isLoading = false
                return
            }

            let elements = Dictionary(
                uniqueKeysWithValues: location.weatherElement.map {
                    element in
                    (element.elementName, element.time)
                })

            print(elements)
            
            let timeCount = elements["Wx"]?.count ?? 0
            
            print("===timeCount===")
            print(timeCount)

            var forecasts: [WeatherForecast] = []

            for index in 0..<timeCount {
                
                // elements["Wx"]?[index]    ❌ 可能 crash
                // let wxTime = elements["Wx"]?[index]
        
                let wxTime = elements["Wx"]?[safe: index]
                
                let popTime = elements["PoP"]?[safe: index]
                let minTTime = elements["MinT"]?[safe: index]
                let maxTTime = elements["MaxT"]?[safe: index]
                let ciTime = elements["CI"]?[safe: index]

                let forecast = WeatherForecast(
                    startTime: wxTime?.startTime ?? "",
                    endTime: wxTime?.endTime ?? "",
                    description: wxTime?.parameter.parameterName ?? "-",
                    descriptionCode: wxTime?.parameter.parameterValue, // 例如 "2"
                    pop: popTime?.parameter.parameterName ?? "-",
                    popUnit: popTime?.parameter.parameterUnit,         // 例如 "百分比"
                    minTemp: minTTime?.parameter.parameterName ?? "-",
                    maxTemp: maxTTime?.parameter.parameterName ?? "-",
                    comfort: ciTime?.parameter.parameterName ?? "-"
                )

                forecasts.append(forecast)
            }

            self.weatherForecasts = forecasts

        } catch {
            if let urlError = error as? URLError {
                errorMessage = "網路錯誤: \(urlError.localizedDescription)"
            } else if error is DecodingError {
                errorMessage = "資料解析失敗。請檢查 API 模型或 JSON 結構。"
                print("解碼錯誤: \(error)")
            } else {
                errorMessage = "載入天氣資料失敗: \(error.localizedDescription)"
            }
        }

        isLoading = false
    }
}

// MARK: ContentView

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var selectedCity: String = "臺北市"

    let taiwanCities = ["臺北市", "新北市", "桃園市", "臺中市", "臺南市", "高雄市","新竹縣"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.blue.opacity(0.3), Color.white]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Picker("選擇城市", selection: $selectedCity) {
                        ForEach(taiwanCities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)

                    Divider()

                    Text("天氣預報 - \(selectedCity)")
                        .font(.title2)
                        .bold()

                    if viewModel.isLoading {
                        ProgressView("載入中...")
                            .font(.title2)
                            .padding()
                    } else if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(viewModel.weatherForecasts, id: \.startTime) { forecast in
                                WeatherCard(forecast: forecast)
                            }
                        }
                       
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("☁️ 天氣小幫手")
            .onAppear {
                // Task { ... } 是 Swift Concurrency 中的一種非同步任務執行方式
                // 不會阻塞 UI 執行緒，可以安全執行非同步下載、API 呼叫等動作
                Task { await fetchWeather() }
            }
            .onChange(of: selectedCity) { _, _ in
                Task { await fetchWeather() }
            }
        }
    }

    // MARK: - 輔助函數：獲取天氣
    @MainActor // 確保此函數在主執行緒上執行，以便安全地與 ViewModel 互動
    func fetchWeather() async {
        // 直接呼叫 ViewModel 的國內天氣獲取方法
        await viewModel.fetchDomesticWeather(for: selectedCity)
    }
}

// MARK: WeatherCard

struct WeatherCard: View {
    
    let forecast: WeatherForecast

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 🕒 顯示時間區間（格式化）
            Text("🕒 \(formatTimeRange(start: forecast.startTime, end: forecast.endTime))")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Text(forecast.weatherEmoji)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 4) {
                    Text(forecast.description)
                        .font(.headline)
                        .lineLimit(2)
                        .truncationMode(.tail)

                    Text("🌡️ \(forecast.minTemp)°C ~ \(forecast.maxTemp)°C")
                        .lineLimit(1)
                    Text("💧 降雨機率：\(forecast.pop) %")
                        .lineLimit(1)
                    Text("🥵 體感：\(forecast.comfort)")
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .frame(minWidth: 380, maxWidth: .infinity) // 寬度撐滿可用空間
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.top, 15)
        .padding(.horizontal, 32)

    }

    // MARK: - 顯示時間區段：07月08日 06:00 - 07月08日 18:00
    func formatTimeRange(start: String, end: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "zh_TW")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM月dd日 HH:mm"

        if let startDate = inputFormatter.date(from: start),
           let endDate = inputFormatter.date(from: end) {
            let startString = outputFormatter.string(from: startDate)
            let endString = outputFormatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "\(start.prefix(16)) - \(end.prefix(16))"
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 預覽提供
#Preview {
    ContentView()
}

