import SwiftUI
import SQLite3
import Foundation

// MARK: - 學生資料模型
struct Student: Identifiable, Codable {
    let id: Int
    var name: String
    var studentId: String
    var gender: String
    
    init(id: Int = 0, name: String, studentId: String, gender: String = "未指定") {
        self.id = id
        self.name = name
        self.studentId = studentId
        self.gender = gender
    }
}

// MARK: - 資料庫管理器
class DatabaseManager: ObservableObject {
    private var db: OpaquePointer?
    private let dbPath: String
    private let currentVersion = 2
    
    @Published var students: [Student] = []
    @Published var statusMessage: String = "正在初始化..."
    
    init() {
        // 獲取文檔目錄路徑
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("StudentDatabase.sqlite")
        
        dbPath = fileURL.path
        print("資料庫位置: \(dbPath)")
        
        openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    // MARK: - 資料庫連接管理
    private func openDatabase() {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("成功開啟資料庫")
            statusMessage = "資料庫連線成功！"
            createVersionTable()
        } else {
            print("無法開啟資料庫")
            statusMessage = "資料庫連線失敗"
        }
    }
    
    private func closeDatabase() {
        if db != nil {
            sqlite3_close(db)
            db = nil
        }
    }
    
    // MARK: - 版本控制
    private func createVersionTable() {
        let createVersionTableSQL = """
            CREATE TABLE IF NOT EXISTS db_version (
                version INTEGER PRIMARY KEY
            );
        """
        
        if sqlite3_exec(db, createVersionTableSQL, nil, nil, nil) == SQLITE_OK {
            checkDatabaseVersion()
        } else {
            statusMessage = "建立版本表失敗"
        }
    }
    
    private func checkDatabaseVersion() {
        let querySQL = "SELECT version FROM db_version ORDER BY version DESC LIMIT 1"
        var statement: OpaquePointer?
        var currentDbVersion = 0
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                currentDbVersion = Int(sqlite3_column_int(statement, 0))
            }
        }
        sqlite3_finalize(statement)
        
        print("當前資料庫版本: \(currentDbVersion)")
        statusMessage = "資料庫版本: \(currentDbVersion) -> \(currentVersion)"
        
        performMigration(from: currentDbVersion)
    }
    
    private func performMigration(from version: Int) {
        if version < 1 {
            migrationV1()
        } else if version < 2 {
            migrationV2()
        } else {
            statusMessage = "資料庫已是最新版本"
            loadStudents()
        }
    }
    
    // MARK: - 資料庫遷移
    private func migrationV1() {
        statusMessage = "正在執行遷移 v1 - 建立學生資料表..."
        
        let createTableSQL = """
            CREATE TABLE IF NOT EXISTS student (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                student_id TEXT NOT NULL UNIQUE
            );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) == SQLITE_OK {
            updateDatabaseVersion(to: 1)
        } else {
            statusMessage = "遷移 v1 失敗"
        }
    }
    
    private func migrationV2() {
        statusMessage = "正在執行遷移 v2 - 新增性別欄位..."
        
        let alterTableSQL = "ALTER TABLE student ADD COLUMN gender TEXT DEFAULT '未指定'"
        
        if sqlite3_exec(db, alterTableSQL, nil, nil, nil) == SQLITE_OK {
            updateDatabaseVersion(to: 2)
        } else {
            // 檢查是否是因為欄位已存在
            let errorMsg = String(cString: sqlite3_errmsg(db))
            if errorMsg.contains("duplicate column name") {
                statusMessage = "性別欄位已存在"
                updateDatabaseVersion(to: 2)
            } else {
                statusMessage = "遷移 v2 失敗: \(errorMsg)"
            }
        }
    }
    
    private func updateDatabaseVersion(to version: Int) {
        let insertVersionSQL = "INSERT OR REPLACE INTO db_version (version) VALUES (?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertVersionSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(version))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                statusMessage = "資料庫已更新到版本 \(version)"
                
                if version < currentVersion {
                    performMigration(from: version)
                } else {
                    onMigrationComplete()
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    private func onMigrationComplete() {
        statusMessage = "資料庫遷移完成！版本: \(currentVersion)"
        checkExistingData()
    }
    
    private func checkExistingData() {
        let countSQL = "SELECT COUNT(*) FROM student"
        var statement: OpaquePointer?
        var count = 0
        
        if sqlite3_prepare_v2(db, countSQL, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        sqlite3_finalize(statement)
        
        if count == 0 {
            statusMessage = "資料庫已準備就緒 (無現有資料)"
            insertSampleData()
        } else {
            statusMessage = "資料庫已準備就緒 (包含 \(count) 筆學生資料)"
            loadStudents()
        }
    }
    
    // MARK: - 示例資料
    private func insertSampleData() {
        let sampleStudents = [
            ("張小明", "20001", "男"),
            ("李小華", "20002", "女"),
            ("王小美", "20003", "女")
        ]
        
        for (name, studentId, gender) in sampleStudents {
            addStudent(name: name, studentId: studentId, gender: gender)
        }
        
        statusMessage = "已插入示例學生資料"
        loadStudents()
    }
    
    // MARK: - CRUD 操作
    func loadStudents() {
        students.removeAll()
        
        let querySQL = "SELECT id, name, student_id, COALESCE(gender, '未指定') as gender FROM student ORDER BY student_id"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let studentId = String(cString: sqlite3_column_text(statement, 2))
                let gender = String(cString: sqlite3_column_text(statement, 3))
                
                students.append(Student(id: id, name: name, studentId: studentId, gender: gender))
            }
        }
        sqlite3_finalize(statement)
        
        statusMessage = "已載入 \(students.count) 筆學生資料"
    }
    
    func addStudent(name: String, studentId: String, gender: String) -> Bool {
        let insertSQL = "INSERT INTO student (name, student_id, gender) VALUES (?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, name, -1, nil)
            sqlite3_bind_text(statement, 2, studentId, -1, nil)
            sqlite3_bind_text(statement, 3, gender, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                loadStudents()
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func updateStudent(id: Int, name: String, studentId: String, gender: String) -> Bool {
        let updateSQL = "UPDATE student SET name = ?, student_id = ?, gender = ? WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, name, -1, nil)
            sqlite3_bind_text(statement, 2, studentId, -1, nil)
            sqlite3_bind_text(statement, 3, gender, -1, nil)
            sqlite3_bind_int(statement, 4, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                loadStudents()
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func deleteStudent(id: Int) -> Bool {
        let deleteSQL = "DELETE FROM student WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                loadStudents()
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func insertTestData() {
        let testStudents = [
            ("王大明", "男"), ("李小華", "女"), ("張志豪", "男"),
            ("陳美玲", "女"), ("林志偉", "男"), ("黃淑芬", "女"),
            ("吳建民", "男"), ("劉雅婷", "女"), ("謝文昌", "男"), ("蔡麗娟", "女")
        ]
        
        let maxId = getMaxStudentId()
        var successCount = 0
        
        for i in 0..<3 {
            let newStudentId = String(maxId + i + 1)
            let (name, gender) = testStudents[i % testStudents.count]
            
            if addStudent(name: name, studentId: newStudentId, gender: gender) {
                successCount += 1
            }
        }
        
        statusMessage = "成功新增 \(successCount) 筆測試資料"
    }
    
    private func getMaxStudentId() -> Int {
        if students.isEmpty { return 10000 }
        
        return students.compactMap { Int($0.studentId) }.max() ?? 10000
    }
    
    func clearAllData() -> Bool {
        let deleteSQL = "DELETE FROM student"
        
        if sqlite3_exec(db, deleteSQL, nil, nil, nil) == SQLITE_OK {
            loadStudents()
            statusMessage = "所有學生資料已清空"
            return true
        }
        return false
    }
    
    func getDatabasePath() -> String {
        return dbPath
    }
}

// MARK: - 主視圖
struct ContentView: View {
    @StateObject private var dbManager = DatabaseManager()
    @State private var selectedStudent: Student?
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 狀態顯示
                VStack(alignment: .leading, spacing: 4) {
                    Text(dbManager.statusMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("資料庫位置: \(dbManager.getDatabasePath())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding()
                .background(Color(.systemGray6))
                
                Divider()
                
                // 學生列表
                List {
                    ForEach(dbManager.students) { student in
                        StudentRowView(student: student)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedStudent = student
                            }
                    }
                }
                .listStyle(PlainListStyle())
                
                Divider()
                
                // 操作按鈕
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    Button("新增學生") {
                        showingAddSheet = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("編輯學生") {
                        if selectedStudent != nil {
                            showingEditSheet = true
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedStudent == nil)
                    
                    Button("刪除學生") {
                        if selectedStudent != nil {
                            showingDeleteAlert = true
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedStudent == nil)
                    
                    Button("重新載入") {
                        dbManager.loadStudents()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("寫入測試資料") {
                        dbManager.insertTestData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("清空資料") {
                        showingClearAlert = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.red)
                }
                .padding()
            }
            .navigationTitle("學生管理系統")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddStudentView(dbManager: dbManager)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let student = selectedStudent {
                EditStudentView(dbManager: dbManager, student: student) {
                    selectedStudent = nil
                }
            }
        }
        .alert("確認刪除", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("刪除", role: .destructive) {
                if let student = selectedStudent {
                    _ = dbManager.deleteStudent(id: student.id)
                    selectedStudent = nil
                }
            }
        } message: {
            if let student = selectedStudent {
                Text("確定要刪除學生 '\(student.name)' (學號: \(student.studentId)) 嗎？")
            }
        }
        .alert("確認清空", isPresented: $showingClearAlert) {
            Button("取消", role: .cancel) { }
            Button("清空", role: .destructive) {
                _ = dbManager.clearAllData()
                selectedStudent = nil
            }
        } message: {
            Text("警告：此操作將會清空所有學生資料，且無法復原！確定要繼續嗎？")
        }
    }
}

// MARK: - 學生行視圖
struct StudentRowView: View {
    let student: Student
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name)
                    .font(.headline)
                
                HStack {
                    Text("學號: \(student.studentId)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("性別: \(student.gender)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text("ID: \(student.id)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 新增學生視圖
struct AddStudentView: View {
    @Environment(\.dismiss) private var dismiss
    let dbManager: DatabaseManager
    
    @State private var name = ""
    @State private var studentId = ""
    @State private var selectedGender = "未指定"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let genderOptions = ["未指定", "男", "女"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("學生資訊") {
                    TextField("姓名", text: $name)
                    TextField("學號", text: $studentId)
                    
                    Picker("性別", selection: $selectedGender) {
                        ForEach(genderOptions, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                }
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
                    Button("新增") {
                        addStudent()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                             studentId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("確定") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func addStudent() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStudentId = studentId.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if dbManager.addStudent(name: trimmedName, studentId: trimmedStudentId, gender: selectedGender) {
            dismiss()
        } else {
            alertMessage = "新增失敗，學號可能已存在"
            showingAlert = true
        }
    }
}

// MARK: - 編輯學生視圖
struct EditStudentView: View {
    @Environment(\.dismiss) private var dismiss
    let dbManager: DatabaseManager
    let student: Student
    let onComplete: () -> Void
    
    @State private var name: String
    @State private var studentId: String
    @State private var selectedGender: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let genderOptions = ["未指定", "男", "女"]
    
    init(dbManager: DatabaseManager, student: Student, onComplete: @escaping () -> Void) {
        self.dbManager = dbManager
        self.student = student
        self.onComplete = onComplete
        self._name = State(initialValue: student.name)
        self._studentId = State(initialValue: student.studentId)
        self._selectedGender = State(initialValue: student.gender)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("學生資訊") {
                    TextField("姓名", text: $name)
                    TextField("學號", text: $studentId)
                    
                    Picker("性別", selection: $selectedGender) {
                        ForEach(genderOptions, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                }
            }
            .navigationTitle("編輯學生")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("更新") {
                        updateStudent()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                             studentId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("確定") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updateStudent() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStudentId = studentId.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if dbManager.updateStudent(id: student.id, name: trimmedName, studentId: trimmedStudentId, gender: selectedGender) {
            onComplete()
            dismiss()
        } else {
            alertMessage = "更新失敗，學號可能已存在"
            showingAlert = true
        }
    }
}

// MARK: - App 入口
@main
struct StudentManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}