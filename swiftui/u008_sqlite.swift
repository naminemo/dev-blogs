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
            .appendingPathComponent("mydb.db")
        
        dbPath = fileURL.path
        print("資料庫位置: \(dbPath)")
        
        DispatchQueue.main.async {
            self.openDatabase()
        }
    }
    
    deinit {
        closeDatabase()
    }
    
    // MARK: - 資料庫連接管理
    private func openDatabase() {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("成功開啟資料庫")
            DispatchQueue.main.async {
                self.statusMessage = "資料庫連線成功！"
            }
            createVersionTable()
        } else {
            print("無法開啟資料庫")
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("SQLite 錯誤: \(errorMessage)")
            DispatchQueue.main.async {
                self.statusMessage = "資料庫連線失敗: \(errorMessage)"
            }
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
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("建立版本表失敗: \(errorMessage)")
            DispatchQueue.main.async {
                self.statusMessage = "建立版本表失敗: \(errorMessage)"
            }
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
        DispatchQueue.main.async {
            self.statusMessage = "資料庫版本: \(currentDbVersion) -> \(self.currentVersion)"
        }
        
        performMigration(from: currentDbVersion)
    }
    
    private func performMigration(from version: Int) {
        if version < 1 {
            migrationV1()
        } else if version < 2 {
            migrationV2()
        } else {
            DispatchQueue.main.async {
                self.statusMessage = "資料庫已是最新版本"
            }
            loadStudents()
        }
    }
    
    // MARK: - 資料庫遷移
    private func migrationV1() {
        DispatchQueue.main.async {
            self.statusMessage = "正在執行遷移 v1 - 建立學生資料表..."
        }
        
        let createTableSQL = """
            CREATE TABLE IF NOT EXISTS student (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                student_id TEXT NOT NULL UNIQUE
            );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) == SQLITE_OK {
            print("成功建立學生資料表")
            updateDatabaseVersion(to: 1)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("遷移 v1 失敗: \(errorMessage)")
            DispatchQueue.main.async {
                self.statusMessage = "遷移 v1 失敗: \(errorMessage)"
            }
        }
    }
    
    private func migrationV2() {
        DispatchQueue.main.async {
            self.statusMessage = "正在執行遷移 v2 - 新增性別欄位..."
        }
        
        let alterTableSQL = "ALTER TABLE student ADD COLUMN gender TEXT DEFAULT '未指定'"
        
        if sqlite3_exec(db, alterTableSQL, nil, nil, nil) == SQLITE_OK {
            print("成功新增性別欄位")
            updateDatabaseVersion(to: 2)
        } else {
            // 檢查是否是因為欄位已存在
            let errorMsg = String(cString: sqlite3_errmsg(db))
            if errorMsg.contains("duplicate column name") {
                print("性別欄位已存在")
                DispatchQueue.main.async {
                    self.statusMessage = "性別欄位已存在"
                }
                updateDatabaseVersion(to: 2)
            } else {
                print("遷移 v2 失敗: \(errorMsg)")
                DispatchQueue.main.async {
                    self.statusMessage = "遷移 v2 失敗: \(errorMsg)"
                }
            }
        }
    }
    
    private func updateDatabaseVersion(to version: Int) {
        let insertVersionSQL = "INSERT OR REPLACE INTO db_version (version) VALUES (?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertVersionSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(version))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("資料庫版本已更新到: \(version)")
                DispatchQueue.main.async {
                    self.statusMessage = "資料庫已更新到版本 \(version)"
                }
                
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
        DispatchQueue.main.async {
            self.statusMessage = "資料庫遷移完成！版本: \(self.currentVersion)"
        }
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
        
        print("現有學生資料數量: \(count)")
        
        if count == 0 {
            DispatchQueue.main.async {
                self.statusMessage = "資料庫已準備就緒 (無現有資料)"
            }
            insertSampleData()
        } else {
            DispatchQueue.main.async {
                self.statusMessage = "資料庫已準備就緒 (包含 \(count) 筆學生資料)"
            }
            loadStudents()
        }
    }
    
    // MARK: - 示例資料
    private func insertSampleData() {
        print("正在插入示例資料...")
        let sampleStudents = [
            ("張小明", "20001", "男"),
            ("李小華", "20002", "女"),
            ("王小美", "20003", "女")
        ]
        
        var successCount = 0
        for (name, studentId, gender) in sampleStudents {
            if addStudentInternal(name: name, studentId: studentId, gender: gender) {
                successCount += 1
            }
        }
        
        print("成功插入 \(successCount) 筆示例資料")
        DispatchQueue.main.async {
            self.statusMessage = "已插入示例學生資料 (\(successCount) 筆)"
        }
        loadStudents()
    }
    
    // MARK: - CRUD 操作
    func loadStudents() {
        print("正在載入學生資料...")
        var tempStudents: [Student] = []
        
        let querySQL = "SELECT id, name, student_id, COALESCE(gender, '未指定') as gender FROM student ORDER BY student_id"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                // 修復文字資料讀取問題 - 使用更安全的方式
                var name = "未知"
                var studentId = "未知"
                var gender = "未指定"
                
                // 檢查並讀取 name
                if let nameBytes = sqlite3_column_text(statement, 1) {
                    name = String(cString: nameBytes)
                }
                
                // 檢查並讀取 student_id
                if let studentIdBytes = sqlite3_column_text(statement, 2) {
                    studentId = String(cString: studentIdBytes)
                }
                
                // 檢查並讀取 gender
                if let genderBytes = sqlite3_column_text(statement, 3) {
                    gender = String(cString: genderBytes)
                }
                
                // 額外檢查：如果讀取到的是空字串，顯示原始位元組
                if name.isEmpty || studentId.isEmpty {
                    print("警告: 發現空字串 - ID=\(id)")
                    print("Name column type: \(sqlite3_column_type(statement, 1))")
                    print("StudentId column type: \(sqlite3_column_type(statement, 2))")
                    print("Name bytes: \(sqlite3_column_bytes(statement, 1))")
                    print("StudentId bytes: \(sqlite3_column_bytes(statement, 2))")
                }
                
                let student = Student(id: id, name: name, studentId: studentId, gender: gender)
                tempStudents.append(student)
                
                // print("載入學生: ID=\(id), 姓名=[\(name)], 學號=[\(studentId)], 性別=[\(gender)]")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("查詢學生資料失敗: \(errorMessage)")
        }
        sqlite3_finalize(statement)
        
        print("共載入 \(tempStudents.count) 筆學生資料")
        
        DispatchQueue.main.async {
            self.students = tempStudents
            self.statusMessage = "已載入 \(tempStudents.count) 筆學生資料"
        }
    }
    
    // 內部使用的新增方法，不會觸發 UI 更新
    private func addStudentInternal(name: String, studentId: String, gender: String) -> Bool {
        print("準備新增學生: 姓名=[\(name)], 學號=[\(studentId)], 性別=[\(gender)]")
        
        let insertSQL = "INSERT INTO student (name, student_id, gender) VALUES (?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            // 修復: 使用 SQLITE_TRANSIENT 而不是閉包
            sqlite3_bind_text(statement, 1, name, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            sqlite3_bind_text(statement, 2, studentId, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            sqlite3_bind_text(statement, 3, gender, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            
            print("SQL 綁定完成，準備執行...")
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                print("成功新增學生到資料庫: \(name) (\(studentId))")
                
                // 立即驗證插入結果
                verifyLastInsert()
                return true
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SQL 執行失敗: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("SQL 準備失敗: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    // 驗證最後插入的資料
    private func verifyLastInsert() {
        let lastRowId = sqlite3_last_insert_rowid(db)
        print("最後插入的資料 ID: \(lastRowId)")
        
        let querySQL = "SELECT name, student_id, gender FROM student WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, lastRowId)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let name = sqlite3_column_text(statement, 0)
                let studentId = sqlite3_column_text(statement, 1)
                let gender = sqlite3_column_text(statement, 2)
                
                let nameStr = name != nil ? String(cString: name!) : "NULL"
                let studentIdStr = studentId != nil ? String(cString: studentId!) : "NULL"
                let genderStr = gender != nil ? String(cString: gender!) : "NULL"
                
                print("驗證插入結果: 姓名=[\(nameStr)], 學號=[\(studentIdStr)], 性別=[\(genderStr)]")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func addStudent(name: String, studentId: String, gender: String) -> Bool {
        let success = addStudentInternal(name: name, studentId: studentId, gender: gender)
        if success {
            loadStudents()
        }
        return success
    }
    
    func updateStudent(id: Int, name: String, studentId: String, gender: String) -> Bool {
        let updateSQL = "UPDATE student SET name = ?, student_id = ?, gender = ? WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateSQL, -1, &statement, nil) == SQLITE_OK {
            // 修復: 使用正確的綁定方式
            sqlite3_bind_text(statement, 1, name, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            sqlite3_bind_text(statement, 2, studentId, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            sqlite3_bind_text(statement, 3, gender, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            sqlite3_bind_int(statement, 4, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                loadStudents()
                return true
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("更新學生失敗: \(errorMessage)")
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
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("刪除學生失敗: \(errorMessage)")
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
        
        DispatchQueue.main.async {
            self.statusMessage = "成功新增 \(successCount) 筆測試資料"
        }
    }
    
    private func getMaxStudentId() -> Int {
        if students.isEmpty { return 10000 }
        
        return students.compactMap { Int($0.studentId) }.max() ?? 10000
    }
    
    func clearAllData() -> Bool {
        let deleteSQL = "DELETE FROM student"
        
        if sqlite3_exec(db, deleteSQL, nil, nil, nil) == SQLITE_OK {
            loadStudents()
            DispatchQueue.main.async {
                self.statusMessage = "所有學生資料已清空"
            }
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
                    
                    Text("學生數量: \(dbManager.students.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                
                Divider()
                
                // 學生列表
                if dbManager.students.isEmpty {
                    VStack {
                        Spacer()
                        Text("暫無學生資料")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                        Text("點擊下方按鈕新增學生或載入測試資料")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(dbManager.students) { student in
                            StudentRowView(student: student, isSelected: selectedStudent?.id == student.id)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedStudent = student
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
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
                    
                    Button("測試資料") {
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
    let isSelected: Bool

    let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 60), spacing: 1), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            Text("\(student.id)")
            Text(student.name)
            Text(student.studentId)
            Text(student.gender)
        }
        .font(.caption)
        .padding(8)
        .background(isSelected ? Color.accentColor.opacity(0.3) : Color.white)
        .overlay(
            Rectangle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
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
        
        if dbManager.updateStudent(
            id: student.id,
            name: trimmedName,
            studentId: trimmedStudentId,
            gender: selectedGender
        ) {
            onComplete()
            dismiss()
        } else {
            alertMessage = "更新失敗，學號可能已存在"
            showingAlert = true
        }
    }
}

#Preview {
    ContentView()
}
/*
// MARK: - App 入口
@main
struct StudentManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/