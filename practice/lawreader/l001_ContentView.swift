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
    
    var body: some View {
        NavigationStack {
            VStack {
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
                    List(lawsManager.laws) { law in
                        LawView(law: law)
                    }
                }
            }
            .navigationTitle("職業安全衛生法施行細則")
            .onAppear {
                lawsManager.loadLaws()
            }
        }
    }
}

// MARK: - 法規條文視圖
struct LawView: View {
    let law: Law
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 條文標題
            Text("第 \(law.articleNumber) 條")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 段落
            ForEach(law.paragraphs) { paragraph in
                ParagraphView(paragraph: paragraph)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 項視圖
struct ParagraphView: View {
    let paragraph: Paragraph
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 段落內容
            HStack(alignment: .top, spacing: 4) {
                //if !paragraph.number.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(paragraph.number)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                //}
                
                Text(paragraph.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // 款項
            if let clauses = paragraph.clauses {
                ForEach(clauses) { clause in
                    ClauseView(clause: clause)
                        .padding(.leading, 16)
                }
            }
        }
    }
}

// MARK: - 款視圖
struct ClauseView: View {
    let clause: Clause
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 款項內容
            HStack(alignment: .top, spacing: 4) {
                Text(clause.number)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(clause.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // 子款項
            if let subclauses = clause.subclauses {
                ForEach(subclauses) { subclause in
                    SubclauseView(subclause: subclause)
                        .padding(.leading, 20)
                }
            }
        }
    }
}

// MARK: - 目, 子款項視圖
struct SubclauseView: View {
    let subclause: Subclause
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(subclause.number)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(subclause.content)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}



// MARK: - 預覽
#Preview {
    ContentView()
}
