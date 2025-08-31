import SwiftUI
import Foundation

// MARK: - 資料模型 (根據實際 JSON 結構修正)
struct CWAResponse: Codable {
    let success: String
    let result: CWAResult?
    let records: CWARecords
}

struct CWAResult: Codable {
    let resource_id: String?
    let fields: [CWAField]?
    
    enum CodingKeys: String, CodingKey {
        case resource_id = "resource_id"
        case fields
    }
}

struct CWAField: Codable {
    let id: String?
    let type: String?
}

struct CWARecords: Codable {
    let locations: [CWALocation]  // 注意：實際 JSON 中是 "Locations" (大寫)
    
    enum CodingKeys: String, CodingKey {
        case locations = "Locations"
    }
}

struct CWALocation: Codable, Identifiable {
    let datasetDescription: String
    let locationsName: String
    let dataid: String
    let location: [CWALocationDetail]
    
    var id: String { dataid }
    
    enum CodingKeys: String, CodingKey {
        case datasetDescription = "DatasetDescription"
        case locationsName = "LocationsName"
        case dataid = "Dataid"
        case location = "Location"
    }
}

struct CWALocationDetail: Codable, Identifiable {
    let locationName: String
    let geocode: String
    let latitude: String
    let longitude: String
    let weatherElement: [CWAWeatherElement]
    
    var id: String { geocode }
    
    enum CodingKeys: String, CodingKey {
        case locationName = "LocationName"
        case geocode = "Geocode"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case weatherElement = "WeatherElement"
    }
}

struct CWAWeatherElement: Codable {
    let elementName: String
    let time: [CWATime]
    
    enum CodingKeys: String, CodingKey {
        case elementName = "ElementName"
        case time = "Time"
    }
}

struct CWATime: Codable {
    let dataTime: String?
    let startTime: String?
    let endTime: String?
    let elementValue: [CWAElementValue]
    
    enum CodingKeys: String, CodingKey {
        case dataTime = "DataTime"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case elementValue = "ElementValue"
    }
}

struct CWAElementValue: Codable {
    let temperature: String?
    let dewPoint: String?
    let apparentTemperature: String?
    let comfortIndex: String?
    let comfortIndexDescription: String?
    let relativeHumidity: String?
    let windDirection: String?
    let windSpeed: String?
    let beaufortScale: String?
    let probabilityOfPrecipitation: String?
    let weather: String?
    let weatherCode: String?
    let weatherDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "Temperature"
        case dewPoint = "DewPoint"
        case apparentTemperature = "ApparentTemperature"
        case comfortIndex = "ComfortIndex"
        case comfortIndexDescription = "ComfortIndexDescription"
        case relativeHumidity = "RelativeHumidity"
        case windDirection = "WindDirection"
        case windSpeed = "WindSpeed"
        case beaufortScale = "BeaufortScale"
        case probabilityOfPrecipitation = "ProbabilityOfPrecipitation"
        case weather = "Weather"
        case weatherCode = "WeatherCode"
        case weatherDescription = "WeatherDescription"
    }
}

// MARK: - 天氣資料處理
struct WeatherData {
    let temperature: String
    let weather: String
    let comfort: String
    let windDirection: String
    let humidity: String
    let rain: String
    let time: String
}

// MARK: - 網路管理器
class WeatherService: ObservableObject {
    @Published var weatherData: [CWALocation] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var currentWeather: WeatherData?
    
    private let apiKey = ""
    
    private func saveJSONToDocuments(data: Data) {
        let fileName = "CWAWeatherData.json"
        
        // 取得 Documents 目錄路徑
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ 無法取得 Documents 路徑")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL, options: [.atomicWrite])
            print("✅ JSON 已儲存至: \(fileURL.path)")
        } catch {
            print("❌ 儲存 JSON 失敗: \(error.localizedDescription)")
        }
    }
    
    func fetchWeatherData() {
        isLoading = true
        errorMessage = ""
        
        guard var urlComponents = URLComponents(string: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-D0047-053") else {
            self.errorMessage = "無效的 URL"
            self.isLoading = false
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "Authorization", value: apiKey),
            URLQueryItem(name: "format", value: "JSON"),
            URLQueryItem(name: "locationName", value: "新竹市")
        ]
        
        guard let url = urlComponents.url else {
            self.errorMessage = "無法建構 URL"
            self.isLoading = false
            return
        }
        
        print("請求 URL: \(url)")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "網路錯誤: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP 狀態碼: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        self.errorMessage = "HTTP 錯誤: \(httpResponse.statusCode)"
                        return
                    }
                }
                
                guard let data = data else {
                    self.errorMessage = "無法取得資料"
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("原始 JSON 資料:")
                    //print(jsonString)
                    print("====================")
                    
                    // 儲存 JSON 到文件
                    self.saveJSONToDocuments(data: data)
                    
                    if jsonString.contains("Resource not found") {
                        self.errorMessage = "API 資源找不到，請檢查 API Key 或端點"
                        return
                    }
                    
                    if jsonString.contains("message") && jsonString.contains("error") {
                        self.errorMessage = "API 錯誤，請檢查 API Key"
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CWAResponse.self, from: data)
                    self.weatherData = result.records.locations
                    self.processWeatherData()
                } catch {
                    self.errorMessage = "資料解析錯誤: \(error.localizedDescription)"
                    print("解析錯誤詳細資訊: \(error)")
                }
            }
        }.resume()
    }
    
    private func processWeatherData() {
        // 找到新竹市的資料
        guard let hcLocation = weatherData.first(where: { $0.locationsName.contains("新竹市") }),
              let eastDistrict = hcLocation.location.first(where: { $0.locationName == "東區" }) else {
            errorMessage = "找不到新竹市東區的天氣資料"
            return
        }
        
        processLocationData(eastDistrict)
    }
    
    private func processLocationData(_ location: CWALocationDetail) {
        // 取得各種天氣元素
        var temperature = "--"
        var weather = "未知"
        var comfort = "適中"
        var windDirection = "微風"
        var humidity = "--%"
        var rain = "--%"
        var time = "--:--"
        
        // 使用台北時間
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定台北時區
        
        print("當前台北時間: \(dateFormatter.string(from: currentDate))")
        
        for element in location.weatherElement {
            var selectedTime: CWATime?
            
            // 根據不同的元素選擇不同的時間選取方法
            if element.elementName == "溫度" {
                // 溫度是每小時資料，優先使用 dataTime
                selectedTime = findClosestHourlyTime(for: element.time, currentDate: currentDate)
            } else {
                // 其他資料可能是每3小時，優先使用 startTime
                selectedTime = findClosest3HourlyTime(for: element.time, currentDate: currentDate)
            }
            
            guard let timeData = selectedTime,
                  let firstValue = timeData.elementValue.first else {
                print("無法取得 \(element.elementName) 的資料")
                continue
            }
            
            switch element.elementName {
            case "溫度":
                // 溫度資料的結構不同，直接從 Temperature 欄位取值
                if let tempValue = firstValue.temperature {
                    temperature = tempValue
                }
                if let dataTime = timeData.dataTime {
                    time = formatTime(dataTime)
                }
                print("溫度資料: \(temperature)°C，時間: \(timeData.dataTime ?? "未知")")
                
            case "天氣現象":
                weather = firstValue.weather ?? "未知"
                print("天氣現象: \(weather)")
                
            case "舒適度指數":
                comfort = firstValue.comfortIndexDescription ?? "適中"
                print("舒適度: \(comfort)")
                
            case "風向":
                windDirection = firstValue.windDirection ?? "微風"
                print("風向: \(windDirection)")
                
            case "相對濕度":
                if let humidityValue = firstValue.relativeHumidity {
                    humidity = humidityValue + "%"
                }
                print("濕度: \(humidity)")
                
            case "3小時降雨機率":
                if let rainValue = firstValue.probabilityOfPrecipitation {
                    rain = rainValue + "%"
                }
                print("降雨機率: \(rain)")
                
            default:
                break
            }
        }
        
        // 如果有天氣預報綜合描述，優先使用
        if let weatherDescElement = location.weatherElement.first(where: { $0.elementName == "天氣預報綜合描述" }) {
            let selectedTime = findClosestTime(for: weatherDescElement.time, currentDate: currentDate, formatter: dateFormatter)
            
            if let timeData = selectedTime,
               let firstValue = timeData.elementValue.first,
               let description = firstValue.weatherDescription {
                
                // 從綜合描述中提取更詳細的資訊
                temperature = extractTemperature(from: description)
                weather = extractWeather(from: description)
                comfort = extractComfort(from: description)
                windDirection = extractWindDirection(from: description)
                humidity = extractHumidity(from: description)
                rain = extractRain(from: description)
                
                if let startTime = timeData.startTime {
                    time = formatTime(startTime)
                }
            }
        }
        
        currentWeather = WeatherData(
            temperature: temperature,
            weather: weather,
            comfort: comfort,
            windDirection: windDirection,
            humidity: humidity,
            rain: rain,
            time: time
        )
        print("✅ 成功設定 currentWeather: \(currentWeather!)")

    }

    // 新增：專門處理每小時資料的方法
    private func findClosestHourlyTime(for times: [CWATime], currentDate: Date) -> CWATime? {
        var closestTime: CWATime?
        var closestDifference: TimeInterval = TimeInterval.greatestFiniteMagnitude
        
        let taipeiFormatter = DateFormatter()
        taipeiFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        taipeiFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        
        for timeData in times {
            guard let timeStr = timeData.dataTime else { continue }
            
            var date: Date?
            let formatters = [
                "yyyy-MM-dd'T'HH:mm:ssZ",
                "yyyy-MM-dd'T'HH:mm:ss'+08:00'",
                "yyyy-MM-dd'T'HH:mm:ss"
            ]
            
            for format in formatters {
                let testFormatter = DateFormatter()
                testFormatter.dateFormat = format
                testFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
                
                if let parsedDate = testFormatter.date(from: timeStr) {
                    date = parsedDate
                    break
                }
            }
            
            guard let parsedDate = date else { continue }
            
            let difference = abs(parsedDate.timeIntervalSince(currentDate))
            
            if difference < closestDifference {
                closestDifference = difference
                closestTime = timeData
            }
        }
        
        return closestTime ?? times.first
    }

    // 新增：專門處理每3小時資料的方法
    private func findClosest3HourlyTime(for times: [CWATime], currentDate: Date) -> CWATime? {
        var closestTime: CWATime?
        var closestDifference: TimeInterval = TimeInterval.greatestFiniteMagnitude
        
        for timeData in times {
            var timeString: String?
            
            if let startTime = timeData.startTime {
                timeString = startTime
            } else if let dataTime = timeData.dataTime {
                timeString = dataTime
            }
            
            guard let timeStr = timeString else { continue }
            
            var date: Date?
            let formatters = [
                "yyyy-MM-dd'T'HH:mm:ssZ",
                "yyyy-MM-dd'T'HH:mm:ss'+08:00'",
                "yyyy-MM-dd'T'HH:mm:ss"
            ]
            
            for format in formatters {
                let testFormatter = DateFormatter()
                testFormatter.dateFormat = format
                testFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
                
                if let parsedDate = testFormatter.date(from: timeStr) {
                    date = parsedDate
                    break
                }
            }
            
            guard let parsedDate = date else { continue }
            
            let difference = abs(parsedDate.timeIntervalSince(currentDate))
            
            if difference < closestDifference {
                closestDifference = difference
                closestTime = timeData
            }
        }
        
        return closestTime ?? times.first
    }
    // 新增：找到最接近當前時間的資料
    private func findClosestTime(for times: [CWATime], currentDate: Date, formatter: DateFormatter) -> CWATime? {
        var closestTime: CWATime?
        var closestDifference: TimeInterval = TimeInterval.greatestFiniteMagnitude
        
        // 建立台北時區的日期格式器
        let taipeiFormatter = DateFormatter()
        taipeiFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        taipeiFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        
        for timeData in times {
            var timeString: String?
            
            // 優先使用 dataTime，如果沒有則使用 startTime
            if let dataTime = timeData.dataTime {
                timeString = dataTime
            } else if let startTime = timeData.startTime {
                timeString = startTime
            }
            
            guard let timeStr = timeString else { continue }
            
            // 解析時間字串
            var date: Date?
            
            // 嘗試不同的日期格式
            let formatters = [
                "yyyy-MM-dd'T'HH:mm:ssZ",
                "yyyy-MM-dd'T'HH:mm:ss'+08:00'",
                "yyyy-MM-dd'T'HH:mm:ss"
            ]
            
            for format in formatters {
                let testFormatter = DateFormatter()
                testFormatter.dateFormat = format
                testFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
                
                if let parsedDate = testFormatter.date(from: timeStr) {
                    date = parsedDate
                    break
                }
            }
            
            guard let parsedDate = date else {
                print("無法解析時間: \(timeStr)")
                continue
            }
            
            //print("解析時間: \(timeStr) -> \(taipeiFormatter.string(from: parsedDate))")
            
            let difference = abs(parsedDate.timeIntervalSince(currentDate))
            
            // 如果這個時間比目前找到的更接近，就更新
            if difference < closestDifference {
                closestDifference = difference
                closestTime = timeData
                print("找到更接近的時間，差距: \(difference/3600) 小時")
            }
        }
        
        // 如果找不到最接近的時間，返回第一個可用的時間
        let result = closestTime ?? times.first
        if let selectedTime = result {
            let timeStr = selectedTime.dataTime ?? selectedTime.startTime ?? "未知"
            print("最終選擇的時間: \(timeStr)")
        }
        
        return result
    }
    // 解析溫度
    private func extractTemperature(from description: String) -> String {
        let regex = try! NSRegularExpression(pattern: "溫度攝氏(\\d+)度")
        let matches = regex.matches(in: description, range: NSRange(description.startIndex..., in: description))
        if let match = matches.first {
            let range = Range(match.range(at: 1), in: description)!
            return String(description[range])
        }
        return "--"
    }
    
    // 解析天氣狀況
    private func extractWeather(from description: String) -> String {
        if description.contains("雷雨") {
            return "雷雨"
        } else if description.contains("陣雨") {
            return "陣雨"
        } else if description.contains("多雲") {
            return "多雲"
        } else if description.contains("晴") {
            return "晴"
        } else if description.contains("陰") {
            return "陰"
        }
        return "未知"
    }
    
    // 解析舒適度
    private func extractComfort(from description: String) -> String {
        if description.contains("舒適") {
            return "舒適"
        } else if description.contains("悶熱") {
            return "悶熱"
        } else if description.contains("涼爽") {
            return "涼爽"
        } else if description.contains("寒冷") {
            return "寒冷"
        }
        return "適中"
    }
    
    // 解析風向
    private func extractWindDirection(from description: String) -> String {
        let windDirections = ["東北風", "東南風", "西北風", "西南風", "偏南風", "偏北風", "偏東風", "偏西風", "東風", "西風", "南風", "北風"]
        for direction in windDirections {
            if description.contains(direction) {
                return direction
            }
        }
        return "微風"
    }
    
    // 解析濕度
    private func extractHumidity(from description: String) -> String {
        let regex = try! NSRegularExpression(pattern: "相對濕度(\\d+)%")
        let matches = regex.matches(in: description, range: NSRange(description.startIndex..., in: description))
        if let match = matches.first {
            let range = Range(match.range(at: 1), in: description)!
            return String(description[range]) + "%"
        }
        
        // 嘗試匹配範圍格式 "相對濕度XX至YY%"
        let rangeRegex = try! NSRegularExpression(pattern: "相對濕度(\\d+)至(\\d+)%")
        let rangeMatches = rangeRegex.matches(in: description, range: NSRange(description.startIndex..., in: description))
        if let match = rangeMatches.first {
            let range1 = Range(match.range(at: 1), in: description)!
            let range2 = Range(match.range(at: 2), in: description)!
            return String(description[range1]) + "-" + String(description[range2]) + "%"
        }
        
        return "--%"
    }
    
    // 解析降雨機率
    private func extractRain(from description: String) -> String {
        let regex = try! NSRegularExpression(pattern: "降雨機率(\\d+)%")
        let matches = regex.matches(in: description, range: NSRange(description.startIndex..., in: description))
        if let match = matches.first {
            let range = Range(match.range(at: 1), in: description)!
            return String(description[range]) + "%"
        }
        return "--%"
    }
    
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: timeString) {
            formatter.dateFormat = "MM/dd HH:mm"
            return formatter.string(from: date)
        }
        
        return timeString
    }
}

// MARK: - 主要 View
struct ContentView: View {
    @StateObject var weatherService = WeatherService()  // 注意這裡不是 private
    @State private var selectedButton = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 頂部地點資訊
                VStack(spacing: 8) {
                    Text("資料更新時間：\(weatherService.currentWeather?.time ?? "--")")

                    Text("新竹市，東區")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                    
                    if weatherService.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    
                    if !weatherService.errorMessage.isEmpty {
                        Text(weatherService.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .frame(height: geometry.size.height * 0.15)
                
                Spacer()
                
                // 中央時間和溫度顯示
                VStack(spacing: 16) {
                    if let weather = weatherService.currentWeather {
                        VStack(spacing: 8) {
                            Text(weather.time)
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            Text("\(weather.temperature)°C")
                                .font(.system(size: 60, weight: .thin))
                                .foregroundColor(.primary)
                        }
                        
                        // 顯示選中的資訊
                        if !selectedButton.isEmpty {
                            VStack(spacing: 8) {
                                Text(selectedButton)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Text(getSelectedInfo(for: selectedButton, weather: weather))
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Text("--:--")
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            Text("--°C")
                                .font(.system(size: 60, weight: .thin))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.5)
                
                Spacer()
                
                // 底部按鈕區域
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        WeatherButton(title: "天氣", isSelected: selectedButton == "天氣") {
                            selectedButton = selectedButton == "天氣" ? "" : "天氣"
                        }
                        
                        WeatherButton(title: "舒適度", isSelected: selectedButton == "舒適度") {
                            selectedButton = selectedButton == "舒適度" ? "" : "舒適度"
                        }
                        
                        WeatherButton(title: "風向", isSelected: selectedButton == "風向") {
                            selectedButton = selectedButton == "風向" ? "" : "風向"
                        }
                    }
                    
                    HStack(spacing: 20) {
                        WeatherButton(title: "濕度", isSelected: selectedButton == "濕度") {
                            selectedButton = selectedButton == "濕度" ? "" : "濕度"
                        }
                        
                        WeatherButton(title: "降雨", isSelected: selectedButton == "降雨") {
                            selectedButton = selectedButton == "降雨" ? "" : "降雨"
                        }
                        
                        WeatherButton(title: "更新", isSelected: false) {
                            weatherService.fetchWeatherData()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            weatherService.fetchWeatherData()
        }
        .refreshable {
            weatherService.fetchWeatherData()
        }
    }
    
    private func getSelectedInfo(for button: String, weather: WeatherData) -> String {
        switch button {
        case "天氣":
            return weather.weather
        case "舒適度":
            return weather.comfort
        case "風向":
            return weather.windDirection
        case "濕度":
            return weather.humidity
        case "降雨":
            return weather.rain
        default:
            return ""
        }
    }
}

// MARK: - 天氣按鈕元件
struct WeatherButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

