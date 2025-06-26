// macOS

import SwiftUI
import AppKit // For NSOpenPanel and NSImage
import UniformTypeIdentifiers // For UTType

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var base64String: String = ""
    @State private var showingImagePicker: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("圖片轉 Base64 編碼器")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let image = selectedImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                Text("尚未選擇圖片")
                    .foregroundColor(.secondary)
            }

            Button("選擇圖片") {
                openImagePanel()
            }
            .buttonStyle(.borderedProminent)

            TextEditor(text: .constant(base64String.isEmpty ? "Base64 編碼結果會顯示在這裡..." : base64String))
                .font(.callout)
                .lineSpacing(4)
                .padding()
                .frame(minHeight: 150, maxHeight: 300)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            if !base64String.isEmpty {
                Button("複製 Base64 字串") {
                    copyToPasteboard(base64String)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(minWidth: 400, idealWidth: 600, maxWidth: .infinity,
               minHeight: 500, idealHeight: 700, maxHeight: .infinity)
    }

    // MARK: - Helper Functions

    func openImagePanel() {
        
        let panel = NSOpenPanel()

        // --- IMPORTANT CHANGE HERE ---
        // Use allowedContentTypes with Uniform Type Identifiers (UTIs)
        panel.allowedContentTypes = [
            .png,
            .jpeg,
            .gif,
            .tiff,
            .heic,
            .image // Generic image type covers many common formats
        ]
        // --- END OF IMPORTANT CHANGE ---

        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true

        panel.begin { (response) in
            if response == .OK, let url = panel.url {
                do {
                    let imageData = try Data(contentsOf: url)
                    let encodedString = imageData.base64EncodedString()
                    
                    self.base64String = encodedString
                    self.selectedImage = NSImage(contentsOf: url)
                } catch {
                    print("讀取圖片錯誤: \(error.localizedDescription)")
                    self.base64String = "錯誤: 無法讀取圖片或轉換 Base64。"
                    self.selectedImage = nil
                }
            }
        }
    }

    func copyToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        print("Base64 字串已複製到剪貼簿。")
    }
}

#Preview {
    ContentView()
}
