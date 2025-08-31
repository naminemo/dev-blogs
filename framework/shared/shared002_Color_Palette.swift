import SwiftUI

// 可命為為 ColorPaletteView
// 色彩列舉
struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            // . 使用 if 判斷
            if colorScheme == .dark {
                
                Text("目前是深色模式")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black)
                
            } else if colorScheme == .light {
                
                Text("目前是淺色模式")
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.white)
                
            } else {
                
                Text("無法判斷目前是哪個模式")
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.blue)
            }
       
        
        
        HStack {
            
            ColorView()
            /*
            VStack {
                
                Text(".red ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.red)
                
                Text(".yellow ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.yellow)
                
                Text(".blue ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.blue)
                
                Text(".green ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.green)
                
                Text(".orange ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.orange)
                
                Text(".black ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.black)
                
                Text(".white ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.white)
                
                Text(".clear ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.clear)
                
                Text(".gray ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.gray)
                
                Text(".primary ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.primary)
                
                Text(".accentColor ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.accentColor)
                
                Text(".brown ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.brown)
                
                Text(".cyan ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.cyan)
                
                Text(".indigo ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.indigo)
                
                Text(".mint ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.mint)
                
                Text(".pink ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.pink)
                
                Text(".purple ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.purple)
                
                Text(".teal ")
                    .frame(width: 150)
                    .fontDesign(.monospaced)
                    .background(Color.teal)
                
            }
             */
        }
    }
}


struct ColorView: View {
    var body: some View {
        
        VStack {
            
            ColorTextButton(text: ".red", backgroundColor: .red)
            ColorTextButton(text: ".pink", backgroundColor: .pink)
            ColorTextButton(text: ".orange", backgroundColor: .orange)
            ColorTextButton(text: ".yellow", backgroundColor: .yellow)
            ColorTextButton(text: ".green", backgroundColor: .green)
            
            ColorTextButton(text: ".accentColor", backgroundColor: .accentColor)
            ColorTextButton(text: ".indigo", backgroundColor: .indigo)
            ColorTextButton(text: ".blue", backgroundColor: .blue)
            ColorTextButton(text: ".cyan", backgroundColor: .cyan)
            ColorTextButton(text: ".teal", backgroundColor: .teal)
            ColorTextButton(text: ".mint", backgroundColor: .mint)

            ColorTextButton(text: ".purple", backgroundColor: .purple)
            ColorTextButton(text: ".black", backgroundColor: .black)
            ColorTextButton(text: ".primary", backgroundColor: .primary)
            ColorTextButton(text: ".white", backgroundColor: .white)
            ColorTextButton(text: ".clear", backgroundColor: .clear)
            
            ColorTextButton(text: ".gray", backgroundColor: .gray)
            ColorTextButton(text: ".brown", backgroundColor: .brown)
            
            
        }
    }
}

struct ColorTextButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let text: String
    let backgroundColor: Color
    var width: CGFloat = 200
    
    var body: some View {
        
        
        if text == ".primary" && colorScheme == .light {
            
            Text(text)
                .foregroundStyle(.white)
                .padding(.leading, 10)
                .frame(width: width, alignment: .leading)
                .fontDesign(.monospaced)
                .background(backgroundColor)
            
        } else {
            
            Text(text)
                .foregroundStyle(text == ".black" ? .white : .black)
                .padding(.leading, 10)
                .frame(width: width, alignment: .leading)
                .fontDesign(.monospaced)
                .background(backgroundColor)
            
        }

    }
}
