import SwiftUI
import Foundation

// MARK: - 資料模型

// 條
struct Law: Codable, Identifiable {
    let id = UUID()
    let articleNumber: String
    let paragraphs: [Paragraph]
    
    private enum CodingKeys: String, CodingKey {
        case articleNumber, paragraphs
    }
}

// 項
struct Paragraph: Codable, Identifiable {
    let id = UUID()
    let number: String
    let content: String
    let clauses: [Clause]?
    
    private enum CodingKeys: String, CodingKey {
        case number, content, clauses
    }
}

// 款
struct Clause: Codable, Identifiable {
    let id = UUID()
    let number: String
    let content: String
    let subclauses: [Subclause]?
    
    private enum CodingKeys: String, CodingKey {
        case number, content, subclauses
    }
}

// 目
struct Subclause: Codable, Identifiable {
    let id = UUID()
    let number: String
    let content: String
    
    private enum CodingKeys: String, CodingKey {
        case number, content
    }
}

// MARK: - 資料管理器
class LawsManager: ObservableObject {
    @Published var laws: [Law] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadLaws() {
        isLoading = true
        errorMessage = nil
        
        guard let url = Bundle.main.url(
            forResource: "enforcement_rules_of_the_OSHA",
            withExtension: "json"
        ) else {
            errorMessage = "找不到 enforcement_rules_of_the_OSHA.json 檔案"
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedLaws = try JSONDecoder().decode([Law].self, from: data)
            
            DispatchQueue.main.async {
                self.laws = decodedLaws
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "讀取資料失敗: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}

// MARK: - 主要視圖
struct ContentView: View {
    @StateObject private var lawsManager = LawsManager()
    @State private var searchText = ""
    
    // 計算過濾後的法規條文
    var filteredLaws: [Law] {
        if searchText.isEmpty {
            return lawsManager.laws
        } else {
            return lawsManager.laws.filter { law in
                // 搜尋條文編號
                if "第\(law.articleNumber)條".contains(searchText) {
                    return true
                }
                
                // 搜尋段落內容
                return law.paragraphs.contains { paragraph in
                    paragraph.content.contains(searchText) ||
                    (paragraph.clauses?.contains { clause in
                        clause.content.contains(searchText) ||
                        (clause.subclauses?.contains { subclause in
                            subclause.content.contains(searchText)
                        } ?? false)
                    } ?? false)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if lawsManager.isLoading {
                    ProgressView("載入中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = lawsManager.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("重新載入") {
                            lawsManager.loadLaws()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 搜尋框
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("搜尋條文內容...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    // 搜尋結果統計
                    if !searchText.isEmpty {
                        HStack {
                            Text("找到 \(filteredLaws.count) 筆相關條文")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                    
                    // 條文列表
                    if filteredLaws.isEmpty && !searchText.isEmpty {
                        VStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("找不到相關條文")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("請嘗試其他關鍵字")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(filteredLaws) { law in
                            LawView(law: law, searchText: searchText)
                        }
                    }
                }
            }
            //.navigationTitle("法規條文")
            .onAppear {
                lawsManager.loadLaws()
            }
        }
    }
}

// MARK: - 法規條文視圖
struct LawView: View {
    let law: Law
    let searchText: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 條文標題（可點擊的標題列）
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("第 \(law.articleNumber) 條")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            // 展開的內容
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(law.paragraphs) { paragraph in
                        ParagraphView(paragraph: paragraph, searchText: searchText)
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 4)
                .transition(.opacity.combined(with: .slide))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 項視圖
struct ParagraphView: View {
    let paragraph: Paragraph
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 段落內容
            HStack(alignment: .top, spacing: 4) {
                Text(paragraph.number)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(minWidth: 20, alignment: .leading)
                
                HighlightedText(text: paragraph.content, searchText: searchText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // 款項
            if let clauses = paragraph.clauses {
                ForEach(clauses) { clause in
                    ClauseView(clause: clause, searchText: searchText)
                        .padding(.leading, 16)
                }
            }
        }
    }
}

// MARK: - 款項視圖
struct ClauseView: View {
    let clause: Clause
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 款項內容
            HStack(alignment: .top, spacing: 4) {
                Text(clause.number)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HighlightedText(text: clause.content, searchText: searchText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // 子款項
            if let subclauses = clause.subclauses {
                ForEach(subclauses) { subclause in
                    SubclauseView(subclause: subclause, searchText: searchText)
                        .padding(.leading, 20)
                }
            }
        }
    }
}

// MARK: - 子款項視圖
struct SubclauseView: View {
    let subclause: Subclause
    let searchText: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(subclause.number)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HighlightedText(text: subclause.content, searchText: searchText)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - 高亮文字視圖
struct HighlightedText: View {
    let text: String
    let searchText: String
    
    private func buildAttributedString() -> AttributedString {
        var attributedString = AttributedString(text)
        
        guard !searchText.isEmpty else {
            return attributedString
        }
        
        // 找到所有匹配的範圍
        let searchRanges = findRanges(of: searchText, in: text)
        
        // 從後往前處理，避免索引偏移問題
        for range in searchRanges.reversed() {
            let startIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: range.lowerBound)
            let endIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: range.upperBound)
            let attributedRange = startIndex..<endIndex
            
            // 設置高亮樣式
            attributedString[attributedRange].backgroundColor = .yellow
            attributedString[attributedRange].foregroundColor = .black
        }
        
        return attributedString
    }
    
    private func findRanges(of searchText: String, in text: String) -> [Range<Int>] {
        var ranges: [Range<Int>] = []
        var searchStartIndex = text.startIndex
        
        while searchStartIndex < text.endIndex {
            if let range = text.range(of: searchText, options: .caseInsensitive, range: searchStartIndex..<text.endIndex) {
                let lowerBound = text.distance(from: text.startIndex, to: range.lowerBound)
                let upperBound = text.distance(from: text.startIndex, to: range.upperBound)
                ranges.append(lowerBound..<upperBound)
                searchStartIndex = range.upperBound
            } else {
                break
            }
        }
        
        return ranges
    }
    
    var body: some View {
        Text(buildAttributedString())
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}
