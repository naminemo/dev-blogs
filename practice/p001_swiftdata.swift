import Foundation
import SwiftData
import SwiftUI

// MARK: - ClassroomListView (Master)

struct ClassroomListView: View {
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(sort: \Classroom.creationDate, order: .reverse)
    private var classrooms: [Classroom]
    
    @State
    private var showingAddClassroomSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(classrooms) { classroom in
                    
                    NavigationLink(destination: ClassroomDetailView(classroom: classroom)) {
                        VStack(alignment: .leading) {
                            Text(classroom.name)
                                .font(.headline)
                            Text("容量: \(classroom.capacity)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Text("學生人數: \(classroom.students?.count ?? 0)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteClassrooms)
            }
            .navigationTitle("所有教室")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        // 點擊按鈕，顯示新增教室的 Sheet
                        showingAddClassroomSheet = true
                    }) {
                        Label("新增教室", systemImage: "plus")
                    }
                }
            }
            // 當 showingAddClassroomSheet 為 true 時，顯示 AddClassroomView 作為 Sheet
            .sheet(isPresented: $showingAddClassroomSheet) {
                AddClassroomView()
            }
            // 如果沒有教室，顯示提示訊息
            .overlay {
                if classrooms.isEmpty {
                    ContentUnavailableView("目前沒有教室", systemImage: "building.columns")
                }
            }
        }
        .onAppear() {
            DatabasePathHelper.printPossibleDatabasePaths()
        }
    }
    
    private func deleteClassrooms(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                // 從 ModelContext 中刪除教室
                modelContext.delete(classrooms[index])
            }
        }
    }
}

class DatabasePathHelper {
    
    /// 印出可能的 SwiftData 資料庫位置
    static func printPossibleDatabasePaths() {
        print("=== SwiftData 可能的資料庫位置 ===")
        
        // 1. Documents 目錄
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("📁 Documents 目錄: \(documentsPath.path)")
            
            // 查找 .sqlite 檔案
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
                let sqliteFiles = contents.filter { $0.pathExtension == "sqlite" }
                
                print("📄 找到的 SQLite 檔案:")
                for file in sqliteFiles {
                    print("   - \(file.lastPathComponent): \(file.path)")
                }
            } catch {
                print("❌ 無法讀取 Documents 目錄: \(error)")
            }
        }
        
        // 2. Application Support 目錄
        if let appSupportPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("📁 Application Support 目錄: \(appSupportPath.path)")
            
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: appSupportPath, includingPropertiesForKeys: nil)
                let sqliteFiles = contents.filter { $0.pathExtension == "sqlite" }
                
                print("📄 Application Support 中的 SQLite 檔案:")
                for file in sqliteFiles {
                    print("   - \(file.lastPathComponent): \(file.path)")
                }
            } catch {
                print("❌ 無法讀取 Application Support 目錄: \(error)")
            }
        }
        
        // 3. Library 目錄
        if let libraryPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
            print("📁 Library 目錄: \(libraryPath.path)")
        }
        
        print("================================")
    }
    
    /// 搜尋整個應用程式沙盒中的 SQLite 檔案
    static func findAllSQLiteFiles() {
        print("=== 搜尋所有 SQLite 檔案 ===")
        
        let searchPaths: [(String, FileManager.SearchPathDirectory)] = [
            ("Documents", .documentDirectory),
            ("Library", .libraryDirectory),
            ("Caches", .cachesDirectory),
            ("Application Support", .applicationSupportDirectory)
        ]
        
        for (name, directory) in searchPaths {
            if let path = FileManager.default.urls(for: directory, in: .userDomainMask).first {
                findSQLiteFiles(in: path, directoryName: name)
            }
        }
        
        print("=============================")
    }
    
    private static func findSQLiteFiles(in directory: URL, directoryName: String) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )
            
            for item in contents {
                let resourceValues = try item.resourceValues(forKeys: [.isDirectoryKey])
                
                if resourceValues.isDirectory == true {
                    // 遞迴搜尋子目錄
                    findSQLiteFiles(in: item, directoryName: "\(directoryName)/\(item.lastPathComponent)")
                } else if item.pathExtension == "sqlite" || item.pathExtension == "sqlite-wal" || item.pathExtension == "sqlite-shm" {
                    print("📄 [\(directoryName)] \(item.lastPathComponent)")
                    print("   路徑: \(item.path)")
                }
            }
        } catch {
            print("❌ 無法搜尋 \(directoryName): \(error)")
        }
    }
}

#Preview {
    // 預覽時使用記憶體中的 SwiftData 容器
    ClassroomListView()
        .modelContainer(for: Classroom.self, inMemory: true)
}

// MARK: - ClassroomDetailView (Detail)

struct ClassroomDetailView: View {
    
    // 使用 @Bindable 綁定傳入的 Classroom 物件
    @Bindable
    var classroom: Classroom
    
    @Environment(\.modelContext)
    private var modelContext
    
    // dismiss 看起來像一個屬性，但它實際上是一個方法 (method)。
    // 或者說，是一個可被呼叫的類型 (callable type)。
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var showingAddStudentSheet = false
    
    @State
    private var showingDeleteClassroomAlert = false
    
    var body: some View {
        Form {
            // MARK: - 教室資訊 (允許編輯)
            Section("教室資訊") {
                
                // 直接編輯教室名稱
                TextField("教室名稱", text: $classroom.name)
                
                // 編輯容量
                Stepper("容量: \(classroom.capacity)", value: $classroom.capacity, in: 1...100)
            }
            
            // MARK: - 學生列表 (一對多關係的 "多" 部分)
            Section("學生列表 (\(classroom.students?.count ?? 0) 人)") {
                if let students = classroom.students?.sorted(by: { $0.name < $1.name }) {
                    if students.isEmpty {
                        Text("該教室目前沒有學生。")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(students) { student in
                            // 這裡我們直接顯示學生資訊
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(student.name)
                                    
                                    // FIXME
                                    /*
                                     if let gender = student.gender, !gender.isEmpty {
                                     Text("性別：\(gender)")
                                     .font(.subheadline)
                                     .foregroundStyle(.secondary)
                                     }
                                     */
                                    
                                }
                                
                                Spacer()
                                
                                Text("\(student.age) 歲")
                                    .foregroundStyle(.primary)
                                
                            }
                        }
                        .onDelete { offsets in
                            deleteStudents(at: offsets)
                        }
                    }
                }
                
                Button("新增學生") {
                    showingAddStudentSheet = true
                }
            }
            
            // MARK: - 刪除教室按鈕
            Section {
                Button("刪除此教室") {
                    showingDeleteClassroomAlert = true
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle(classroom.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton() // 允許編輯學生列表
            }
        }
        // 新增學生的 Sheet
        .sheet(isPresented: $showingAddStudentSheet) {
            AddStudentView(classroom: classroom) // 傳入當前教室，讓學生知道要加入哪個教室
        }
        // 刪除教室的確認警示
        .alert("刪除教室", isPresented: $showingDeleteClassroomAlert) {
            Button("刪除", role: .destructive) {
                
                // 刪除教室，SwiftData 的 cascade rule 會自動刪除相關學生
                modelContext.delete(classroom)
                dismiss() // 刪除後返回 Master 視圖
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("你確定要刪除「\(classroom.name)」教室嗎？相關的所有學生資料也將被永久刪除！")
        }
        
    }
    
    // 刪除學生的方法 (注意：這是刪除教室底下的學生，而不是整個教室)
    private func deleteStudents(at offsets: IndexSet) {
        guard let students = classroom.students else { return }
        for index in offsets {
            modelContext.delete(students[index]) // 刪除學生
        }
        // SwiftData 會自動更新 students 陣列，但為了確保 UI 立即更新，可以手動移除
        classroom.students?.remove(atOffsets: offsets)
    }
}

#Preview {
    // 預覽時，創建一個範例 Classroom 和 Student 物件
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Classroom.self, Student.self,  // 直接傳入類型，不使用陣列
        configurations: config
    )
    
    // 預先準備一些測試資料
    let classroom1 = Classroom(name: "一年甲班", capacity: 25, creationDate: Date())
    let classroom2 = Classroom(name: "二年乙班", capacity: 30, creationDate: Date())
    
//    let student1 = Student(name: "小明", age: 7, enrollDate: Date(), gender: "男")
//    let student2 = Student(name: "小華", age: 8, enrollDate: Date(), gender: "女")
    
    // FIXME
    let student1 = Student(name: "小明", age: 7, enrollDate: Date())
    let student2 = Student(name: "小華", age: 8, enrollDate: Date())
    
    // 建立關係
    classroom1.students?.append(student1)
    classroom1.students?.append(student2)
    
    // 將所有物件插入到 context 中
    // 插入資料
    container.mainContext.insert(classroom1)
    container.mainContext.insert(classroom2)
    container.mainContext.insert(student1)
    container.mainContext.insert(student2)
    
    // 返回 View
    return ClassroomDetailView(classroom: classroom1)
        .modelContainer(container) // 將容器傳遞給預覽
}


// MARK: - AddClassroomView (Master)

struct AddClassroomView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var capacity: Int = 20
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("教室名稱", text: $name)
                Stepper("容量: \(capacity)", value: $capacity, in: 1...100)
            }
            .navigationTitle("新增教室")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        saveClassroom()
                        dismiss()
                    }
                    // 名稱不能為空
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveClassroom() {
        let newClassroom = Classroom(name: name, capacity: capacity, creationDate: Date())
        modelContext.insert(newClassroom) // 插入新的教室
    }
}

#Preview {
    AddClassroomView()
        .modelContainer(for: Classroom.self, inMemory: true)
}

// MARK: - AddStudentView (Detail)

struct AddStudentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var age: Int = 7
    
    // ****** 新增的 gender 狀態變數 ******
    @State private var gender: String = "未選擇" // 預設值
    
    
    var classroom: Classroom // 接收要添加學生的教室
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("學生姓名", text: $name)
                Stepper("年齡: \(age)", value: $age, in: 1...18)
                // ****** 新增性別輸入選項 ******
                // FIXME
                /*
                Picker("性別", selection: $gender) {
                    Text("未選擇").tag("未選擇")
                    Text("男").tag("男")
                    Text("女").tag("女")
                    Text("其他").tag("其他")
                }
                */
                
            }
            .navigationTitle("新增學生")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        saveStudent()
                        dismiss()
                    }
                    // 姓名不能為空
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveStudent() {
        
        // ****** 傳遞 gender 欄位 ******
       // let studentGender: String? = gender == "未選擇" ? nil : gender
        // FIXME
        let newStudent = Student(
            name: name,
            age: age,
            enrollDate: Date(),
            //gender: gender // 使用經過處理的 gender
        )
        // 將新學生加入到傳入的教室的學生陣列中
        classroom.students?.append(newStudent)
        print("學生新增：\(newStudent.name)")
        
        
        
        // 將新學生加入到傳入的教室的學生陣列中
        // classroom.students?.append(newStudent)
        // 注意：這裡不需要 modelContext.insert(newStudent)
        // 因為當你將學生添加到 classroom.students 陣列時，
        // SwiftData 會自動處理其持久化，因為 Classroom 和 Student 之間有關係。
        // 當 classroom 儲存時，相關的 student 也會被儲存。
    }
}

#Preview {
    // 預覽時，創建一個範例 Classroom
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Classroom.self, Student.self, configurations: config)
    let exampleClassroom = Classroom(name: "預覽教室", capacity: 25, creationDate: Date())
    container.mainContext.insert(exampleClassroom)
    
    return AddStudentView(classroom: exampleClassroom)
        .modelContainer(container)
}

// MARK: - SchemaV1 (初始化資料庫版本)

enum SchemaV1: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(1, 0, 0) // 唯一識別符
    
    static var models: [any PersistentModel.Type] {
        [SchemaV1.Classroom.self, SchemaV1.Student.self] // 包含所有 V1 版本中的模型
    }
    
    // Classroom 模型在 V1 中
    @Model
    final class Classroom {
        @Attribute(.unique) var name: String
        var capacity: Int
        var creationDate: Date
        
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.Student.classroom)
        var students: [SchemaV1.Student]?
        
        init(name: String, capacity: Int, creationDate: Date) {
            self.name = name
            self.capacity = capacity
            self.creationDate = creationDate
            self.students = []
        }
    }
    
    // Student 模型在 V1 中 (沒有 gender 欄位)
    @Model
    final class Student {
        var name: String
        var age: Int
        var enrollDate: Date
        
        @Relationship
        var classroom: SchemaV1.Classroom?
        
        init(name: String, age: Int, enrollDate: Date) {
            self.name = name
            self.age = age
            self.enrollDate = enrollDate
        }
    }
}

// MARK: - SchemaV2 (新的資料庫版本)

enum SchemaV2: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [SchemaV2.Classroom.self, SchemaV2.Student.self]// 包含所有 V2 版本中的模型
    }
    
    // Classroom 模型在 V2 中 (保持不變)
    @Model
    final class Classroom {
        @Attribute(.unique) var name: String
        var capacity: Int
        var creationDate: Date
        @Relationship(deleteRule: .cascade, inverse: \SchemaV2.Student.classroom)
        var students: [SchemaV2.Student]?
        
        init(name: String, capacity: Int, creationDate: Date) {
            self.name = name
            self.capacity = capacity
            self.creationDate = creationDate
            self.students = []
        }
    }
    
    // Student 模型在 V2 中 (包含 gender 欄位)
    @Model
    final class Student {
        var name: String
        var age: Int
        var enrollDate: Date
        @Relationship
        var classroom: SchemaV2.Classroom?
        var gender: String? // 新增的 gender 欄位
        
        init(name: String, age: Int, enrollDate: Date, gender: String) {
            self.name = name
            self.age = age
            self.enrollDate = enrollDate
            self.gender = gender
        }
    }
}



enum MigrationPlan1: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self] // 未來加入 SchemaV2 時再擴充
    }
    
    static var stages: [MigrationStage] {
        [] // 初始版本沒有遷移階段
    }
}

enum MigrationPlan2: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SchemaV1.self,
            SchemaV2.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self,
        willMigrate: { context in
            print("開始從 SchemaV1 遷移到 SchemaV2...")
            
        },
        didMigrate: { context in
            
            let v2Students = try context.fetch(FetchDescriptor<SchemaV2.Student>())
            
            v2Students.forEach { student in
                student.gender = "男性"
            }
            
            try? context.save() // 儲存變更
            print("遷移完成！所有學生的 gender 已設定為「男性」")
        }
    )
}



// MARK: - 入口點

import SwiftUI
import SwiftData

typealias Classroom = SchemaV1.Classroom
typealias Student = SchemaV1.Student

@main
struct JiaoshiApp: App {
    
    // 第一階段
    var sharedModelContainer: ModelContainer = {
        do {
            // 只使用 SchemaV1，不包含遷移
            return try ModelContainer(for: Classroom.self, Student.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    /*
    // 第二階段
    // 使用完整的遷移計畫
    var sharedModelContainer: ModelContainer = {
        do {
            // 使用完整的遷移計畫
            return try ModelContainer(
                for: Classroom.self, Student.self,
                migrationPlan: MigrationPlan2.self
            )
        } catch {
            print(" 遷移失敗: \(error)")
            
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    */
    
    var body: some Scene {
        WindowGroup {
            ClassroomListView()
        }
        .modelContainer(sharedModelContainer)
    }
    
}


