import UIKit

// 定義「目」層級的結構體，因為「目」還可以再細分
struct SubparagraphDetail {
    let detailNumber: Int // 例如 1, 2, 3...
    let content: String
}

// 定義「目」層級的結構體
struct Subparagraph {
    let itemNumber: Int // 例如 (一), (二), (三)...
    let content: String? // 有些目可能直接是內容，有些則包含細分
    let details: [SubparagraphDetail]? // 如果「目」有再細分，則儲存在這裡
}

// 定義「款」層級的結構體
struct Clause {
    let clauseNumber: Int // 例如 一, 二, 三...
    let content: String? // 有些款可能直接是內容，有些則包含目
    let subparagraphs: [Subparagraph]? // 如果「款」包含「目」，則儲存在這裡
}

// 定義「項」層級的結構體
struct Section {
    let content: String? // 項的內容
    let clauses: [Clause]? // 如果「項」包含「款」，則儲存在這裡
}

// 定義「條」層級的結構體
struct Article {
    let articleNumber: Int
    let initialContent: String? // 條文開頭的第一段內容 (如果沒有項、款、目)
    let sections: [Section]? // 如果條文包含「項」，則儲存在這裡
    let clauses: [Clause]? // 如果條文沒有「項」，但直接有「款」，則儲存在這裡
}

let regulations: [Article] = [
    // MARK: - 第 15 條
    Article(
        articleNumber: 15,
        initialContent: "本法第十條第一項所稱危害性化學品之清單，指記載化學品名稱、製造商或供應商基本資料、使用及貯存量等項目之清冊或表單。",
        sections: nil,
        clauses: nil
    ),

    // MARK: - 第 16 條
    Article(
        articleNumber: 16,
        initialContent: "本法第十條第一項所稱危害性化學品之安全資料表，指記載化學品名稱、製造商或供應商基本資料、危害特性、緊急處理及危害預防措施等項目之表單。",
        sections: nil,
        clauses: nil
    ),

    // MARK: - 第 17 條
    Article(
        articleNumber: 17,
        initialContent: "本法第十二條第三項所稱作業環境監測，指為掌握勞工作業環境實態與評估勞工暴露狀況，所採取之規劃、採樣、測定、分析及評估。",
        sections: [
            // 第 17 條的「項」：本法第十二條第三項規定應訂定作業環境監測計畫及實施監測之作業場所如下：
            Section(
                content: "本法第十二條第三項規定應訂定作業環境監測計畫及實施監測之作業場所如下：",
                clauses: [
                    // 一、設置有中央管理方式之空氣調節設備之建築物室內作業場所。
                    Clause(clauseNumber: 1, content: "設置有中央管理方式之空氣調節設備之建築物室內作業場所。", subparagraphs: nil),
                    // 二、坑內作業場所。
                    Clause(clauseNumber: 2, content: "坑內作業場所。", subparagraphs: nil),
                    // 三、顯著發生噪音之作業場所。
                    Clause(clauseNumber: 3, content: "顯著發生噪音之作業場所。", subparagraphs: nil),
                    // 四、下列作業場所，經中央主管機關指定者：
                    Clause(
                        clauseNumber: 4,
                        content: "下列作業場所，經中央主管機關指定者：",
                        subparagraphs: [
                            // （一）高溫作業場所。
                            Subparagraph(itemNumber: 1, content: "高溫作業場所。", details: nil),
                            // （二）粉塵作業場所。
                            Subparagraph(itemNumber: 2, content: "粉塵作業場所。", details: nil),
                            // （三）鉛作業場所。
                            Subparagraph(itemNumber: 3, content: "鉛作業場所。", details: nil),
                            // （四）四烷基鉛作業場所。
                            Subparagraph(itemNumber: 4, content: "四烷基鉛作業場所。", details: nil),
                            // （五）有機溶劑作業場所。
                            Subparagraph(itemNumber: 5, content: "有機溶劑作業場所。", details: nil),
                            // （六）特定化學物質作業場所。
                            Subparagraph(itemNumber: 6, content: "特定化學物質作業場所。", details: nil)
                        ]
                    ),
                    // 五、其他經中央主管機關指定公告之作業場所。
                    Clause(clauseNumber: 5, content: "其他經中央主管機關指定公告之作業場所。", subparagraphs: nil)
                ]
            )
        ],
        clauses: nil
    )
]

// 範例：如何取用資料
print("第 17 條的內容：")
if let article17 = regulations.first(where: { $0.articleNumber == 17 }) {
    print(article17.initialContent ?? "")

    if let sections = article17.sections {
        for section in sections {
            print(section.content ?? "")
            if let clauses = section.clauses {
                for clause in clauses {
                    print("  \(clause.clauseNumber). \(clause.content ?? "")")
                    if let subparagraphs = clause.subparagraphs {
                        for subparagraph in subparagraphs {
                            print("    (\(subparagraph.itemNumber)). \(subparagraph.content ?? "")")
                            if let details = subparagraph.details {
                                for detail in details {
                                    print("      \(detail.detailNumber). \(detail.content)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
