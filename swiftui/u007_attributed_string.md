# AttributedString

什麼是 AttributedString？
想像一下你有一段普通的文字，例如 "Hello World"。

如果想讓 "Hello" 是紅色的，"World" 是藍色的，  
或者讓 "Hello" 是粗體字，"World" 是斜體字，普通的 String 就做不到。

這時候，我們就需要 AttributedString

AttributedString 就像一個超級有能力的文字，  
它不僅僅包含文字內容本身，還可以讓你在文字的不同部分應用不同的樣式。

你可以把它想像成一個畫家，他拿到一段文字 (畫布)，  
然後可以在文字的某個字、某個詞或某句話上面 "塗上" 顏色、大小、字體、下劃線等等各種 "顏料" (樣式)。

簡單來說，AttributedString 就是 "可以給文字的特定部分，加上特殊樣式或行為的文字"。

## 範例一 簡單變換樣式

把 "Hello World" 中的 "Hello" 變成紅色粗體，"World" 變成藍色斜體。

```swift
import SwiftUI

struct ContentView: View {
    var styledText: AttributedString {
        var result = AttributedString()

        var helloPart = AttributedString("Hello")
        helloPart.foregroundColor = .red
        helloPart.font = Font.title.bold()
        result += helloPart

        result += AttributedString(" ")

        var worldPart = AttributedString("World")
        // 注意並不是使用 foregroundStyle
        worldPart.foregroundColor = .blue
        worldPart.font = Font.headline.italic()
        result += worldPart

        return result
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("這是普通的文字。")

            Text(styledText)
                .border(Color.green)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-17 13-43-31](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-17%2013-43-31.jpg)


## 範例二 從字串裡面做應用

搜尋字串裡的指定字串做變化

```swift
import SwiftUI

struct ContentView: View {
    
    var styledText: AttributedString {
        var attributedString = AttributedString(
            "這是一段文字，其中包含一個重要的詞彙。"
        )
        
        if let range = attributedString.range(of: "重要的詞彙") {
            attributedString[range].foregroundColor = .green
            attributedString[range].font = .title3.bold()
            attributedString[range].underlineStyle = .single
        }
        
        return attributedString
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(styledText)
                .border(Color.orange)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-17 13-54-56](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-17%2013-54-56.jpg)


## 範例三 把這個 AttributedString 包成通用的 View 元件

```swift
import SwiftUI

/// 一個可高亮關鍵字的文字元件
struct HighlightTextView: View {
    let originalText: String           // 原始文字
    let keyword: String                // 要高亮的關鍵字
    let highlightColor: Color          // 高亮顏色
    let highlightFont: Font            // 高亮字型
    let underline: Bool                // 是否加底線
    
    var body: some View {
        Text(makeAttributedString())
            .border(Color.orange)
    }
    
    private func makeAttributedString() -> AttributedString {
        var attributed = AttributedString(originalText)
        if let range = attributed.range(of: keyword) {
            attributed[range].foregroundColor = highlightColor
            attributed[range].font = highlightFont
            if underline {
                attributed[range].underlineStyle = .single
            }
        }
        return attributed
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HighlightTextView(
                originalText: "這是一段文字，其中包含一個重要的詞彙。",
                keyword: "重要的詞彙",
                highlightColor: .green,
                highlightFont: .title3.bold(),
                underline: true
            )
            
            HighlightTextView(
                originalText: "SwiftUI 是 Apple 推出的 UI 框架。",
                keyword: "SwiftUI",
                highlightColor: .blue,
                highlightFont: .title.bold(),
                underline: false
            )
        }
        .padding()
    }
}
```

![ss 2025-06-17 13-58-45](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-17%2013-58-45.jpg)



## 範例四 加入多個關鍵字功能

```swift
import SwiftUI

/// 高亮文字樣式定義
struct HighlightTextStyle {
    let keyword: String
    let color: Color
    let font: Font
    let underline: Bool
}

/// 可高亮多個關鍵詞的文字元件
struct HighlightTextView: View {
    let originalText: String
    let highlights: [HighlightTextStyle]
    let baseFont: Font
    let baseColor: Color

    var body: some View {
        Text(makeAttributedString())
            .border(Color.orange)
    }

    private func makeAttributedString() -> AttributedString {
        // 將 Swift String 轉為 NSString 以利搜尋
        let nsText = originalText as NSString
        var attributed = AttributedString(originalText)

        // 設定整體文字樣式
        attributed.font = baseFont
        attributed.foregroundColor = baseColor

        for highlight in highlights {
            let keyword = highlight.keyword
            var searchRange = NSRange(location: 0, length: nsText.length)

            while let foundRange = nsText.range(of: keyword, options: [], range: searchRange).toOptional(),
                  let swiftRange = Range(foundRange, in: originalText),
                  let attrRange = Range(swiftRange, in: attributed)
            {
                // 套用樣式
                attributed[attrRange].foregroundColor = highlight.color
                attributed[attrRange].font = highlight.font
                if highlight.underline {
                    attributed[attrRange].underlineStyle = .single
                }

                // 更新搜尋範圍
                let newLocation = foundRange.location + foundRange.length
                searchRange = NSRange(location: newLocation, length: nsText.length - newLocation)
            }
        }

        return attributed
    }
}

extension NSRange {
    /// 將 NSNotFound 結果變成 nil-friendly 型別
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
    }
}

struct ContentView: View {
    var body: some View {
        HighlightTextView(
            originalText: "SwiftUI 是 Apple 推出的 UI 框架，很重要。UI 是使用者介面。",
            highlights: [
                HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .title.bold(), underline: false),
                HighlightTextStyle(keyword: "UI", color: .purple, font: .headline, underline: true),
                HighlightTextStyle(keyword: "重要", color: .red, font: .body.bold(), underline: true)
            ],
            baseFont: .body,
            baseColor: .primary
        )
        .padding()
    }
}

#Preview {
    ContentView()
}
```

## 範例五 加入點擊偵測

```swift
import SwiftUI
import UIKit

struct HighlightTextStyle {
    let keyword: String
    let color: UIColor
    let font: UIFont
    let underline: Bool
    let action: () -> Void
}

struct HighlightTextLabel: UIViewRepresentable {
    let originalText: String
    let highlights: [HighlightTextStyle]
    let font: UIFont
    let textColor: UIColor

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 允許多行
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping // 文字自動換行
        
        // 確保文字可以換行
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        label.addGestureRecognizer(tap)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        context.coordinator.label = uiView
        context.coordinator.text = originalText
        context.coordinator.highlights = highlights

        // 在設定 attributedText 之後再設定 preferredMaxLayoutWidth
        uiView.attributedText = context.coordinator.buildAttributedString()
        
        // 確保在下一個運行循環中設定寬度
        DispatchQueue.main.async {
            if uiView.bounds.width > 0 {
                uiView.preferredMaxLayoutWidth = uiView.bounds.width
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(font: font, textColor: textColor)
    }

    class Coordinator: NSObject {
        var highlights: [HighlightTextStyle] = []
        var label: UILabel?
        var text: String = ""
        var highlightRanges: [NSRange: () -> Void] = [:]

        let font: UIFont
        let textColor: UIColor

        init(font: UIFont, textColor: UIColor) {
            self.font = font
            self.textColor = textColor
        }

        func buildAttributedString() -> NSAttributedString {
            let attributed = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: attributed.length)

            attributed.addAttribute(.font, value: font, range: fullRange)
            attributed.addAttribute(.foregroundColor, value: textColor, range: fullRange)

            highlightRanges.removeAll()

            for style in highlights {
                let nsText = text as NSString
                var searchRange = NSRange(location: 0, length: nsText.length)

                while let found = nsText.range(of: style.keyword, options: [], range: searchRange).toOptional() {
                    attributed.addAttribute(.foregroundColor, value: style.color, range: found)
                    attributed.addAttribute(.font, value: style.font, range: found)
                    if style.underline {
                        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: found)
                    }

                    highlightRanges[found] = style.action

                    let nextLocation = found.location + found.length
                    if nextLocation >= nsText.length { break }
                    searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
                }
            }

            return attributed
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let label = label,
                  let text = label.attributedText else { return }

            let layoutManager = NSLayoutManager()
            let textStorage = NSTextStorage(attributedString: text)
            let textContainer = NSTextContainer(size: label.bounds.size)

            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode

            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            let location = gesture.location(in: label)
            let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            for (range, action) in highlightRanges {
                if NSLocationInRange(index, range) {
                    action()
                    break
                }
            }
        }
    }
}

extension NSRange {
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HighlightTextLabel(
                    originalText: "SwiftUI 是 Apple 推出的 UI 框架，很重要。UI 是使用者介面。SwiftUI 元件很漂亮，可以輕鬆建立美觀的應用程式介面。透過宣告式語法，開發者可以更直觀地描述 UI 的外觀和行為。",
                    highlights: [
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 20), underline: false, action: { print("點了 SwiftUI") }),
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 18), underline: true, action: { print("點了 UI") }),
                        HighlightTextStyle(keyword: "重要", color: .red, font: .systemFont(ofSize: 18, weight: .bold), underline: true, action: { print("點了 重要") })
                    ],
                    font: .systemFont(ofSize: 16),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
                
                // 測試用的第二個文字區塊
                HighlightTextLabel(
                    originalText: "這是一個測試文字，用來驗證自動換行功能是否正常運作。當文字過長時，應該要能夠自動換行顯示。",
                    highlights: [
                        HighlightTextStyle(keyword: "測試", color: .green, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 測試") }),
                        HighlightTextStyle(keyword: "自動換行", color: .orange, font: .systemFont(ofSize: 16, weight: .semibold), underline: true, action: { print("點了 自動換行") })
                    ],
                    font: .systemFont(ofSize: 14),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
```

## 範例六 點擊後能替代文字功能

```swift
import SwiftUI
import UIKit

struct HighlightTextStyle {
    let keyword: String
    let color: UIColor
    let font: UIFont
    let underline: Bool
    let action: () -> Void
    let replacementText: String? // 新增替換文字選項
    
    init(keyword: String, color: UIColor, font: UIFont, underline: Bool, action: @escaping () -> Void, replacementText: String? = nil) {
        self.keyword = keyword
        self.color = color
        self.font = font
        self.underline = underline
        self.action = action
        self.replacementText = replacementText
    }
}

struct HighlightTextLabel: UIViewRepresentable {
    let originalText: String
    let highlights: [HighlightTextStyle]
    let font: UIFont
    let textColor: UIColor
    @State private var currentText: String // 用來追蹤當前文字狀態
    
    init(originalText: String, highlights: [HighlightTextStyle], font: UIFont, textColor: UIColor) {
        self.originalText = originalText
        self.highlights = highlights
        self.font = font
        self.textColor = textColor
        self._currentText = State(initialValue: originalText) // 初始化當前文字
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 允許多行
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping // 文字自動換行
        
        // 確保文字可以換行
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        label.addGestureRecognizer(tap)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        context.coordinator.label = uiView
        context.coordinator.text = currentText // 使用當前文字而不是原始文字
        context.coordinator.highlights = highlights
        context.coordinator.parent = self // 設定父視圖參考

        // 在設定 attributedText 之後再設定 preferredMaxLayoutWidth
        uiView.attributedText = context.coordinator.buildAttributedString()
        
        // 確保在下一個運行循環中設定寬度
        DispatchQueue.main.async {
            if uiView.bounds.width > 0 {
                uiView.preferredMaxLayoutWidth = uiView.bounds.width
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(font: font, textColor: textColor)
    }

    class Coordinator: NSObject {
        var highlights: [HighlightTextStyle] = []
        var label: UILabel?
        var text: String = ""
        var highlightRanges: [NSRange: HighlightTextStyle] = [:] // 改為儲存完整的 HighlightTextStyle
        var parent: HighlightTextLabel? // 父視圖參考

        let font: UIFont
        let textColor: UIColor

        init(font: UIFont, textColor: UIColor) {
            self.font = font
            self.textColor = textColor
        }

        func buildAttributedString() -> NSAttributedString {
            let attributed = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: attributed.length)

            attributed.addAttribute(.font, value: font, range: fullRange)
            attributed.addAttribute(.foregroundColor, value: textColor, range: fullRange)

            highlightRanges.removeAll()

            for style in highlights {
                let nsText = text as NSString
                var searchRange = NSRange(location: 0, length: nsText.length)

                while let found = nsText.range(of: style.keyword, options: [], range: searchRange).toOptional() {
                    attributed.addAttribute(.foregroundColor, value: style.color, range: found)
                    attributed.addAttribute(.font, value: style.font, range: found)
                    if style.underline {
                        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: found)
                    }

                    highlightRanges[found] = style // 儲存完整的 style 而不是只有 action

                    let nextLocation = found.location + found.length
                    if nextLocation >= nsText.length { break }
                    searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
                }
            }

            return attributed
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let label = label,
                  let text = label.attributedText else { return }

            let layoutManager = NSLayoutManager()
            let textStorage = NSTextStorage(attributedString: text)
            let textContainer = NSTextContainer(size: label.bounds.size)

            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode

            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            let location = gesture.location(in: label)
            let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            for (range, style) in highlightRanges {
                if NSLocationInRange(index, range) {
                    // 執行原本的 action
                    style.action()
                    
                    // 如果有替換文字，執行替換
                    if let replacementText = style.replacementText, let parent = parent {
                        let nsText = self.text as NSString
                        let newText = nsText.replacingCharacters(in: range, with: replacementText)
                        
                        // 更新父視圖的狀態
                        DispatchQueue.main.async {
                            parent.currentText = newText
                        }
                    }
                    break
                }
            }
        }
    }
}

extension NSRange {
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HighlightTextLabel(
                    originalText: "SwiftUI 是 Apple 推出的 UI 框架，很重要。UI 是使用者介面。SwiftUI 元件很漂亮，可以輕鬆建立美觀的應用程式介面。透過宣告式語法，開發者可以更直觀地描述 UI 的外觀和行為。",
                    highlights: [
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 20), underline: false, action: { print("點了 SwiftUI") }),
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 18), underline: true, action: { print("點了 UI") }, replacementText: "介面"), // 加入替換文字
                        HighlightTextStyle(keyword: "重要", color: .red, font: .systemFont(ofSize: 18, weight: .bold), underline: true, action: { print("點了 重要") })
                    ],
                    font: .systemFont(ofSize: 16),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
                
                // 測試用的第二個文字區塊
                HighlightTextLabel(
                    originalText: "這是一個測試文字，用來驗證自動換行功能是否正常運作。當文字過長時，應該要能夠自動換行顯示。點擊測試可以替換文字。",
                    highlights: [
                        HighlightTextStyle(keyword: "測試", color: .green, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 測試") }, replacementText: "實驗"), // 測試替換功能
                        HighlightTextStyle(keyword: "自動換行", color: .orange, font: .systemFont(ofSize: 16, weight: .semibold), underline: true, action: { print("點了 自動換行") })
                    ],
                    font: .systemFont(ofSize: 14),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

```


## 範例七 處理關鍵字裡含有關鍵字問題

目前加入高亮功能會有被條件洗掉的情況，  
當條件是另一個條件的子字串會被洗掉  
例如： "SwiftUI" 應該變藍色，但裡面又有 "UI"兩字，就把UI變紫色了

```swift
import SwiftUI
import UIKit

struct HighlightTextStyle {
    let keyword: String
    let color: UIColor
    let font: UIFont
    let underline: Bool
    let action: () -> Void
    let replacementText: String? // 新增替換文字選項
    
    init(keyword: String, color: UIColor, font: UIFont, underline: Bool, action: @escaping () -> Void, replacementText: String? = nil) {
        self.keyword = keyword
        self.color = color
        self.font = font
        self.underline = underline
        self.action = action
        self.replacementText = replacementText
    }
}

struct HighlightTextLabel: UIViewRepresentable {
    let originalText: String
    let highlights: [HighlightTextStyle]
    let font: UIFont
    let textColor: UIColor
    @State private var currentText: String // 用來追蹤當前文字狀態
    
    init(originalText: String, highlights: [HighlightTextStyle], font: UIFont, textColor: UIColor) {
        self.originalText = originalText
        self.highlights = highlights
        self.font = font
        self.textColor = textColor
        self._currentText = State(initialValue: originalText) // 初始化當前文字
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 允許多行
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping // 文字自動換行
        
        // 確保文字可以換行
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        label.addGestureRecognizer(tap)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        context.coordinator.label = uiView
        context.coordinator.text = currentText // 使用當前文字而不是原始文字
        context.coordinator.highlights = highlights
        context.coordinator.parent = self // 設定父視圖參考

        // 在設定 attributedText 之後再設定 preferredMaxLayoutWidth
        uiView.attributedText = context.coordinator.buildAttributedString()
        
        // 確保在下一個運行循環中設定寬度
        DispatchQueue.main.async {
            if uiView.bounds.width > 0 {
                uiView.preferredMaxLayoutWidth = uiView.bounds.width
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(font: font, textColor: textColor)
    }

    class Coordinator: NSObject {
        var highlights: [HighlightTextStyle] = []
        var label: UILabel?
        var text: String = ""
        var highlightRanges: [NSRange: HighlightTextStyle] = [:] // 改為儲存完整的 HighlightTextStyle
        var parent: HighlightTextLabel? // 父視圖參考

        let font: UIFont
        let textColor: UIColor

        init(font: UIFont, textColor: UIColor) {
            self.font = font
            self.textColor = textColor
        }

        func buildAttributedString() -> NSAttributedString {
            let attributed = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: attributed.length)

            attributed.addAttribute(.font, value: font, range: fullRange)
            attributed.addAttribute(.foregroundColor, value: textColor, range: fullRange)

            highlightRanges.removeAll()
            
            // 按照關鍵字長度排序，從長到短處理（避免短字串覆蓋長字串）
            let sortedHighlights = highlights.sorted { $0.keyword.count > $1.keyword.count }
            
            // 記錄已經處理過的範圍，避免重複處理
            var processedRanges: [NSRange] = []

            for style in sortedHighlights {
                let nsText = text as NSString
                var searchRange = NSRange(location: 0, length: nsText.length)

                while let found = nsText.range(of: style.keyword, options: [], range: searchRange).toOptional() {
                    
                    // 檢查這個範圍是否已經被處理過
                    let shouldProcess = !processedRanges.contains { processedRange in
                        // 如果新範圍完全包含在已處理範圍內，或者有重疊，就跳過
                        return NSLocationInRange(found.location, processedRange) ||
                               NSLocationInRange(found.location + found.length - 1, processedRange) ||
                               NSLocationInRange(processedRange.location, found) ||
                               NSLocationInRange(processedRange.location + processedRange.length - 1, found)
                    }
                    
                    if shouldProcess {
                        attributed.addAttribute(.foregroundColor, value: style.color, range: found)
                        attributed.addAttribute(.font, value: style.font, range: found)
                        if style.underline {
                            attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: found)
                        }

                        highlightRanges[found] = style
                        processedRanges.append(found) // 記錄已處理的範圍
                    }

                    let nextLocation = found.location + found.length
                    if nextLocation >= nsText.length { break }
                    searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
                }
            }

            return attributed
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let label = label,
                  let text = label.attributedText else { return }

            let layoutManager = NSLayoutManager()
            let textStorage = NSTextStorage(attributedString: text)
            let textContainer = NSTextContainer(size: label.bounds.size)

            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode

            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            let location = gesture.location(in: label)
            let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            for (range, style) in highlightRanges {
                if NSLocationInRange(index, range) {
                    // 執行原本的 action
                    style.action()
                    
                    // 如果有替換文字，執行替換
                    if let replacementText = style.replacementText, let parent = parent {
                        let nsText = self.text as NSString
                        let newText = nsText.replacingCharacters(in: range, with: replacementText)
                        
                        // 更新父視圖的狀態
                        DispatchQueue.main.async {
                            parent.currentText = newText
                        }
                    }
                    break
                }
            }
        }
    }
}

extension NSRange {
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HighlightTextLabel(
                    originalText: "SwiftUI 是 Apple 推出的 UI 框架，很重要。UI 是使用者介面。SwiftUI 元件很漂亮，可以輕鬆建立美觀的應用程式介面。透過宣告式語法，開發者可以更直觀地描述 UI 的外觀和行為。",
                    highlights: [
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 18), underline: true, action: { print("點了 UI") }, replacementText: "介面"), // 短字串
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 20), underline: false, action: { print("點了 SwiftUI") }), // 長字串，會優先處理
                        HighlightTextStyle(keyword: "重要", color: .red, font: .systemFont(ofSize: 18, weight: .bold), underline: true, action: { print("點了 重要") })
                    ],
                    font: .systemFont(ofSize: 16),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
                
                // 測試用的第二個文字區塊 - 測試重疊關鍵字處理
                HighlightTextLabel(
                    originalText: "這是一個測試文字，用來驗證自動換行功能是否正常運作。當文字過長時，應該要能夠自動換行顯示。點擊測試可以替換文字。測試重疊：SwiftUI包含UI。",
                    highlights: [
                        HighlightTextStyle(keyword: "測試文字", color: .orange, font: .boldSystemFont(ofSize: 16), underline: true, action: { print("點了 測試文字") }), // 長字串
                        HighlightTextStyle(keyword: "測試", color: .green, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 測試") }, replacementText: "實驗"), // 短字串，但會被長字串優先處理
                        HighlightTextStyle(keyword: "自動換行", color: .orange, font: .systemFont(ofSize: 16, weight: .semibold), underline: true, action: { print("點了 自動換行") }),
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 SwiftUI") }), // 測試重疊
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 16), underline: true, action: { print("點了 UI") }) // 會被 SwiftUI 優先處理
                    ],
                    font: .systemFont(ofSize: 14),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 確保填滿可用寬度
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
```

### 主要改進

#### 按長度排序

```swift
let sortedHighlights = highlights.sorted { $0.keyword.count > $1.keyword.count }
```

- 先處理字數多的關鍵字，如 "SwiftUI"
- 再處理字數少的關鍵字，如 "UI"

#### 範圍衝突檢測

```swift
var processedRanges: [NSRange] = []
```

- 記錄已經處理過的文字範圍
- 檢查新範圍是否與已處理範圍重疊
- 如果重疊就跳過，避免覆蓋


#### 重疊檢測邏輯

檢查新範圍的開始或結束位置是否在已處理範圍內
檢查已處理範圍的開始或結束位置是否在新範圍內
任何一種情況都視為重疊



### 測試案例

#### "SwiftUI" vs "UI"：

- "SwiftUI" 會完整顯示為藍色
- 獨立的 "UI" 會顯示為紫色


#### "測試文字" vs "測試"：

- "測試文字" 會完整顯示為橙色
- 其他獨立的 "測試" 會顯示為綠色



### 運作原理

- 系統會先找到 "SwiftUI" 並標記為藍色
- 當系統試圖處理 "UI" 時，發現這個範圍已經被 "SwiftUI" 佔用了
- 因此跳過 "SwiftUI" 內的 "UI"，只處理其他獨立的 "UI"


## 那如優先處理短字串呢？

把含有 UI 的全部變成紫色的了，再遇到 SwiftUI 再把它變成藍色不行嗎

### 為什麼先處理短字串會有問題

1. NSAttributedString 的屬性覆蓋機制

- 當同一個範圍被設定多次屬性時，後設定的會覆蓋前面的
- 但問題在於範圍不是完全重疊的


2. 範圍重疊的複雜性
```swift
// 範圍重疊的複雜性
原文：「SwiftUI 很棒」

如果先處理 "UI"：
- "UI" 範圍：[5, 7) // 設為紫色

再處理 "SwiftUI"：
- "SwiftUI" 範圍：[0, 7) // 設為藍色
```

3. 點擊事件的衝突

```swift
- 如果先處理 "UI"，highlightRanges 會記錄 [5,7) // UI 的 action
- 再處理 "SwiftUI"，highlightRanges 會記錄 [0,7) // SwiftUI 的 action
- 當用戶點擊 "UI" 部分時，系統需要決定執行哪個action
```

```swift
import SwiftUI
import UIKit

struct HighlightTextStyle {
    let keyword: String
    let color: UIColor
    let font: UIFont
    let underline: Bool
    let action: () -> Void
    let replacementText: String? // 新增替換文字選項
    
    init(keyword: String, color: UIColor, font: UIFont, underline: Bool, action: @escaping () -> Void, replacementText: String? = nil) {
        self.keyword = keyword
        self.color = color
        self.font = font
        self.underline = underline
        self.action = action
        self.replacementText = replacementText
    }
}

struct HighlightTextLabel: UIViewRepresentable {
    let originalText: String
    let highlights: [HighlightTextStyle]
    let font: UIFont
    let textColor: UIColor
    @State private var currentText: String // 用來追蹤當前文字狀態
    
    init(originalText: String, highlights: [HighlightTextStyle], font: UIFont, textColor: UIColor) {
        self.originalText = originalText
        self.highlights = highlights
        self.font = font
        self.textColor = textColor
        self._currentText = State(initialValue: originalText) // 初始化當前文字
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 允許多行
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping // 文字自動換行
        
        // 🔧 確保文字可以換行
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        label.addGestureRecognizer(tap)
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        context.coordinator.label = uiView
        context.coordinator.text = currentText // 🔧 使用當前文字而不是原始文字
        context.coordinator.highlights = highlights
        context.coordinator.parent = self // 設定父視圖參考

        // 🔧 在設定 attributedText 之後再設定 preferredMaxLayoutWidth
        uiView.attributedText = context.coordinator.buildAttributedString()
        
        // 🔧 確保在下一個運行循環中設定寬度
        DispatchQueue.main.async {
            if uiView.bounds.width > 0 {
                uiView.preferredMaxLayoutWidth = uiView.bounds.width
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(font: font, textColor: textColor)
    }

    class Coordinator: NSObject {
        var highlights: [HighlightTextStyle] = []
        var label: UILabel?
        var text: String = ""
        var highlightRanges: [NSRange: HighlightTextStyle] = [:] // 🔧 改為儲存完整的 HighlightTextStyle
        var parent: HighlightTextLabel? // 父視圖參考

        let font: UIFont
        let textColor: UIColor

        init(font: UIFont, textColor: UIColor) {
            self.font = font
            self.textColor = textColor
        }

        func buildAttributedString() -> NSAttributedString {
            let attributed = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: attributed.length)

            attributed.addAttribute(.font, value: font, range: fullRange)
            attributed.addAttribute(.foregroundColor, value: textColor, range: fullRange)

            highlightRanges.removeAll()
            
            // 🔄 改為先處理字數少的，再處理字數多的
            let sortedHighlights = highlights.sorted { $0.keyword.count < $1.keyword.count }
            
            // 用來追蹤每個位置的處理優先級（字數越多優先級越高）
            var positionPriorities: [Int: Int] = [:] // [位置: 優先級]

            for style in sortedHighlights {
                let nsText = text as NSString
                var searchRange = NSRange(location: 0, length: nsText.length)
                let currentPriority = style.keyword.count // 字數越多優先級越高

                while let found = nsText.range(of: style.keyword, options: [], range: searchRange).toOptional() {
                    
                    // 檢查這個範圍是否應該被處理（優先級比較）
                    var shouldProcess = true
                    for position in found.location..<(found.location + found.length) {
                        if let existingPriority = positionPriorities[position],
                           existingPriority >= currentPriority {
                            shouldProcess = false
                            break
                        }
                    }
                    
                    if shouldProcess {
                        // 先清除這個範圍內已有的屬性設定
                        for position in found.location..<(found.location + found.length) {
                            positionPriorities[position] = currentPriority
                        }
                        
                        attributed.addAttribute(.foregroundColor, value: style.color, range: found)
                        attributed.addAttribute(.font, value: style.font, range: found)
                        if style.underline {
                            attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: found)
                        }

                        // 對於點擊事件，使用優先級較高的（字數多的）
                        let existingStyle = highlightRanges.first { (range, _) in
                            // 檢查是否有重疊的範圍
                            return !(range.location + range.length <= found.location ||
                                   found.location + found.length <= range.location)
                        }
                        
                        if let (existingRange, existingStyleValue) = existingStyle {
                            // 如果新的優先級更高，替換掉舊的
                            if currentPriority > existingStyleValue.keyword.count {
                                highlightRanges.removeValue(forKey: existingRange)
                                highlightRanges[found] = style
                            }
                        } else {
                            highlightRanges[found] = style
                        }
                    }

                    let nextLocation = found.location + found.length
                    if nextLocation >= nsText.length { break }
                    searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
                }
            }

            return attributed
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let label = label,
                  let text = label.attributedText else { return }

            let layoutManager = NSLayoutManager()
            let textStorage = NSTextStorage(attributedString: text)
            let textContainer = NSTextContainer(size: label.bounds.size)

            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode

            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            let location = gesture.location(in: label)
            let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            for (range, style) in highlightRanges {
                if NSLocationInRange(index, range) {
                    // 執行原本的 action
                    style.action()
                    
                    // 如果有替換文字，執行替換
                    if let replacementText = style.replacementText, let parent = parent {
                        let nsText = self.text as NSString
                        let newText = nsText.replacingCharacters(in: range, with: replacementText)
                        
                        // 更新父視圖的狀態
                        DispatchQueue.main.async {
                            parent.currentText = newText
                        }
                    }
                    break
                }
            }
        }
    }
}

extension NSRange {
    func toOptional() -> NSRange? {
        return self.location != NSNotFound ? self : nil
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HighlightTextLabel(
                    originalText: "SwiftUI 是 Apple 推出的 UI 框架，很重要。UI 是使用者介面。SwiftUI 元件很漂亮，可以輕鬆建立美觀的應用程式介面。透過宣告式語法，開發者可以更直觀地描述 UI 的外觀和行為。",
                    highlights: [
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 18), underline: true, action: { print("點了 UI") }, replacementText: "介面"), // 短字串
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 20), underline: false, action: { print("點了 SwiftUI") }), // 長字串，會優先處理
                        HighlightTextStyle(keyword: "重要", color: .red, font: .systemFont(ofSize: 18, weight: .bold), underline: true, action: { print("點了 重要") })
                    ],
                    font: .systemFont(ofSize: 16),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 🔧 確保填滿可用寬度
                
                // 測試用的第二個文字區塊 - 測試重疊關鍵字處理
                HighlightTextLabel(
                    originalText: "這是一個測試文字，用來驗證自動換行功能是否正常運作。當文字過長時，應該要能夠自動換行顯示。點擊測試可以替換文字。測試重疊：SwiftUI包含UI。",
                    highlights: [
                        HighlightTextStyle(keyword: "測試文字", color: .orange, font: .boldSystemFont(ofSize: 16), underline: true, action: { print("點了 測試文字") }), // 長字串
                        HighlightTextStyle(keyword: "測試", color: .green, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 測試") }, replacementText: "實驗"), // 短字串，但會被長字串優先處理
                        HighlightTextStyle(keyword: "自動換行", color: .orange, font: .systemFont(ofSize: 16, weight: .semibold), underline: true, action: { print("點了 自動換行") }),
                        HighlightTextStyle(keyword: "SwiftUI", color: .blue, font: .boldSystemFont(ofSize: 16), underline: false, action: { print("點了 SwiftUI") }), // 測試重疊
                        HighlightTextStyle(keyword: "UI", color: .purple, font: .italicSystemFont(ofSize: 16), underline: true, action: { print("點了 UI") }) // 會被 SwiftUI 優先處理
                    ],
                    font: .systemFont(ofSize: 14),
                    textColor: .label
                )
                .frame(maxWidth: .infinity, alignment: .leading) // 🔧 確保填滿可用寬度
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
```

總結先處理短字串會遇到的問題

1. 複雜的優先級管理

- 需要追蹤每個字符位置的優先級
- 需要複雜的邏輯來決定是否覆蓋已有的樣式


2. 點擊事件衝突

- 當 "SwiftUI" 覆蓋 "UI" 時，點擊事件範圍會重疊
- 需要額外邏輯來決定執行哪個動作


3. 效能考量

- 需要對每個字符位置進行優先級檢查
- 比直接跳過重疊範圍更耗資源



## 超連結

```swift
import SwiftUI

struct ContentView: View {
    
    let linkText: AttributedString = {
        var attributedLink = AttributedString("訪問我的網站")
        attributedLink.link = URL(string: "https://www.apple.com")
        attributedLink.foregroundColor = .blue
        attributedLink.underlineStyle = .single
        return attributedLink
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(linkText)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```