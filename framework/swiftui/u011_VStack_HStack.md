# 使用 VStack 和 HStack 排版

```swift

import SwiftUI

struct ContentView: View {
    // MARK: - Layout Constants
    let mainSectionSpacing: CGFloat = 20.0     // 主要區塊間距（例如：勞動場所、工作場所之間）
    let primaryListSpacing: CGFloat = 6.0      // 第一層列表項目間距（例如：1. 和 一、之間）
    let secondaryListSpacing: CGFloat = 5.0    // 第二層列表項目間距（例如：一、 和 二、之間）
    let tertiaryListSpacing: CGFloat = 3.0     // 最深層列表項目間距（例如：(一) 和 (二) 之間）
    
    let primaryLeadingPadding: CGFloat = 25.0  // 第一層列表的左側縮排（例如：一、二、三 的縮排）
    let secondaryLeadingPadding: CGFloat = 40.0 // 第二層列表的左側縮排（例如：(一)、(二)、(三) 的縮排）
    let trailingPaddingForBullet: CGFloat = 0.0 // 項目編號後方的間距（例如：1 後面、一、 後面、(一) 後面）
    
    let hStackItemSpacing: CGFloat = 0.0       // HStack 內項目間距 (通常用於編號與文字之間)
    let bulletFixedWidth: CGFloat = 25.0       // 條：數字編號 (如 "1 ") 的固定寬度，應該要等於 primaryLeadingPadding 的值
    
    let listItemBulletFixedWidth: CGFloat = 40.0   // 列表編號 (如 "一、", "（一）") 的固定寬度，應該要等於 secondaryLeadingPadding 的值
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: mainSectionSpacing) {
                // MARK: - 勞動場所 (Labor Place)
                // 項
                VStack(alignment: .leading, spacing: primaryListSpacing) {
                    HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                        Text("1 ")
                            .font(.body)
                            .frame(width: bulletFixedWidth) // 使用 bulletFixedWidth
                            .padding(.trailing, trailingPaddingForBullet)
                            .border(.red)
                        
                        Text("本法第二條第五款、第三十六條第一項及第三十七條第二項所稱**勞動場所**，包括下列場所：")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .border(.indigo)
                    }
                    
                    // 款冠以一、二、三等數字
                    VStack(alignment: .leading, spacing: secondaryListSpacing) {
                        HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                            Text("一、")
                                .frame(width: listItemBulletFixedWidth, alignment: .leading)
                                .padding(.trailing, trailingPaddingForBullet)
                                .border(.yellow)
                            /*
                            Text("一、")
                                .frame(width: 40)
                                .padding(.trailing, trailingPaddingForBullet)
                             */
                            Text("於勞動契約存續中，由雇主所提示，使勞工履行契約提供勞務之場所。")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .border(.green)
                        }
                        
                        // 目冠以（一）、（二）、（三）等數字，並應加具標點符號。
                        VStack(alignment: .leading, spacing: tertiaryListSpacing) {
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（一）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("高溫作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .border(.blue)
                            
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（二）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("粉塵作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（三）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("鉛作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.leading, secondaryLeadingPadding)
                        
                        HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                            Text("二、")
                                .frame(width: listItemBulletFixedWidth, alignment: .leading)
                                .padding(.trailing, trailingPaddingForBullet)
                            Text("自營作業者實際從事勞動之場所。")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                            Text("三、")
                                .frame(width: listItemBulletFixedWidth, alignment: .leading)
                                .padding(.trailing, trailingPaddingForBullet)
                            Text("其他受工作場所負責人指揮或監督從事勞動之人員，實際從事勞動之場所。")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.leading, primaryLeadingPadding)
                }
                
                // MARK: - 工作場所 (Work Place)
                VStack(alignment: .leading, spacing: primaryListSpacing) {
                    HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                        Text("2 ")
                            .frame(width: bulletFixedWidth) // 使用 bulletFixedWidth
                            .padding(.trailing, trailingPaddingForBullet)
                        
                        Text("本法第十五條第一項、第十七條、第十八條第一項、第二十三條第二項、第二十七條第一項、第三十七條第一項、第三項、第三十八條及第五十一條第二項所稱**工作場所**，指勞動場所中，接受雇主或代理雇主指示處理有關勞工事務之人所能支配、管理之場所。")
                            .font(.body)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .border(.indigo)
                    }
                    
                    VStack(alignment: .leading, spacing: secondaryListSpacing) {
                        HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                            Text("一、")
                                .frame(width: listItemBulletFixedWidth, alignment: .leading)
                                .padding(.trailing, trailingPaddingForBullet)
                            Text("於勞動契約存續中，由雇主所提示，使勞工履行契約提供勞務之場所。")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        VStack(alignment: .leading, spacing: tertiaryListSpacing) {
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（一）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("高溫作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（二）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("粉塵作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                                Text("（三）")
                                    .padding(.trailing, trailingPaddingForBullet)
                                Text("鉛作業場所。")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.leading, secondaryLeadingPadding)
                        
                        HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                            Text("二、")
                                .frame(width: listItemBulletFixedWidth, alignment: .leading)
                                .padding(.trailing, trailingPaddingForBullet)
                            Text("自營作業者實際從事勞動之場所。")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.leading, primaryLeadingPadding)
                }
                
                // MARK: - 作業場所 (Operation Place)
                VStack(alignment: .leading, spacing: primaryListSpacing) {
                    HStack(alignment: .top, spacing: hStackItemSpacing) { // 使用 hStackItemSpacing
                        Text("3 ")
                            .frame(width: bulletFixedWidth) // 使用 bulletFixedWidth
                            .padding(.trailing, trailingPaddingForBullet)
                        
                        Text("本法第六條第一項第五款、第十二條第一項、第三項、第五項、第二十一條第一項及第二十九條第三項所稱**作業場所**，指工作場所中，從事特定工作目的之場所。")
                            .font(.body)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }                
            }
            .padding() // Overall padding for the content
        }
        .navigationTitle("場所定義")
    }
}

#Preview {
    ContentView()
}
```

![ss 2025-06-24 14-01-34](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-06-24%2014-01-34.jpg)
