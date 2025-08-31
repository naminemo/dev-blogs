import SwiftUI
import UIKit // 為了使用 UIDevice，需要匯入 UIKit

struct ContentView: View {
    
    // 取得裝置的 供應商識別碼 (Identifier for Vendor, IDFV)，並將其轉換為字串。
    // IDFV 是一個在 iOS 和 iPadOS 裝置上獨一無二的字串，但它的獨特性是 以應用程式的供應商 (Vendor) 為範圍。
    // 同一供應商 (也就是同一個 App Store 帳號下的所有 App) 在同一台裝置上，都會得到 相同的 IDFV。
    //
    // IDFV 並不是根據你的 Apple ID 或 App Store 帳號產生，而是根據你的 開發者團隊 ID（Team ID）。
    private var idfvString: String {
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            print("idfv: \(idfv)")
            // idfv: E08AFA96-4122-4645-B6C1-ND1D6FB86412
            // idfv: 12345678-1234-1234-1234-123456789012
            return idfv
        } else {
            return "無法取得 IDFV"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 標題與說明文字
            Text("您的裝置 IDFV 如下：")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // 顯示 IDFV 字串
            Text(idfvString)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6)) // 讓背景帶有灰色，更顯眼
                .cornerRadius(10)
            
            // 小提示
            Text("此識別碼在同一開發者帳號下的 App 中是相同的，移除所有 App 後會重設。")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}

