import SwiftUI

// --- 1. PreferenceKey for Tab Item Frame Info ---
struct TabItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TabItemInfo] = []
    
    static func reduce(value: inout [TabItemInfo], nextValue: () -> [TabItemInfo]) {
        value.append(contentsOf: nextValue())
    }
    
    struct TabItemInfo: Identifiable, Equatable {
        let id: Int // 用於識別是哪個Tab
        let frame: CGRect
    }
}

// --- 2. DynamicCustomShape (No changes needed here as it's already generic) ---
struct DynamicCustomShape: Shape {
    
    let topY: CGFloat = 0
    let cornerRadius: CGFloat = 20 // 用於內部凹陷圓弧的半徑
    
    let selectedTabX: CGFloat
    let selectedTabWidth: CGFloat
    let numberOfTabItem: Int
    
    var quadCurveControlYOffset: CGFloat
    var dipWidth: CGFloat
    
    init(selectedTabX: CGFloat, selectedTabWidth: CGFloat, numberOfTabItem: Int) {
        self.selectedTabX = selectedTabX
        self.selectedTabWidth = selectedTabWidth
        self.numberOfTabItem = numberOfTabItem
        
        self.quadCurveControlYOffset = 0
        self.dipWidth = 0
        
        switch numberOfTabItem {
            case 3:
                self.quadCurveControlYOffset = 50
                self.dipWidth = 140
            case 4:
                self.quadCurveControlYOffset = 50
                self.dipWidth = 140
            case 5:
                self.quadCurveControlYOffset = 50
                self.dipWidth = 140
            default:
                print("Warning: numberOfTabItem is not 3, 4, or 5. Using default values.")
                self.quadCurveControlYOffset = 45
                self.dipWidth = selectedTabWidth * 1.0
        }
    }
    
    // 有用到貝茲曲線
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        let arcCenterY = topY + cornerRadius
        
        let dipLeftX = selectedTabX - dipWidth / 2
        let dipRightX = selectedTabX + dipWidth / 2
        
        let leftArcCenterX = dipLeftX + cornerRadius
        let rightArcCenterX = dipRightX - cornerRadius
        
        let quadCurveControlY = rect.height + quadCurveControlYOffset - 30
        
        // --- 繪製路徑 ---
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: topY))
        path.addLine(to: CGPoint(x: leftArcCenterX - cornerRadius, y: topY))
        
        // 4. 第一個凹陷圓弧
        path.addArc(
            center: CGPoint(x: leftArcCenterX, y: arcCenterY),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(300),
            clockwise: false
        )
        
        let leftArcEndAngleRad = Angle.degrees(300).radians
        let leftArcEndPoint = CGPoint(
            x: leftArcCenterX + cornerRadius * cos(leftArcEndAngleRad),
            y: arcCenterY + cornerRadius * sin(leftArcEndAngleRad)
        )
        
        // 5. 中間凹陷曲線
        let rightArcStartAngleRad = Angle.degrees(240).radians
        let rightArcStartPoint = CGPoint(
            x: rightArcCenterX + cornerRadius * cos(rightArcStartAngleRad),
            y: arcCenterY + cornerRadius * sin(rightArcStartAngleRad)
        )
        
        let quadCurveControlX = (leftArcEndPoint.x + rightArcStartPoint.x) / 2
        let quadCurveControlPoint = CGPoint(x: quadCurveControlX, y: quadCurveControlY)
        
        path.addQuadCurve(to: rightArcStartPoint, control: quadCurveControlPoint)
        
        // 6. 第二個凹陷圓弧
        path.addArc(
            center: CGPoint(x: rightArcCenterX, y: arcCenterY),
            radius: cornerRadius,
            startAngle: .degrees(240),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: width, y: topY))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// --- 3. Refactored CustomTabBarView ---
struct CustomTabBarView<Content: View>: View {
    @Binding var selectedTab: Int // Use Binding to control selected tab from parent
    let tabItems: [(name: String, icon: String)] // Tab item data
    @ViewBuilder let content: Content // Content for each tab
    
    @State private var tabItemInfo: [TabItemPreferenceKey.TabItemInfo] = []
    @State private var selectedTabFrame: CGRect = .zero
    
    init(
        selectedTab: Binding<Int>,
        tabItems: [(name: String, icon: String)],
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self.tabItems = tabItems
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            TabView(selection: $selectedTab) {
                content // Display the content passed from the parent view
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            customTabBar
        }
        .onPreferenceChange(TabItemPreferenceKey.self) { preferences in
            self.tabItemInfo = preferences
            // Update the frame of the selected tab
            if let frame = preferences.first(where: { $0.id == selectedTab })?.frame {
                self.selectedTabFrame = frame
            }
        }
        // This ensures the selectedTabFrame is updated immediately when selectedTab changes
        // especially if selectedTab is changed programmatically from the parent.
        .onChange(of: selectedTab) { oldSecectdTab, newSelectedTab in
            if let frame = tabItemInfo.first(where: { $0.id == newSelectedTab })?.frame {
                self.selectedTabFrame = frame
            }
        }
    }
    
    private var customTabBar: some View {
        GeometryReader { tabBarGeometry in
            ZStack(alignment: .bottom) {
                // Custom background shape
                DynamicCustomShape(
                    selectedTabX: selectedTabFrame.midX - tabBarGeometry.frame(in: .global).minX,
                    selectedTabWidth: selectedTabFrame.width,
                    numberOfTabItem: tabItems.count
                )
                .fill(Color.orange)
                .frame(height: 70)
                .shadow(radius: 5)
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                HStack {
                    ForEach(0..<tabItems.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                            // The onChange modifier for selectedTab will handle updating selectedTabFrame
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: tabItems[index].icon)
                                    .font(.system(size: selectedTab == index ? 30 : 20))
                                    .background(selectedTab == index ?
                                                AnyView(Circle().fill(Color.orange).frame(width: 50, height: 50)) :
                                                    AnyView(EmptyView()))
                                    .offset(y: selectedTab == index ? -26 : 0)
                                    .foregroundStyle(selectedTab == index ? .white : .gray)
                                    .scaleEffect(selectedTab == index ? 1.1 : 1.0)
                                    .animation(.spring(), value: selectedTab)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { itemGeometry in
                                Color.clear.preference(key: TabItemPreferenceKey.self,
                                                       value: [TabItemPreferenceKey.TabItemInfo(id: index, frame: itemGeometry.frame(in: .global))])
                            }
                        )
                    }
                }
                .frame(height: 70)
                .background(Color.clear)
            }
        }
        .frame(height: 70)
    }
}
