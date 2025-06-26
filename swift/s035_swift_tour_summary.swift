import UIKit

//
//  █████  █████  █████  █████         █████  █████           █    █████
//      █  █   █      █  █             █   █      █          ██    █   █
//  █████  █   █  █████  █████  █████  █   █  █████  █████    █    █   █
//  █      █   █  █          █         █   █      █           █    █   █
//  █████  █████  █████  █████         █████  █████         █████  █████
//
//  
//
//  ████  █████  █   █  ████   █      █████         █   █   ███   █      █   █  █████   ████
// █        █    ██ ██  █   █  █      █             █   █  █   █  █      █   █  █      █
//  ███     █    █ █ █  ████   █      █████         █   █  █████  █      █   █  █████   ███
//     █    █    █   █  █      █      █              █ █   █   █  █      █   █  █          █
// ████   █████  █   █  █      █████  █████           █    █   █  █████  █████  █████  ████
//


var greeting = "Hello, playground"      // 此型別為 String


// 您不需要匯入單獨的函式庫來輸出文字或處理字串等功能，
// 也不需要在每個敘述 (statement) 的末尾寫分號。
print("Hello, world!")


//===============單一值 (Simple Values/Single Values) ===============
// 使用 let 建立常數 (constant) ，使用 var 建立變數 (variable) 。
// var 宣告的記憶體配置空間在第一次設值之後可以變動
// 但 let 宣告的記憶體配置空間，在第一次設值之後就不可以變動。


// 等號(=)在程式中稱為 assign (設值) ，會自動依照設定的值來推測其型別 (type inference) ，
// 宣告一個變數，此型別為 Int
var myVariable = 42
print(greeting)
print(myVariable)


// 變數在第一次設值之後可以變動
myVariable = 5000000
print(myVariable)


// 變數的變動，必須相同型別
// myVariable = "test"
// error: Cannot assign value of type 'String' to type 'Int'

// 宣告一個常數
let myConstant = 42

// 常數不可事後變動其值，下列一行會出錯
// myConstant = 55
// error: Cannot assign to value: 'myConstant' is a 'let' constant


let implicitInteger = 70     // 以型別推測機制，決定其型別為 Int (因為其值不帶小數位數)
let implicitDouble = 70.0    // 以型別推測機制，決定其型別為 Double (因為其值帶小數位數)
var explicitDouble: Double = 70    // 不使用型別推測機制，自己明確型別為 Double (浮點數)


// 注意：=前後的空白必須一致，否則會看到以下的錯誤訊息
// var explicitDouble: Double= 70
// Error: '=' must have consistent whitespace on both sides
// var explicitDouble: Double = 70  // OK


// 但明確型別的冒號，前後空白可以不一致
var explicitDouble1:Double = 70    // OK
var explicitDouble2: Double = 70  // OK



// 觀察 Int 型別的最小值和最大值
Int.min
Int.max
// myVariable = 9_223_372_036_854_775_808 // 三位一撇的數字算法可用底線代替
// error: Integer literal '9223372036854775808' overflows (溢位)  when stored into 'Int'

Int8.min
Int8.max
Int16.min
Int16.max

// Int 型別等同於 Int32 (在32位元的作業系統上)
Int32.min
Int32.max

// Int 型別等同於 Int64 (在64位元的作業系統上)
Int64.min
Int64.max

// PS.目前市面上已經沒有 32 位元的設備

explicitDouble = 39.1234567890123456789
// Double型別提供至少15位十進制數字的精度，
// 這表示它能準確表示大約 15 位有效數字，超出的位數會自動截斷，不會溢位！
// (注意：不是固定15位小數位數)
print(explicitDouble)


/*
 《練習1》
 建立一個具有明確 Float 型別和值為 4 的常數。
*/
let explicitFloat: Float
// Float型別提供大約6位十進制數字的精度，這表示它能準確表示大約6 位有效數字。
explicitFloat = 4.1234567890123456789
print(explicitFloat)


//---------------Swift沒有自動轉型---------------
// 值永遠不會自動轉換為另一種型別。
// 如果您需要將值轉換為其他型別，請明確地建立所需型別的實體 (instance) 。
let label = "12"                          // 宣告label常數為String型別
let width = 94                            // 宣告width常數為Int型別
let widthLabel = label + String(width)    // "12" + "94" String()為initializer初始化方法
// String(  ) 初始化一塊字串記憶體配置空間，建立一個實體，運算完後會釋放


let myTotal = Int(label)! + width


// 也可以使用下一段的字串插入語法自動轉換運算後的型別為字串
let widthLabel2: String = "The width is \(width)"


/*
《練習2》
嘗試從最後一行中刪除到 String 的轉換。 你得到了什麼錯誤？
*/
// let widthLabel = label + width
// error: Binary operator '+' cannot be applied to operands of type 'String' and 'Int'
// operator: 運算子／運算符號
// operand: 運算元 (素)


// 有一個更簡單的方法來在字串中包含值: 將值寫在小括號中，並在括號前寫一個反斜線 (\)
// 此方法稱做字串插值，也就是在字串裡面插入值
// 例如：
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."


/*
《練習3》
使用\()在字串中包含浮點數的計算 (BMI) ，並在問候語中包含某人的名字和他的BMI。
問候語 XXX 你好：你的BMI是23.66
BMI 體重 (公斤) / 身高 (公尺) 平方
Operator：+ (加法)  - (減法)  * (乘法)  / (除法取商數)  % (除法取餘數)
*/
let myName = "Perkin"
let myWeight = 61.0
let myHeight = 1.67
let message = "\(myName)你好：你的BMI是\(myWeight/(myHeight*myHeight))"
print(message)
print(myWeight/(myHeight*myHeight))
// 執行字串格式化方法，指定取位的小數位數 (四捨六入五成雙)
String(format: "%@你好：你的BMI是%.2f", myName, myWeight/(myHeight*myHeight))


//-------------<補充>命名規則-------------
/*
所有的型別，建議使用大寫開頭的駝峰式 (Upper Camel Case) 命名法來命名，現有的型別包含：Int, String, Double, Float 都使用大寫開頭。
注意：Swift中唯一會看到大寫開頭的命名，只有型別 (Type) ！
除了型別之外的命名，一律使用小寫開頭的駝峰式 (lower Camel Case) 命名法來命名。
*/
//---------------------------------------


// 可以使用前後一對的"三個雙引號"來標示字串，
// 其中可以包含換行、空白行、" (兩個以下的雙引號) 、字串插入。
// 注意：前後的三個雙引號必須獨立一行！
let quotation = """
        Even though there's whitespace to the left,
        the actual lines aren't indented.
            Except for this line.
        Double quotes ("") can appear without being escaped.
        I still have \(apples + oranges) pieces of fruit.
        """
print(quotation)


//  ████  █████  █      █      █████   ████  █████  █████  █████  █   █
// █      █   █  █      █      █      █        █      █    █   █  ██  █
// █      █   █  █      █      █████  █        █      █    █   █  █ █ █
// █      █   █  █      █      █      █        █      █    █   █  █  ██
//  ████  █████  █████  █████  █████   ████    █    █████  █████  █   █


//===============集合型別 (Collection Types) /Compound value (複合值) ===============
/*
 Swift提供了三種主要集合型別，稱為陣列(array)、集合(set)和字典(dictionary)，用於儲存"值的集合"。
 陣列是有順序值的集合。 集合 (set) 是唯一值的無序集合。 字典是鍵值 (key-value) 關聯的無序集合。
*/
/*
{}大括號／花括號
[]中括號／方括號
()小括號／圓括號
*/
// 使用中括號建立陣列和字典 ([]) ，並透過在中括號中寫上索引或鍵來存取它們的元素。
// 最後一個元素後允許使用逗號。



// █████  █████  █████  █████         █████  █████           █      █
//     █  █   █      █  █             █   █      █          ██     ██
// █████  █   █  █████  █████  █████  █   █  █████  █████    █      █
// █      █   █  █          █         █   █      █           █      █
// █████  █████  █████  █████         █████  █████         █████  █████
//
//  
//
//  ███   ████   ████    ███   █   █
// █   █  █   █  █   █  █   █   █ █
// █████  ████   ████   █████    █
// █   █  █ █    █ █    █   █    █
// █   █  █  ██  █  ██  █   █    █


//------------------------陣列------------------------
// 使用中括號建立陣列
// 最後一個元素後允許使用逗號
var fruits = ["strawberries", "limes", "tangerines",]
//"讀取"陣列的元素，使用中括號，在其中給定從 0 起算的索引值 (index)
fruits[0]
fruits[1]
fruits[2]


// fruits[3]     // error: Execution was interrupted (執行階段錯誤，App會閃退)


// 觀察陣列的元素個數
fruits.count

// 在陣列中的尾端新增元素
fruits.append("apple")
fruits.append("blueberries")

print(fruits)
fruits.count

fruits[3]  // 因為已經用 append 新增元素，所以此時不會出錯了

// 以現有的索引值來"修改"陣列元素
fruits[1] = "grapes"

fruits // ["strawberries", "grapes", "tangerines", "apple", "blueberries"]

// 移除指定位置的陣列元素
fruits.remove(at: 2)
fruits // ["strawberries", "grapes", "apple", "blueberries"]


// 補充：
// swift 的 API Design Guidelines
// 有解釋了為什麼使用 fruits.remove(at: 2) 而不是 fruits.remove(2)
// https://www.swift.org/documentation/api-design-guidelines/#naming


let myFruits = fruits[0] + "," + fruits[2]
// 字串轉大寫，它不會修改到原本 myFrtuis 的值
myFruits.uppercased()  // "STRAWBERRIES,APPLE"
myFruits               // "strawberries,apple"


// 串接陣列(不使用分隔符號)
let concatenatedFruits1 = fruits.joined()
concatenatedFruits1


// 串接陣列(使用分隔符號)
let concatenatedFruits2 = fruits.joined(separator: "/")
concatenatedFruits2


let vegetables = ["小黃瓜","高麗菜"]
// 兩個陣列的串接
let concatenatedArray = fruits + vegetables
concatenatedArray


// 陣列元素位置的對調，它是直接對原本的陣列做修改
fruits.swapAt(0, 2)


// 在指定位置插入元素
fruits.insert("orange", at: 1)


// <方法一>清空陣列
fruits = []


// <方法二>清空陣列
fruits.removeAll()


// 清空陣列選擇哪種方法
// 如果效能不是關鍵問題，並且你想要簡單地清空陣列，可以使用 array = []。
// 如果效能很重要，或者你想要確保所有引用都受到影響，建議使用 array.removeAll()。
// 如果陣列很大，並且你希望保留陣列的容量，請使用 array.removeAll(keepingCapacity: true)。
//
// 總結：
// array = []：重新賦值，建立新的空陣列實例。
// array.removeAll()：直接移除所有元素，保留陣列容量。
// 在大多數情況下，array.removeAll() 是更推薦的方法，特別是在需要考慮效能的情況下。



// <方法一>宣告空陣列
var emptyArray1 = [String]()
// <方法二>宣告空陣列 (官方教材使用此法)
var emptyArray2: [String] = []
// <方法三>宣告空陣列
var emptyArray3 = Array<String>()


// ████   █████   ████  █████  █████  █████  █   █   ███   ████   █   █
// █   █    █    █        █      █    █   █  ██  █  █   █  █   █   █ █
// █   █    █    █        █      █    █   █  █ █ █  █████  ████     █
// █   █    █    █        █      █    █   █  █  ██  █   █  █ █      █
// ████   █████   ████    █    █████  █████  █   █  █   █  █  ██    █



//------------------------字典------------------------
// 建立字典使用[:]，其中的字典的元素以 key:value 的格式建立
// 在資料的結尾允許逗號的存在
// 一般集合的命名為是複數型態，像這邊就是在後面加s
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]


// 確認字典有幾筆資料
occupations.count


// 查詢字典，當 key 不存在時，回報 nil (Null)空值
occupations["kaylee"]


// 查詢字典，當 key 存在時，回傳 value
occupations["Kaylee"]


// 在字典中『新增』一筆"鍵值配對" (key-value pair)
occupations["Perkin"] = "Teacher"
occupations
occupations["Jayne"] = "Public Relations"
occupations


// <方法一>以現存的 key 來修改字典的 value
occupations["Kaylee"] = "工程師"
occupations

// <方法二>使用字典的方法，以現存的 key 來修改字典的 value
occupations.updateValue("船長", forKey: "Malcolm")
occupations


// 移除字典，如果 Key 不存在不會觸發執行階段錯誤，會回報為 nil(NULL) 空值
occupations.removeValue(forKey: "Perkin1")
occupations
occupations.removeValue(forKey: "Perkin")
occupations


// <方法一>清空字典
occupations = [:]

// <方法二>清空字典
occupations.removeAll()


// <方法一>宣告空字典 (最常用)
var emptyDictionary1 = [String: Float]()
// <方法二>宣告空字典 (不建議)
var emptyDictionary2: [String: Float] = [:]
// <方法三>宣告空字典
var emptyDictionary3 = Dictionary<String,Float>()
emptyDictionary3["First"] = 1.11
emptyDictionary3["Second"] = 2
emptyDictionary3

//
//  ████  █████  █████
// █      █        █
//  ███   █████    █
//     █  █        █
// ████   █████    █
//

//-----------------------集合 (Set) ------------------------------
//.........集合型別的雜湊值 (Hash Values for Set Types) ............
/*
 雜湊 (Hash) 是一種將任意輸入的資料轉換為對應識別值輸出的演算法。
 雜湊值就像是輸入資料的「指紋」，可以用來快速識別資料。
 
 型別必須是可雜湊的，才能儲存在集合中——即，型別必須提供一種計算雜湊值的方法。
 雜湊值是一個Int值，對於所有比較相等的物件都是相同的，
 因此，如果 a == b，則 a 的雜湊值等於 b 的雜湊值。


 Swift的所有基本型別 (如String、Int、Double和Bool) 預設是可雜湊的，
 並且可以用作集合的值或字典的鍵。


  (注意：『自定型別』若沒有雜湊值，就不能當作集合的值或字典的鍵。
 您可以透過使您自己的『自定型別』符合 Swift 標準函式庫中的 Hashable 協定
 來將它們用作集合的值或字典的鍵。)
*/


// 驗證相同值的情況下，雜湊值相同
/*
let label = "12"    // 宣告label常數為String型別
print(label.hashValue)
print("12".hashValue)
let width = 94
print(width.hashValue)
print(94.hashValue)
*/

// 建立一個 Character 型別的空集合
var letters: Set<Character> = Set<Character>()
// 確認集合的筆數
print("letters is of type Set<Character> with \(letters.count) items.")


// 在集合中加入一筆資料
letters.insert("a")
// letters now contains 1 value of type Character


// 確認集合的筆數
print("letters is of type Set<Character> with \(letters.count) items.")


// 當集合的型別已知時，可以使用空陣列的語法將集合清空
letters = []
// letters is now an empty set, but is still of type Set<Character>


// 以陣列的列示語法可以建立集合，但必須明確指定為集合型別
//  (實際上背景是以有序的陣列來模擬出無序的集合)
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
// favoriteGenres has been initialized with three initial items


/*
 以陣列的列示語法可以建立集合，但必須明確指定為集合型別
  (集合型別中沒有以<String>明確指出集合的型別，因為陣列所有元素的型別皆相同，集合的型別可以使用陣列型別推測)
*/
var favoriteGenres2: Set = ["Rock", "Classical", "Hip hop"]
// favoriteGenres = []
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}


// 在集合中新增資料
favoriteGenres.insert("Jazz")
print(favoriteGenres.count)


// 刪除集合中存在的資料
favoriteGenres.remove("Rock")
print(favoriteGenres.count)


// 刪除集合中不存在的資料，回報為 nil
favoriteGenres.remove("XYZ")


// 檢查集合中是否包含特定資料
if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}


print("以下列印集合")
// 以 for 迴圈列出[集合]中的資料
for genre in favoriteGenres {
    print("\(genre)")
}


// 對集合執行排序，即可取得以集合元素由小到大排序過後的"陣列"
let sortedFavoriteGenres = favoriteGenres.sorted()
print("以下列印陣列")
// 以 for 迴圈列出集合排序過後的[陣列]資料
for genre in favoriteGenres.sorted() {
    print("\(genre)")
}

//
//  ████  █████  █   █  █████  ████   █████  █             █████  █      █████  █   █
// █      █   █  ██  █    █    █   █  █   █  █             █      █      █   █  █   █
// █      █   █  █ █ █    █    ████   █   █  █             ████   █      █   █  █ █ █
// █      █   █  █  ██    █    █ █    █   █  █             █      █      █   █  ██ ██
//  ████  █████  █   █    █    █  ██  █████  █████         █      █████  █████  █   █
//

//===================流程控制 (Control Flow) ===================
/*
 流程控制的手法：
 1.以條件判斷式來判斷"程式區段" (以{}框選出來的範圍scope) 是否需要執行
 2.以迴圈重複執行特定的"程式區段" (以{}框選出來的範圍scope) ，直到條件不滿足為止，才會離開迴圈
*/

/*
 1.使用if和switch建立條件判斷式
 2.使用for-in、while和repeat-while建立迴圈。
 注意：條件判斷式或迴圈常數周圍的小括號 (Parentheses) 是可以省略的 (optional) 。
      以{}框選出來的執行範圍scope，不能省略大括號{}。
*/
//宣告全域的分數陣列 (global array)
let individualScores = [75, 43, 103, 87, 12]
//宣告全域的團體分數
var teamScore = 0
//以for-in迴圈列出陣列
for score in individualScores  //每次迴圈依序取得一個陣列的元素，代入score常數 (區域常數)
{
    if score > 50  //Bool、Boolean 布林值判斷式 (if必須配合比較操作，如：>、<、>=、<=、==、!=)
        //串接不同的判斷條件在同一個判斷式，可以使用|| (or) && (and)
    {
        teamScore += 3
        //        teamScore = teamScore + 3
    } else {
        teamScore += 1
        //        teamScore = teamScore + 1
    }
}
print(teamScore)

// 您可以在設值的等號之後撰寫 if 或 switch，來根據條件選擇一個值進行常數或變數的設定。
let scoreDecoration =
    if teamScore > 10 {
        "🎉"
    } else {
        ""
    }
// 串接其他字串進行列印
print("Score:", teamScore, scoreDecoration)

// error: C-style for statement has been removed in Swift 3
// 傳統的for迴圈目前已經不允使用在Swift語法中
/*
for(i=0;i<individualScores.count-1;i++)
{
    individualScores[i]
}
*/

// <補充>for-in迴圈正轉，每次加1 (包含上標)
for i in 0...individualScores.count - 1  //[0,1,2,3,4]
{
    individualScores[i]
}

// <補充>for-in迴圈正轉，每次加1 (不含上標)
for i in 0..<individualScores.count  //[0,1,2,3,4]
{
    individualScores[i]
}

// <補充>for-in迴圈反轉，每次減1 (包含上標)
for i in (0...individualScores.count - 1).reversed()  //[4,3,2,1,0]
{
    individualScores[i]
}

// <補充>for-in迴圈反轉，每次減1 (不含上標)
for i in (0..<individualScores.count).reversed()  //[4,3,2,1,0]
{
    individualScores[i]
}

// <補充>for-in迴圈正轉，每次加2 (包含上標)
for i in stride(from: 0, through: individualScores.count - 1, by: 2) {
    individualScores[i]
}

// <補充>for-in迴圈正轉，每次加2 (不含上標)
for i in stride(from: 0, to: individualScores.count, by: 2) {
    individualScores[i]
}

// <補充>for-in迴圈反轉，每次減2 (包含上標)
for i in stride(from: individualScores.count - 1, through: 0, by: -2) {
    i
    individualScores[i]
}

// <補充>for-in迴圈反轉，每次減2 (不含上標)
for i in stride(from: individualScores.count - 1, to: -1, by: -2) {
    i
    individualScores[i]
}
//-------------------------------------------------------------------

//
// █████  █████  █████  █████         █████  █████           █    █████
//     █  █   █      █  █             █   █      █          ██        █
// █████  █   █  █████  █████  █████  █   █  █████  █████    █    █████
// █      █   █  █          █         █   █      █           █    █
// █████  █████  █████  █████         █████  █████         █████  █████
//
//  
//
// █████  ████   █████  █████  █████  █   █   ███   █
// █   █  █   █    █      █    █   █  ██  █  █   █  █
// █   █  ████     █      █    █   █  █ █ █  █████  █
// █   █  █        █      █    █   █  █  ██  █   █  █
// █████  █        █    █████  █████  █   █  █   █  █████
//

//----------選擇值和選擇性型別 (Optional value & Optional Type) ----------
/*
您可以使用if和let一起處理可能缺失的值。 (此語法為optional binding)
這些可能缺失的值表示為選擇值 (optionals) 。
選擇值可能包含一個值，也可能是nil (空值) 。
選擇值必須明確宣告，在型別之後加上一個問號 (？) 。
*/
//宣告非選擇性型別 (可以不明確型別，採用型別推測機制 Type Inference)
var noneOptionalString = "test"
var noneOptionalString2: String  // 正常情況非選擇值不能沒有值
//print(noneOptionalString2)
// error: Variable 'noneOptionalString2' used before being initialized
// 以上 noneOptionalString2 因為非選擇值沒有給值，所以無法配置到記憶體，不能直接使用

//宣告一個optionalString是String型別的包裝盒
var optionalString: String?  //正常情況選擇值可以沒有值，而且已經配置進去記憶體中，所以沒有值 (nil) 時也可以直接使用
optionalString = "Hello"  //將字串放入String型別的包裝盒中
optionalString
//沒有拆開包裝就使用，會看到Optional的包裝盒
//print(optionalString)
//使用!拆開包裝 (forced unwrap強制拆封)
print(optionalString!)

let myString1 = optionalString  //String?型別 (optional type，選擇值可以沒有值)
var myString2 = optionalString!  //String型別 (非選擇值，永遠要有值)
//將String包裝盒清空
//optionalString = nil
optionalString
//當包裝盒為空值時，不可以強制拆封
//optionalString!       //error: Execution was interrupted

print(optionalString == nil)

//<方法一>避免強制拆封造成App當掉的風險：自行檢查包裝盒是否為空，再決定要不要強制拆封
if optionalString == nil {
    print("optionalString為nil")
} else {
    print("optionalString的值是\(optionalString!)")
}

if optionalString != nil {
    print("optionalString的值是\(optionalString!)")
} else {
    print("optionalString為nil")
}

var optionalName: String? = "John Appleseed"
var greeting2 = "Hello!"

// 先比較<方法一>的做法
if optionalName != nil {
    greeting2 = "Hello, \(optionalName!)"
}

// <方法二>避免強制拆封造成App當掉的風險：使用選擇性綁定 (optional binding)
if let name = optionalName  //將選擇值拆封過後，綁定到非選擇值的name (綁定成功自動拆封)
{
    greeting2 = "Hello, \(name)"
}

//《練習4》將optionalName更改為nil。 你得到了什麼問候？ 如果optionalName為nil請新增一個else子句，設定不同的問候語。
optionalName = nil
if let name = optionalName  //將選擇值拆封過後，綁定到非選擇值的name (綁定成功自動拆封)
{
    greeting2 = "Hello, \(name)"
} else  //當選擇值為nil，則綁定失敗，執行else段
{
    greeting2 = "Hello, everyone!"
}

// <方法三>避免強制拆封造成App當掉的風險：使用『??運算符號』 (空值聚合運算符 Nil-Coalescing Operator)
/*
 a ?? b (簡化語法)
 a != nil ? a! : b (完整語法)
*/
// 處理選擇值的另一種方法是使用??運算符號來提供預設值。如果缺少選擇值 (nil) ，則使用預設值。
var nickname: String?  //= nil
let fullName: String = "John Appleseed"
nickname = "Apple"
let informalGreeting = "Hi \(nickname ?? fullName)"  //語法格式：選擇值 ?? 非選擇值 (預設值)
let informalGreeting2 = "Hi \(nickname != nil ? nickname! : fullName)"

// <方法四>避免強制拆封造成App當掉的風險：使用選擇性綁定 (optional binding) 的簡化語法
// 選擇性綁定的完整語法
if let nickname = nickname {
    print("Hey, \(nickname)")
}

// 選擇性綁定的簡化語法：選擇性綁定語法中的常數命名與選擇值一致時，可以省略等號之後的語法
if let nickname  //= nickname
{
    print("Hey, \(nickname)")
}


//
//  ████  █   █  █████  █████   ████  █   █
// █      █   █    █      █    █      █   █
//  ███   █ █ █    █      █    █      █████
//     █  ██ ██    █      █    █      █   █
// ████   █   █  █████    █     ████  █   █
//

// switch 支援任何型別的資料和各種比較操作——它們不僅限於整數和相等式測試。
let vegetable = "red pepper"
// 檢測vegetable內容
switch vegetable
{
case "celery":  //相等式測試：測試其值是否完全等同於"celery"
    print("Add some raisins and make ants on a log.")
//        break     //Swift不需要在每一段case的最後一行撰寫break指令，一但case中的程式執行完成會自動離開
case "cucumber", "watercress":  //or測試
    print("That would make a good tea sandwich.")
//        break
case let x where x.hasSuffix("pepper"):  //先將要比對的vegetable代入x常數，以where條件式比對狀況是否符合
    // (包含大於小於等非相等狀態，都必需以where條件式進行比對)
    print("Is it a spicy \(x)?")
//        break
default:
    //當前面的case無法保證可以攔截得到時，一定要在最後加上dafault段攔截剩餘狀況
    print("Everything tastes good in soup.")
}

//《練習5》
// 嘗試移除default段。你會看到了什麼錯誤？
// error: Switch must be exhaustive

// Switch case的其他參考範例
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount
{
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

/*
您可以使用for-in來列出字典中的項目，藉由提供一對的"常數名稱"，對應每個鍵值配對。
字典是一個無序集合，因此它們在for-in迴圈中的鍵和值是按任意順序列出。
*/
let interestingNumbers = [  //[String:[Int]]
    "Prime": [2, 3, 5, 7, 11, 13],  //質數
    "Fibonacci": [1, 1, 2, 3, 5, 8, 13, 21, 34],  //費式數列
    "Square": [1, 4, 9, 16, 25],  //平方
]

// 紀錄數列中的最大數
var largest = 0
// 外迴圈：for-in迴圈列出字典
for (_, numbers) in interestingNumbers {
    // 內迴圈：for-in迴圈列出陣列
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)

//《練習6》以常數名稱替換_，並追蹤最大數字出現在哪一個數列。
//紀錄數列中的最大數
largest = 0  //最大數的紀錄先歸零
//紀錄數列中出現最大數的種類名稱
var largestKind = ""
//外迴圈：for-in迴圈列出字典
for (kind, numbers) in interestingNumbers {
    //內迴圈：for-in迴圈列出陣列
    for number in numbers {
        if number > largest {
            //紀錄過程中的最大數
            largest = number
            //同時紀錄對應最大數的種類
            largestKind = kind
        }
    }
}
print("最大數：\(largest)出現在\(largestKind)數列")


//-------------<補充>以for-in迴圈同時列出陣列的索引和值-------------
//以下使用前面的陣列測試
//let individualScores = [75, 43, 103, 87, 12]
largest = 0  //最大數的紀錄先歸零
//紀錄陣列中出現最大數的索引值
var largestIndex = 0
for (index, item) in individualScores.enumerated()  //[(0,75),(1,43),(2,103),(3,87),(4,12)]
{
    if item > largest {
        largest = item
        largestIndex = index
    }
}
print("最大數：\(largest)位於陣列的第\(largestIndex+1)個元素")

//
//
// █████  █   █  ████   █      █████   ████
//   █    █   █  █   █  █      █      █
//   █    █   █  ████   █      █████   ███
//   █    █   █  █      █      █          █
//   █    █████  █      █████  █████  ████
//
//

//-------------------------<補充>元組 (Tuples) -------------------------
// 除了熟悉的型別外，Swift還引入了元組等進階型別。元組允許您建立和傳遞值的群組。
// 您可以使用元組在函式中以單一複合值的形式回傳多個值。
// 元組將多個值群組為"單一的複數值" (a single compound value) 。 元組中的值可以是任何型別，不必彼此是相同的型別。
let http404Error = (404, "Not Found", false)
// http404Error is of type (Int, String, Bool), and equals (404, "Not Found", false)
//--------------------------------------------------------------------

/*
 使用while迴圈重複執行一個大括號框出的程式碼區塊 (block of code) ，直到條件不滿足為止。
 repeat-while迴圈的條件可以在結尾處，以確保迴圈至少會執行一次。 (傳統的程式語言稱此迴圈為do-while迴圈)
*/

var n = 2
while n < 100  //while迴圈須先檢測條件是否符合，才會執行第一次
{
    n *= 2
    //n = n * 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while m < 100  //repeat-while迴圈不需事先檢測條件，就會執行第一次
print(m)

// 注意：
// 當第一次執行時，條件一定符合判斷的狀況，不管 while 迴圈或 repeat-while 迴圈執行結果都一樣！

//《練習7》
// 將條件從 m < 100 更改為 m < 0，以檢視當迴圈條件已經為 false 時，while和repeat-while 的行為如何不同。
n = 2
while n < 0  // while迴圈須先檢測條件是否符合，才會執行第一次
{
    n *= 2
    //n = n * 2
}
print(n)

m = 2
repeat {
    m *= 2
} while m < 0  //repeat-while迴圈不需事先檢測條件，就會執行第一次
print(m)

// 注意：當第一次執行時，條件不符合判斷的狀況時，while迴圈和repeat-while迴圈執行結果不一樣！

// 您可以使用..<來建立一個索引的範圍 (range of index) ，在迴圈中來使用這個索引。
var total = 0
for i in 0..<4  // 製作不含上標的索引範圍，也可以使用...製作包含上標的範圍
{
    i
    total += i
}
print(total)

//
// █████  █████  █████  █████         █████  █████           █    █████
//     █  █   █      █  █             █   █      █          ██        █
// █████  █   █  █████  █████  █████  █   █  █████  █████    █        █
// █      █   █  █          █         █   █      █           █        █
// █████  █████  █████  █████         █████  █████         █████      █
//
// 
//
// █████  █   █  █   █   ████  █████  █████  █████  █   █   ████
// █      █   █  ██  █  █        █      █    █   █  ██  █  █
// ████   █   █  █ █ █  █        █      █    █   █  █ █ █   ███
// █      █   █  █  ██  █        █      █    █   █  █  ██      █
// █      █████  █   █   ████    █    █████  █████  █   █  ████
//

//====================函式和閉包 (Functions and Closures) ====================

//---------函式的參數和回傳值 (Function Parameters and Return Values) ---------
/*
使用 func 關鍵字來宣告函式，並給予函式名稱。
在函式名稱之後使用()來定義"參數列表" (parameter list) ，
參數列表包含參數名稱和型別 (以冒號區隔型別，以逗號區隔下一個參數) ，參數預設為"常數"。
以->符號來設定函式的"回傳型別" (return type) ，當函式只有單一回傳值時，不可以設定回傳的名稱。
以{}來指定函式的實作 (implementation) 。
呼叫函式以函式名稱加上()，()裡面傳入對應參數型別的引數 (argument) 來執行函式。
*/

//*********沒有參數的函式 (Functions Without Parameters) *********
//沒有參數的函式，還是必須在參數列表的位置給上一對空白的小括號
func sayHelloWorld() -> String {
    return "hello, world"
}
//呼叫沒有參數的函式，也必須給上一對空白的小括號
print(sayHelloWorld())

//*********具有多個參數的函式 (Functions With Multiple Parameters) 且具有單一回傳值*********
//宣告函式
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."  //函式的回傳值一定在實作的最後一行
}
//呼叫函式，傳入對應的"引數" (參數值) ，忽略函式的回傳值 (return value)
greet(person: "Bob", day: "Tuesday")  //呼叫函式時，預設會把參數名稱，當作"引數標籤" (argument label) 留下

//接取函式的回傳值
let message2 = greet(person: "Perkin", day: "3/12")

//《練習8》刪除day參數，新增一個參數，在問候語中包含今天的特價午餐。
//宣告函式
func greet(person: String, lunch: String) -> String {
    return "\(person)你好！今天的特價午餐是\(lunch)."  //函式的回傳值一定在實作的最後一行
}
//呼叫函式
greet(person: "Perkin", lunch: "排骨飯")

//<補充練習>
//宣告函式
func greet(person: String, day: Int) -> String {
    //<方法一>以if、else if和else進行三段式攔截 (三段實作可以皆不同)
    //    if day > 7
    //    {
    //        return "\(person)你好！"      //函式的回傳值一定在實作的最後一行
    //    }
    //    else if day < 1
    //    {
    //        return "\(person)你好！"      //函式的回傳值一定在實作的最後一行
    //    }
    //    else    //1...7
    //    {
    //        return "\(person)你好！今天是星期\(day)。"      //函式的回傳值一定在實作的最後一行
    //    }
    //<方法二>以if和else進行二段式攔截 (其中一段符合任一條件的實作相同)
    if day > 7 || day < 1 {
        return "\(person)你好！"  //函式的回傳值一定在實作的最後一行
    } else  //1...7
    {
        return "\(person)你好！今天是星期\(day)。"  //函式的回傳值一定在實作的最後一行
    }

}
//呼叫函式
greet(person: "Perkin", day: 8)

//預設情況下，函式使用其參數名稱當作引數標籤。在參數名稱之前撰寫一個自定的引數標籤，或者撰寫_表明不使用引數標籤。
func greet(_ person: String, on day: String) -> String  //參數列表在型別之前有兩個位置：第一個為引數標籤，第二個為參數名稱)

{
    return "Hello \(person), today is \(day)."
}
//呼叫函式
greet("John", on: "Wednesday")

greet("Perkin", on: "Saturday")

//************沒有回傳值的函式 (Functions Without Return Values) ************
func greet(person: String)  //-> Void        //沒有回傳值的函式可以標明函式的回傳型別為Void或省略回傳型別
{
    print("Hello, \(person)!")
    //最後一行不會出現return
}
//呼叫沒有回傳值的函式
greet(person: "Dave")

//*************具有多個返回值的函式 (Functions with Multiple Return Values) *************
//使用元組建立複合值——例如，在函式中回傳多個值。元組的元素可以依名稱或編號來引用。 (元組的每一個位置"不必"是相同型別，陣列必須相同型別)
func calculateStatistics(scores: [Int]) -> (
    min: Int, max: Int, sum: Int
)//函式使用元組進行複合值回傳時，可以為每個元組的位置命名 (以名稱或編號存取) ，也可以不命名 (只能以編號存取) 。
{
    //先設定即將以迴圈的執行來決定的最小值、最大值、總和的初始值
    var min = scores[0]  //以陣列的第一個元素設定為最小值的初始值
    var max = scores[0]  //以陣列的第一個元素設定為最大值的初始值
    var sum = 0  //陣列的總和在迴圈開始之前先設為0

    //以for-in迴圈列出陣列
    for score in scores {
        //替換最大值
        if score > max {
            max = score
        }
        //替換最小值
        else if score < min {
            min = score
        }
        //累計總和
        sum += score
        //        sum = sum + score
    }

    return (min, max, sum)
}
//呼叫函式
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
//以名稱存取元組
statistics.min
statistics.max
statistics.sum
print(statistics.sum)
// Prints "120"

//以編號存取元組
statistics.0
statistics.1
statistics.2
print(statistics.2)

//----------------------巢狀函式 (Nested Function) ----------------------
//函式可以是巢狀架構。巢狀函式可以存取宣告在外部函式中的變數。您可以使用巢狀函式來組織較長或複雜的程式區段。
//宣告外部為巢狀架構的函式
func returnFifteen() -> Int {
    var y = 10
    //宣告內部函式
    func add() {  //組織較長或複雜的程式區段
        y += 5
    }
    //自行執行內部函式 (運作一段較長或複雜的程式區段)
    add()
    return y  //外部函式回傳運作過較長或複雜邏輯的值
}
//呼叫巢狀函式
returnFifteen()

//函式是一級型別 (非次級) 。  (Functions are a first-class type.) 這意味著一個函式可以回傳另一個函式作為其回傳型別，函式也可以出現在參數列表。
//************函式的回傳型別為一個函式************
//宣告外部為巢狀架構的函式
func makeIncrementer() -> ((Int) -> Int) {
    //宣告內部的命名函式
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    //不自行執行內部函式
    return addOne  //將函式回傳給呼叫者執行 (不含函式名稱，即以"匿名函式"回傳)
}

//呼叫函式，取得的回傳值為一個沒有名稱的函式 (匿名函式) ，並且以變數命名此函式 (沒有引數標籤)
var increment = makeIncrementer()
//以變數名稱作為函式名稱執行此函式
increment(7)

//宣告外部為巢狀架構的函式
func makeIncrementer2() -> ((Int) -> Int) {
    //    //宣告內部的命名函式
    //    func addOne(number: Int) -> Int
    //    {
    //        return 1 + number
    //    }
    //以閉包的方式回傳匿名函式
    return { (number: Int) -> Int in return 1 + number }  //將函式回傳給呼叫者執行 (不含函式名稱，即以"匿名函式"回傳)
}

//呼叫函式，取得的回傳值為一個沒有名稱的函式 (匿名函式) ，並且以變數命名此函式 (沒有引數標籤)
increment = makeIncrementer2()
//以變數名稱作為函式名稱執行此函式
increment(7)

//************函式的參數型別為一個函式************
//一個函式可以將另一個函式當作其參數。
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    //for-in迴圈列出list陣列
    for item in list {
        //執行自定判斷邏輯的condition函式
        if condition(item) {
            return true
        }
    }
    return false
}
//宣告"命名函式"，準備傳入第二個參數位置的函式
func lessThanTen(number: Int) -> Bool {
    //自定判斷邏輯為是否小於10
    return number < 10
}
//準備傳入第一個參數的陣列
var numbers = [20, 19, 7, 12]
// <方法一>呼叫函式，傳入命名陣列及命名函式
hasAnyMatches(list: numbers, condition: lessThanTen)

// <方法二>呼叫函式，傳入匿名陣列及匿名函式 (匿名函式就是閉包closure) 較常見！
// 函式實際上是閉包的一個特殊狀況：一個稍後可以呼叫的程式區塊。
// 閉包中的程式可以存取建立閉包的範圍內可用的變數和函式等內容，即使閉包在執行時處於不同的範圍內。
hasAnyMatches(
    list: [20, 19, 7, 12],
    condition: {
        (number: Int) -> Bool  //閉包的參數必須內縮在{}框出的實作段中
        in  //以in關鍵字區隔閉包的實作
        return number < 10  //閉包的實作
    }
)

// <方法三>呼叫函式，傳入匿名陣列及"尾隨閉包" (trailing closure)  最常用！
hasAnyMatches(list: [20, 19, 7, 12]) {
    number  //(number:Int)->Bool
    in
    //    print(number)       //補充測試閉包實作超過一行時
    number < 10  //return number < 10
    //當閉包的實作只有一行時，可以省略return關鍵字 (實作超出一行時，return關鍵字有可能不能省略)
}

// <方法四>呼叫函式，傳入匿名陣列及"尾隨閉包" (trailing closure) ，
// 撰寫閉包時，不為參數列表命名，也不使用in關鍵字，直接以$+索引值，存取閉包參數，來進行實作！
hasAnyMatches(list: [20, 19, 7, 12]) {
    $0 < 10
}

//-----------------陣列的對應處理方法-----------------------
//<方法三>呼叫陣列的對應處理方法，傳入自定處理邏輯，傳入"尾隨閉包"
let mappingResult1 =
    numbers.map {
        number -> String
        in
        return "\(number)"
    }

//注意：若函式的參數只有一個閉包，以尾隨閉包的形式呼叫時，參數列表的一對小括號會消失！
let mappingResult2 =
    numbers.map {
        number  //(number: Int) -> Int
        in
        let result = 3 * number
        return result
    }

//<方法二>呼叫陣列的對應處理方法，傳入自定處理邏輯，傳入自定閉包，維持參數的形式
let mappingResult3 =
    numbers.map({
        (number: Int) -> Int
        in
        let result = 3 * number
        return result
    })

//《練習9》重寫閉包，讓陣列中的所有奇數回傳為零，偶數則維持原值。
//[20, 19, 7, 12]
//[20, 0, 0, 12]
let mappingResult4 =
    numbers.map {
        number
        in
        if number % 2 == 0  //偶數
        {
            return number
        } else  //奇數
        {
            return 0
        }
    }

let mappingResult5 =
    numbers.map {
        number
        in
        if number % 2 != 0  //奇數
        {
            return 0
        } else  //偶數
        {
            return number
        }
    }

// 您有幾個選項可以更簡潔地撰寫閉包。當閉包的型別已知時，
// 例如代理的回call，您可以省略閉包參數的型別、回傳型別或兩者兼而有之。
// 單一敘述的閉包隱含會回傳其唯一敘述的值，所以省略return關鍵字。
let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)

//------------------------------------------------------------------

//------------------------陣列的排序方法-------------------------------
numbers
//執行陣列的預設排序方法，由"小到大"排序，排序到"新陣列"
numbers.sorted()
numbers
//使用預設排序方法，先"小到大"排序，再反轉排序成為"大到小"，排序到"新陣列"
let reversedResult = numbers.sorted().reversed()
for number in numbers.sorted().reversed() {
    number
}

//執行陣列的預設排序方法，在原陣列中由"小到大"排序
numbers.sort()
numbers

//以"自定"排序方法，傳入由小到大排列的比較邏輯，排序到"新陣列"
let newArray1 =
    numbers.sorted {
        num1,
        num2
        in
        return num1 < num2  //回傳num1會不會比num2小
    }

//以"自定"排序方法，傳入由大到小排列的比較邏輯，排序到"新陣列"
let newArray2 =
    numbers.sorted {
        num1,
        num2
        in
        return num1 > num2  //回傳num1會不會比num2大
    }
//原陣列排序沒有變動
numbers

//以"自定"排序方法，傳入由小到大排列的比較邏輯，在"原陣列"排序
numbers.sort {
    num1,
    num2
    in
    return num1 < num2
}
numbers

//以"自定"排序方法，傳入由大到小排列的比較邏輯，在"原陣列"排序
numbers.sort {
    num1,
    num2
    in
    return num1 > num2
}
numbers

//以下為上一個範例的簡化版：沒有為閉包的參數命名，使用$+索引值來存取閉包參數
let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)

//宣告一個元素為字典的陣列
var dicArray = [
    ["ABC": 123, "DEF": 456], ["ABC": 999, "DEF": 654],
    ["ABC": 321, "DEF": 888],
]
//當陣列元素不是單一值 (集合) 時，沒有預設的排序方法，只能操作排序
let newDicArray =
    //此排序方法排序到新陣列
    dicArray.sorted {
        dic1,
        dic2
        in
        //以ABC的key來查詢字典作為排序的邏輯 (字典的查詢回傳為選擇值，需拆封後才能進行比較運算)
        return dic1["ABC"]! > dic2["ABC"]!
    }
//以for-in迴圈列出陣列
for dic in newDicArray {
    //查詢每本字典對應Key的值
    dic["ABC"]!
}

//宣告一個元素為Tuple的陣列
var tupleArray = [
    (a: "xyz", b: 23, c: true), (a: "fff", b: 45, c: false),
    (a: "str", b: 778, c: false),
]
//此排序方法在原陣列排序
tupleArray.sort {
    tuple1,
    tuple2
    in
    //    return tuple1.1 > tuple2.1
    return tuple1.b > tuple2.b
    //以元組的第二個元素進行由大到小排序
}
//確認原地排序過後的陣列
tupleArray


// █████  █████  █████  █████         █████  █████           █    █████
//     █  █   █      █  █             █   █      █          ██    █   █
// █████  █   █  █████  █████  █████  █   █  █████  █████    █    █████
// █      █   █  █          █         █   █      █           █    █   █
// █████  █████  █████  █████         █████  █████         █████  █████
//
//
//
//  ████  █       ███    ████   ████  █████   ████
// █      █      █   █  █      █      █      █
// █      █      █████   ███    ███   █████   ███
// █      █      █   █      █      █  █          █
//  ████  █████  █   █  ████   ████   █████  ████


//=====================物件和類別 (Objects and Classes) =========================
//=====================實體和類別 (Instances and Classes) =======================
// 類別的實體 (instance) 傳統上被稱為物件 (object) 。
// 然而，Swift的"結構" (structure) 和"類別" (class) 在功能上比其他程式語言更接近，
// 因此使用了更通用的術語"實體" (instance) 來取代"物件" (object) 。
/*
使用class關鍵字後面跟著類別名稱來建立類別，以{}框出類別的宣告範圍。
類別中的屬性 (property) 宣告的撰寫方式與常數或變數的宣告方式相同。
類別中的方法 (method) 和函式宣告的撰寫方式相同。
*/
// 宣告Shape類別 (命名需符合型別的命名規則，以大寫開頭的駝峯式命名法命名)
class Shape {
    //以下兩個屬性都有初始值，因此編譯器會"自動賦予"一個不帶參數的初始化方法
    //可讀可寫的"實體儲存屬性" (instance stored property) ：形狀有幾邊
    var numberOfSides = 0
    //唯讀的"實體儲存屬性"：形狀的特性為3D
    let dimention = "3D"  //《練習10》
    //實體方法 (instance method) ：列印形狀有幾邊的方法
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    //《練習10》一個接受引數的方法：列印形狀的相關資訊
    func shapeWithHeight(height: Int) -> String {
        return "這是\(dimention)形狀，高度：\(height)公尺"
    }
}

//《練習10》
// 在上述類別中，用let新增一個常數屬性，並且新增另一個接受引數的方法。
// 新增在類別的範圍中
// 透過在類別名稱之後放上一對小括號來建立類別的"實體" (instance) 。使用點語法來存取實體的屬性和方法。

//產生Shape類別的實體
var shape = Shape()
//使用點語法來存取實體的屬性
shape.numberOfSides
shape.numberOfSides = 7
shape.numberOfSides
shape.dimention
//shape.dimention = "2D"
//error:Cannot assign to property: 'dimention' is a 'let' constant

//使用點語法來存取實體的方法
var shapeDescription = shape.simpleDescription()
shape.shapeWithHeight(height: 5)

//此版本的NamedShape類別缺少一些重要的東西：在建立實體時用來設定類別的"初始化方法" (initializer/constructor) 。
//因此需使用init關鍵字建立一個"初始化方法"。
//宣告NamedShape類別
class NamedShape {
    //因為以下有任一屬性沒有初始值，所以不會自動得到一個初始化方法，初始化方法必須自定，為缺值的屬性補上初始值。
    var numberOfSides: Int = 0
    var name: String

    //定義帶參數的指定初始化方法
    init(name: String) {
        //傳入的引數：name為name屬性補上初值
        self.name = name  //因為參數名稱與屬性名稱重複，此行需使用self關鍵字來指名name屬性
    }
    //定義不帶參數的指定初始化方法
    init() {
        //實作中自己為缺值的屬性補值
        name = "沒有名字的形狀"
    }

    //在實體從記憶體被釋放之前，反初始化方法 (deinitializer) 會自動被呼叫。您不允許自己呼叫反初始化方法。
    deinit  //宣告反初始化方法 (使用deinit關鍵字)
    {
        //在此可以執行一些清理作業
        print("\(name)被釋放！")
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}
// 實體化 NamedShape
var namedShape: NamedShape? = NamedShape(name: "特殊形狀")

// 以點語法存取實體的屬性和方法
// 當實體為選擇值時，串連屬性和方法的動作稱為選擇性串連-Optional Chaining，當串連的任一環節出現nil時，串連即停止，但程式不會觸發執行階段錯誤
namedShape?.numberOfSides
namedShape?.name
namedShape?.numberOfSides = 100
namedShape?.numberOfSides
namedShape?.name = "新的特殊形狀"
namedShape?.name
namedShape?.simpleDescription()

//選擇性串連呼叫，會得到最後屬性或方法回傳值的選擇值，即使原本的屬性或方法並不是回傳選擇值
let shapeName1 = namedShape?.name
let description1 = namedShape?.simpleDescription()

//選擇性串連，也可以配合強制拆封 (!) 運作
let shapeName2 = namedShape!.name

//<方法一>自行判斷是否為nil，再決定是否拆封
if namedShape != nil {
    let shapeName3 = namedShape!.name
}

//<方法二>以選擇性綁定 (optional binding) 語法，配合選擇性串連 (optional chaining) 來自動拆封
if let shameName = namedShape?.name {
    shameName
}

//<方法三>避免強制拆封造成App當掉的風險：使用『??運算符號』 (空值聚合運算符 Nil-Coalescing Operator)
let shaheName4 = namedShape?.name ?? "沒有名稱"

//<方法四>避免強制拆封造成App當掉的風險：使用選擇性綁定 (optional binding) 的簡化語法
//簡化語法不適用於選擇性串連

//主動清空包裝盒 (把選擇值設為nil) ，這時ARC只要發現記憶體已經沒有任何常數或變數在使用，就會自動釋放記憶體
namedShape = nil

/*
補充
關於"類別"使用 let 與 var 的宣告
在 Swift 中，let 和 var 的主要區別在於它們聲明的是常量還是變量。
這個區別會影響到變量本身是否可以被重新賦值，但對於引用類型（如類別的實例）的屬性，情況會有所不同。

讓我們分別來看這兩種情況：

1. 使用 let 聲明類別的實例：
let namedShape = NamedShape(name: "333")
當你使用 let 聲明 namedShape 時，這意味著 namedShape 這個常量一旦被賦予 NamedShape 的實例，就不能再指向另一個不同的 NamedShape 實例。
你不能做類似 namedShape = NamedShape(name: "666") 的操作。

然而，namedShape 這個常量所引用的 NamedShape 實例的屬性（numberOfSides 和 name）仍然可以被修改，因為這些屬性本身是變量（用 var 聲明的）。

例如，以下操作是允許的：
namedShape.numberOfSides = 5
namedShape.name = "Pentagon"
print(namedShape.simpleDescription()) // 輸出 "A shape with 5 sides."
print(namedShape.name) // 輸出 "Pentagon"

2. 使用 var 聲明類別的實例：
var namedShape = NamedShape(name: "333")
當你使用 var 聲明 namedShape 時，namedShape 是一個變量，這意味著你可以重新賦值它，使其指向另一個不同的 NamedShape 實例。

namedShape = NamedShape(name: "777") // 這是允許的
namedShape.numberOfSides = 8
namedShape.name = "Octagon"
print(namedShape.simpleDescription()) // 輸出 "A shape with 8 sides."
print(namedShape.name) // 輸出 "Octagon"

同樣地，由於 numberOfSides 和 name 都是用 var 聲明的，所以它們的值也可以被修改。

*/


//------------------------------------類別的繼承 (inheritance) ---------------------------------------
/*
子類別 (subclass) 在其類別名稱之後包括其父類別名稱，並用冒號分隔。
一個類別沒有要求要是任何標準根類別的子類別，因此您可以根據需要包含或省略父類別。
沒有繼承自任何父類別的類別，稱為基礎類別 (base class) 。
子類別若繼承自父類別，則會自動得到父類別的屬性和方法。
在子類別上覆寫父類別實作的方法，需以override關鍵字標記 (意外地覆寫父類別的方法，而沒有加上override關鍵字，會被編譯器檢測為錯誤。
一個方法實際上不會覆寫父類別中的任何方法，卻加上override關鍵字，編譯器也會檢測出並且報錯。)
*/

//宣告Square為NamedShape的子類別
class Square: NamedShape {
    /*
    以下兩個屬性繼承自NamedShape父類別
    var numberOfSides: Int = 0
    var name: String
    */
    //可讀可寫的屬性：邊長屬性
    var sideLength: Double

    /*
    初始化方法有兩種：
    1.指定初始化方法 (Designated initializer) ：
    "指定初始化方法"是類別的主要初始化方法， "指定初始化方法"會完全初始化該類別的所有屬性 (為缺值的所有屬性補上初值) ，
    並且呼叫適當的父類別的初始化方法，以繼續串連到父類別的初始化過程。
    (記憶重點：指定初始化方法總是"向上代理" delegate up ) 每個類別必須至少有一個"指定初始化方法"。
    
    2.便利初始化方法 (Convenience initializer) ：
    有兩種實作方式，第一種是直接呼叫到相同類別的"指定初始化方法"，第二種是呼叫相同類別中另外的"便利初始化方法"。
     (記憶重點：便利初始化方法總是"橫向代理" delegate cross )
    注意：指定初始化方法會在類別的繼承串中，形成初始化過程的通道 (funnel)
    
     Swift對初始化方法之間的代理呼叫應用了以下三條規則：
     <規則1>
     指定初始化方法必須從其直接的父類別呼叫指定初始化方法。 PS.即"向上代理" delegate up
     <規則2>
     便利初始化方法必須呼叫來自同一類別的另一個初始化方法。 PS.即"橫向代理" delegate cross
     <規則3>
     便利初始化方法最終必須呼叫到指定初始化方法。
    */
    //宣告"指定初始化方法"
    init(sideLength: Double, name: String) {
        /*
        Swift中的類別的初始化是一個兩階段的過程：
        1.第一階段，為類別的每個"儲存屬性" (stored property) 分配了一個初始值。 (即以下的Step1和Step2)
        2.一旦確定了每個儲存屬性的初始狀態，第二階段就會開始，在新的實體正式被使用之前，每個類別都還有機會進一步自定其儲存屬性的初始值。
        (即以下的Step3)
        使用兩階段初始化的過程會使初始化更安全，同時仍然為類別的層次架構 (class hierarchy) 中的每個類別提供完全的靈活性。
        兩階段初始化可以防止在初始化完成之前存取屬性值，並且防止屬性值被另一個初始化方法意外設定為不同的值。
        */
        //-----第一階段-----
        //Step1.先為自己的屬性設定初值
        self.sideLength = sideLength
        //Step2.以super關鍵字來呼叫父類別的初始化方法 (向上代理) ，為繼承自父類別的屬性設定初值
        super.init(name: name)
        //-----第二階段-----
        //Step3.更改原來屬性設定的初始值
        numberOfSides = 4
    }
    //宣告"便利初始化方法"
    convenience override init() {
        //第一種實作：直接呼叫到相同類別的"指定初始化方法"
        self.init(sideLength: 4.99, name: "預設正方形")
    }

    //宣告"便利初始化方法"
    convenience override init(name: String) {
        //第二種實作：呼叫相同類別中另外的"便利初始化方法"
        self.init()
        self.name = name
    }

    //方法：計算正方形面積
    func area() -> Double {
        return sideLength * sideLength
    }
    //以override關鍵字覆寫父類別的方法，替換父類別的"實作" (implementation)
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
    //當函式名稱相同，但函式的型別不同時，視為不同函式，不需要override關鍵字
    func simpleDescription(a: String) -> Double {
        return sideLength
    }
}
//實體化Square
let testSquare = Square(sideLength: 5.2, name: "my test square")
testSquare.name
testSquare.numberOfSides
testSquare.sideLength

testSquare.area()
testSquare.simpleDescription()

testSquare.simpleDescription(a: "testSquare")





// █████  █████  █████  █████         █████  █   █         █████    █
//     █  █   █      █  █             █   █  █   █         █   █   ██
// █████  █   █  █████  █████  █████  █   █  █████  █████  █   █    █
// █      █   █  █          █         █   █      █         █   █    █
// █████  █████  █████  █████         █████      █         █████  █████




//《練習11》製作一個NamedShape的子類別名稱為Circle，該子類別以半徑 (radius) 和名稱 (name) 作為其初始化方法的引數。
// 在Circle類別上實作area()方法和simpleDescription()方法。
// 計算圓面積：pi*radius*radius
Double.pi
Float.pi
//定義圓形類別繼承自NamedShape類別
class Circle: NamedShape {
    /*
    以下兩個屬性繼承自NamedShape父類別
    var numberOfSides: Int = 0
    var name: String
    */
    var radius: Double  //半徑屬性

    init(radius: Double, name: String) {
        //-----第一階段-----
        //Step1. 先為自己的屬性設定初值
        self.radius = radius
        //Step2. 以super關鍵字來呼叫父類別的初始化方法 (向上代理) ，為繼承自父類別的屬性設定初值
        super.init(name: name)
        //-----第二階段-----
        //Step3. 更改原來屬性設定的初始值
        numberOfSides = 1
    }

    //方法：計算圓形面積
    func area() -> Double {
        return Double.pi * radius * radius
    }
    //方法：列印圓形資訊
    override func simpleDescription() -> String {
        return "圓形：\(name)，半徑：\(radius)，面積：\(area())"
    }
}
//測試
var circle = Circle(radius: 3.99, name: "小圓")
circle.name
circle.numberOfSides
circle.radius
circle.area()
String(format: "%.2f", circle.area())
circle.simpleDescription()

circle.radius = 4.33

//重新配置新的Circle實體時，原來的"小圓"的記憶體空間會自動釋放
circle = Circle(radius: 10, name: "大圓")
circle.name
circle.numberOfSides
circle.radius
circle.area()
String(format: "%.2f", circle.area())
circle.simpleDescription()

//------------儲存屬性vs.計算屬性 (Stored Properties vs. Computed Properties) ------------
//除了儲存的簡單屬性之外，屬性還可以有一個getter和setter (計算屬性) 。
//定義正三角形類別
class EquilateralTriangle: NamedShape {
    /*
    以下兩個屬性繼承自NamedShape父類別
    var numberOfSides: Int = 0
    var name: String
    */
    //可讀可寫的儲存屬性：邊長屬性
    var sideLength: Double  //= 0.0
    //注意：初始化方法必須確認為所有缺值的"儲存屬性"補值！ (不必考慮計算屬性)
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    //可讀可寫的計算屬性：總邊長屬性
    var perimeter: Double  //計算屬性只能使用var宣告，不可使用let宣告
    {
        //取值段 getter
        get {
            return 3.0 * sideLength
        }
        //設定段 setter (不能設值到自己的屬性，因為此屬性為計算屬性)
        set  //(aValue)       //如果不想使用預設的newValue常數名稱接取設定值，可以在set關鍵字之後加上()自定接取設定值的常數名稱
        {
            //設定段的實作只能存值到其他的儲存屬性 (由接取到的總邊長回算單邊長度)
            sideLength = newValue / 3.0  //設定段以預設的newValue常數名稱接取設定值
        }
    }
    /*
    <補充練習>以"唯讀計算屬性"來計算三角形面積
    海龍公式：√s (s-a)(s-b)(s-c)
    公式中的a、b、c 是用來代稱三角形的三邊長；而s則是三角形周長的一半，也就是(a+b+c)/2。
    開根號的函式：squrt()
    */
    var area: Double {
        //        get       //唯讀計算屬性可以省略get關鍵字及其{}
        //        {
        let s = perimeter / 2
        return sqrt(s * (s - sideLength) * (s - sideLength) * (s - sideLength))
        //        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
//測試：產生正三角形實體
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
//測試儲存屬性
triangle.name
triangle.sideLength
triangle.numberOfSides
//測試計算屬性的取值
triangle.perimeter
//測試計算屬性的設值
triangle.perimeter = 9.9
triangle.sideLength
triangle.area



// ████   ████   █████  ████   █████  ████   █████  █   █
// █   █  █   █  █   █  █   █  █      █   █    █     █ █
// ████   ████   █   █  ████   █████  ████     █      █
// █      █ █    █   █  █      █      █ █      █      █
// █      █  ██  █████  █      █████  █  ██    █      █
//
//
//
// █████  ████    ████  █████  ████   █   █  █████  ████    ████
// █   █  █   █  █      █      █   █  █   █  █      █   █  █
// █   █  ████    ███   █████  ████   █   █  █████  ████    ███
// █   █  █   █      █  █      █ █     █ █   █      █ █        █
// █████  ████   ████   █████  █  ██    █    █████  █  ██  ████

/*
If you don’t need to compute the property but still need to provide code that’s run before
and after setting a new value, use willSet and didSet. The code you provide is run any time
the value changes outside of an initializer. For example, the class below ensures that the
side length of its triangle is always the same as the side length of its square.

假設你不需要計算屬性，但仍然需要在值的變化之前或之後加入程式碼，可以使用 willSet 和 didSet
willSet 跟 didSet 並不是計算屬性
所以它講的其實是儲存屬性，只是在程式碼的表達上會跟計算屬性有點相像
儲存屬性可以有觸發機制
屬性觀察器 Property Observers （ willSet、didSet ）
監看並回應屬性值的變化
即使新值與屬性目前的值相同，都會觸發屬性觀察器
屬性觀察器並不能加在計算屬性身上
*/
//--------------屬性觀察器 (Property Observers) --------------
/*
屬性觀察器會監看並回應屬性值的變化。每次設定屬性值時都會呼叫屬性觀察器，即使新值與屬性目前的值相同，都會觸發屬性觀察器。
您可以在以下位置新增屬性觀察器：
1.您定義的儲存屬性
2.您繼承的儲存屬性
3.您繼承的計算屬性
對於繼承的屬性，您透過在子類別中覆寫該屬性來新增屬性觀察器。
對於您定義的計算屬性，使用屬性的setter來監看並回應值的變化，而不是嘗試建立屬性觀察器。

您可以選擇在屬性上定義這些觀察器中的一個或兩個：
1.willSet在儲存值之前被呼叫。
2.didSet儲存新值後立即呼叫。
*/

//下面的類別確保了其三角形的邊長始終與其正方形的邊長相同。
//定義"三角形與正方形"類別
class TriangleAndSquare {
    //可讀可寫的儲存屬性：正三角形屬性
    var triangle: EquilateralTriangle
    {
        willSet {
            square.sideLength = newValue.sideLength
        }
        didSet {

        }
    }
    //可讀可寫的儲存屬性：正方形屬性
    var square: Square
    {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        //初始化方法中的實作，不會觸發willSet和didSet (此段實作已經確保正方形與正三角形的邊長一致)
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
//測試
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
triangleAndSquare.square.sideLength

triangleAndSquare.triangle.sideLength

//以下會觸發square屬性的willSet，確保正三角形的邊長與其一致
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
triangleAndSquare.square.sideLength
triangleAndSquare.triangle.sideLength
//以下會觸發triangle屬性的willSet，確保正方形的邊長與其一致
triangleAndSquare.triangle = EquilateralTriangle(sideLength: 30, name: "新三角形")
triangleAndSquare.square.sideLength
triangleAndSquare.triangle.sideLength

class Triangle: EquilateralTriangle {
    override var perimeter: Double
    {
        get {
            return 0
        }
        set {
            //取代儲存屬性的willSet或didSet
        }
    }
}

//在處理選擇值時，你可以在方法、屬性和標註等操作之前寫上?。如果?之前的值是nil，?之後的一切動作會被忽略，整個表達式的值為nil。
// 如果?之前的值不是nil，?之後的所有內容會是未拆封的值。
var optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength  //此處得到的型別為Double? (選擇性串連必然得到選擇值)
let unwrappedSideLength = optionalSquare!.sideLength  //此處得到的型別為Double
optionalSquare = nil
optionalSquare?.sideLength

//選擇性串連配合選擇性綁定，可以測試是否得到最後串連的值，且自動拆封
if let length = optionalSquare?.sideLength {
    print(length)
}


// █       ███   █████  █   █          ████  █████  █████  ████   █████  ████
// █      █   █     █    █ █          █        █    █   █  █   █  █      █   █
// █      █████    █      █            ███     █    █   █  ████   █████  █   █
// █      █   █   █       █               █    █    █   █  █ █    █      █   █
// █████  █   █  █████    █           ████     █    █████  █  ██  █████  ████
//
//
//
// ████   ████   █████  ████   █████  ████   █████  █████  █████   ████
// █   █  █   █  █   █  █   █  █      █   █    █      █    █      █
// ████   ████   █   █  ████   █████  ████     █      █    █████   ███
// █      █ █    █   █  █      █      █ █      █      █    █          █
// █      █  ██  █████  █      █████  █  ██    █    █████  █████  ████


//-------------<補充>惰性儲存屬性 (Lazy Stored Properties) -------------
/*
惰性儲存屬性是指在首次使用之前不會賦予初始值的屬性。
您在var的宣告之前會寫入lazy修飾語來表示惰性儲存屬性。
您必須始終將惰性屬性宣告為變數 (使用var關鍵字)
當屬性的初始值依賴於外部因素時，或當屬性的初始值需要複雜或耗時的計算時，懶惰屬性會很有用，除非需要，否則不應執行。
*/

//下面的範例使用惰性儲存屬性來避免不必要的複雜的類別的初始化。本範例定義了兩個名為DataImporter和DataManager的類別：
//定義DataImporter：此類別模擬開啟外部檔案
class DataImporter {
    /*
    DataImporter is a class to import data from an external file.
    The class is assumed to take a nontrivial amount of time to initialize.
    */
    var filename = "data.txt"
    // the DataImporter class would provide data importing functionality here
    //模擬開檔並寫入陣列的離線資料
}

//定義DataManager類別，模擬將data陣列的資料寫入外部檔案
class DataManager {
    //此惰性儲存屬性，只有在第一次存取時，才會進行DataImporter的初始化
    lazy var importer = DataImporter()
    var data: [String] = []  //var data = [String]()
    // the DataManager class would provide data management functionality here
}

//測試
let manager = DataManager()
//先操作陣列處理離線資料
manager.data.append("Some data")
manager.data.append("Some more data")
//模擬第一次存取惰性屬性時，才將陣列資料寫入外部檔案
manager.importer

/*
class DataManager {

    // 假設這個屬性的初始化成本很高
    lazy var largeDataSet: [Int] = {
        print("初始化 largeDataSet...")

        // 模擬耗時的初始化
        var data: [Int] = []
        for i in 0..<1000000 {
            data.append(i)
        }
        return data
    } ()

    func processData() {
        // 只有在需要時才會初始化 largeDataSet
        print("開始處理資料...")
        print("資料集中的第一個數字：\(largeDataSet[0])")
    }
}

let manager = DataManager()
manager.processData()


在這個範例中，largeDataSet 屬性只有在 processData() 函數第一次存取它時才會初始化。
如果從未呼叫 processData()，則 largeDataSet 永遠不會初始化。

*/

// █████  █   █  █   █  █   █  █████  ████    ███   █████  █████  █████  █   █   ████
// █      ██  █  █   █  ██ ██  █      █   █  █   █    █      █    █   █  ██  █  █
// █████  █ █ █  █   █  █ █ █  █████  ████   █████    █      █    █   █  █ █ █   ███
// █      █  ██  █   █  █   █  █      █ █    █   █    █      █    █   █  █  ██      █
// █████  █   █  █████  █   █  █████  █  ██  █   █    █    █████  █████  █   █  ████


//==============列舉和結構 (Enumerations and Structures) ==============
//使用enum建立列舉。跟類別和所有其他命名型別一樣，列舉可以有與之關聯的方法。
//定義撲克牌列舉Rank
enum Rank: Int, CaseIterable  //可以使用字串或浮點數作為列舉的"原始型別" (raw type) ，使用rawValue屬性存取列舉case的原始值。
{
    case ace = 1
    //列舉的原始值 (rawValue) 預設從0起算，也可以自定起算的值，以後每一個case自動加1
    case two, three, four, five, six, seven, eight, nine, ten  //2-10
    case jack, queen, king  //11-13
    //列舉也可以定義方法
    func simpleDescription() -> String {
        //檢測列舉實體本身
        switch self
        {
        //先攔截圖像牌，回傳圖像的說明
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        //攔截2-10號牌，回傳對應數字的文字
        default:
            return String(self.rawValue)
        }
    }
}

// 測試
// 產生列舉實體
// <方法一> 以列舉的型別點出個別的case
let ace = Rank.ace
let aceRawValue = ace.rawValue  //只有帶原始值時，才可以使用rawValue

// 產生列舉實體
// <方法二> 當列舉帶原始值時，可以使用帶 rawValue 參數的"可失敗初始化方法" (Failable Initializers) 來取得列舉實體，此時型別為選擇性型別
var rank = Rank(rawValue: 14)  //當傳入rawValue的值不在列舉的範圍內時，回報為nil

rank = Rank(rawValue: 5)
rank?.rawValue

if let rank = Rank(rawValue: 5) {
    print(rank.rawValue)
    rank.simpleDescription()
}

if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
}

if let convertedRank = Rank(rawValue: 13) {
    let threeDescription = convertedRank.simpleDescription()
}

//《練習12》撰寫一個函式，透過比較兩個原始值來比較兩個Rank值。
func compare(rank1: Rank, rank2: Rank) -> String {
    if rank1.rawValue < rank2.rawValue {
        return "rank1:\(rank1.rawValue)比rank2:\(rank2.rawValue)小"
    } else if rank1.rawValue > rank2.rawValue {
        return "rank1:\(rank1.rawValue)比rank2:\(rank2.rawValue)大"
    } else {
        return "rank1:\(rank1.rawValue)和rank2:\(rank2.rawValue)一樣大"
    }
}

compare(rank1: .eight, rank2: .king)
compare(rank1: .queen, rank2: .two)
compare(rank1: .five, rank2: .five)

compare(rank1: Rank(rawValue: 5)!, rank2: Rank(rawValue: 11)!)

//列舉也可以沒有原始值
//定義撲克牌的花色列舉 (沒有帶原始值)
enum Suit: Int, CaseIterable  //原範例不帶原始值
{
    //黑桃,紅心,方塊,梅花
    case spades, hearts, diamonds, clubs
    //列印花色資訊
    func simpleDescription() -> String {
        switch self
        {
        case .spades:
            return "♠️"
        case .hearts:
            return "❤️"
        case .diamonds:
            return "♦️"
        case .clubs:
            return "♣️"
        }
    }
    //《練習13》
    func color() -> String {
        switch self
        {
        case .spades, .clubs:
            return "黑色"
        case .hearts, .diamonds:
            return "紅色"
        }
    }

}
//測試
//當列舉不帶原始值時，沒有可失敗初始化方法，唯一取得列舉實體的作法只有上面的<方法一>
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

//《練習13》在Suit中新增一個color()方法，該方法在黑桃和梅花時會回傳"黑色"，在紅心和方塊時會回傳"紅色"。

hearts.color()

Suit.spades.color()
Suit.spades.simpleDescription()

//
// █████  █████  █████  █████         █████  █   █         █████  █████
//     █  █   █      █  █             █   █  █   █         █   █      █
// █████  █   █  █████  █████  █████  █   █  █████  █████  █   █      █
// █      █   █  █          █         █   █      █         █   █      █
// █████  █████  █████  █████         █████      █         █████      █
//

//-------------<補充>可失敗初始化方法 (Failable Initializers) -------------
//宣告Animal類別 (原範例為struct)
class Animal {
    let species: String  //唯讀的儲存屬性：品種屬性
    //定義可失敗初始化方法，實作在特定情況下會回傳nil
    init?(species: String) {
        //假定品種為空白字串時，無法製作出Animal的實體 (instance)
        if species.isEmpty { return nil }
        self.species = species
    }
}

//<方法一>使用可失敗初始化方法產生Animal實體
let someCreature = Animal(species: "Giraffe")
// someCreature is of type Animal?, not Animal

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

//<方法二>使用可失敗初始化方法產生Animal實體
if let giraffe = Animal(species: "Giraffe") {
    print("An animal was initialized with a species of \(giraffe.species)")
}
//測試品種空白，無法產生Animail實體
if let giraffe = Animal(species: "") {
    print("An animal was initialized with a species of \(giraffe.species)")
} else {
    print("無法辨識的Animal")
}

//------------列舉的可失敗初始化方法 (Failable Initializers for Enumerations) ------------
//定義溫度單位的列舉 (此列舉不帶原始值，不會自動得到一個帶rawValue參數的可失敗初始化方法)
enum TemperatureUnit {
    case kelvin  //絕對溫度
    case celsius  //攝氏溫度
    case fahrenheit  //華氏溫度
    //自己定義一個可失敗初始化方法
    init?(symbol: Character) {
        //以對應溫度單位的三種字元來取得列舉實體，若字元不對應則回傳nil
        switch symbol
        {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        //若字元不對應則回傳nil
        default:
            return nil
        }
    }
}
//以可失敗初始化方法取得列舉實體
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

//以可失敗初始化方法無法列舉實體時 (傳入不合法字元)
let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This isn't a defined temperature unit, so initialization failed.")
}

//------------列舉帶rawValue參數的可失敗初始化方法 (Failable Initializers for Enumerations with Raw Values) ------------
//定義溫度單位的列舉 (此列舉帶原始值，會自動得到一個帶rawValue參數的可失敗初始化方法)
enum TemperatureUnit2: Character {
    case kelvin = "K"
    case celsius = "C"
    case fahrenheit = "F"
}

//以可失敗初始化方法取得列舉實體
let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
if fahrenheitUnit2 != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// Prints "This is a defined temperature unit, so initialization succeeded."

//以可失敗初始化方法無法列舉實體時 (傳入不合法字元)
let unknownUnit2 = TemperatureUnit2(rawValue: "X")
if unknownUnit2 == nil {
    print("This isn't a defined temperature unit, so initialization failed.")
}

//---------列舉帶原始值與不帶原始值---------
//定義CompassPoint1列舉 (不帶原始值)
enum CompassPoint1 {
    case north
    case south
    case east
    case west
}
//取得列舉實體
let cp1 = CompassPoint1.east
cp1.hashValue  //此列舉實體不帶原始值，沒有rawValue屬性可以使用 (此屬性為雜湊值)

//定義CompassPoint2列舉 (帶原始值Int)
enum CompassPoint2: Int {
    case north = 1
    case south
    case east
    case west
}
//取得列舉實體<方法一>
var cp2: CompassPoint2? = CompassPoint2.east
cp2?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

//取得列舉實體<方法二>
cp2 = CompassPoint2(rawValue: 2)
cp2!.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

//定義CompassPoint3列舉 (帶原始值Character)
enum CompassPoint3: Character {
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"
}
//取得列舉實體<方法一>
var cp3: CompassPoint3? = CompassPoint3.east
cp3?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

//取得列舉實體<方法二>
cp3 = CompassPoint3(rawValue: "E")
cp3!.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

//定義CompassPoint4列舉 (帶原始值String)
enum CompassPoint4: String {
    case north
    case south
    case east
    case west = "w"  //不使用String預設的原始值，可以自行指定
}
//取得列舉實體<方法一>
var cp4: CompassPoint4? = CompassPoint4.east
cp4?.rawValue  //此列舉實體帶String原始值，有rawValue屬性可以使用，String原始值預設為case名稱

//取得列舉實體<方法二>
cp4 = CompassPoint4(rawValue: "north")
cp4!.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

cp4 = CompassPoint4(rawValue: "west")
cp4 = CompassPoint4(rawValue: "W")
cp4 = CompassPoint4(rawValue: "w")

//定義CompassPoint5列舉 (帶原始值Double)
enum CompassPoint5: Double {
    case north
    case south
    case east
    case west = 3.3
}
//取得列舉實體<方法一>
var cp5: CompassPoint5? = CompassPoint5.east
cp5?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用，Double原始值預設為0.0~3.0

//取得列舉實體<方法二>
cp5 = CompassPoint5(rawValue: 2)
cp5?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

cp5 = CompassPoint5(rawValue: 3)
cp5?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

cp5 = CompassPoint5(rawValue: 3.3)
cp5?.rawValue  //此列舉實體帶原始值，有rawValue屬性可以使用

//-------------列出列舉的所有case (Iterating over Enumeration Cases) -------------
//定義Beverage(飲料)列舉
enum Beverage: Int, CaseIterable  //引入CaseIterable協定 (protocol) ，會取得allCases屬性，才能使用for-in迴圈列出所有case
{
    case coffee, tea, juice
}
//產生Beverage實體
let beverage = Beverage.tea

//取得所有列舉case實體的陣列<方法一>配合CaseIterable協定
let beverages = Beverage.allCases
//以for-in迴圈列出陣列
for beverage in beverages {
    //以特定"列舉實體"進行處理
    print(beverage)
}

//取得所有列舉case實體的陣列<方法二>配合CaseIterable協定
for beverage in Beverage.allCases {
    //以特定"列舉實體"進行處理
    print(beverage)
}

//取得所有列舉case的實體<方法三>如果列舉帶Int原始值時，可以自行指定原始值範圍，以帶rawValue參數的可失敗初始化方法製作列舉實體
for i in 0...2 {
    //以特定"列舉實體"進行處理
    print(Beverage(rawValue: i)!)
}

//取得列舉中case的數量 (由case的陣列個數取得)
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")



//  ███    ████   ████  █████   ████  █████   ███   █████  █████  ████          █   █   ███   █      █   █  █████   ████
// █   █  █      █      █   █  █        █    █   █    █    █      █   █         █   █  █   █  █      █   █  █      █
// █████   ███    ███   █   █  █        █    █████    █    █████  █   █         █   █  █████  █      █   █  █████   ███
// █   █      █      █  █   █  █        █    █   █    █    █      █   █          █ █   █   █  █      █   █  █          █
// █   █  ████   ████   █████   ████  █████  █   █    █    █████  ████            █    █   █  █████  █████  █████  ████
//
//
//
// █████  █████  ████          █████  █   █  █   █  █   █
// █      █   █  █   █         █      ██  █  █   █  ██ ██
// ████   █   █  ████          █████  █ █ █  █   █  █ █ █
// █      █   █  █ █           █      █  ██  █   █  █   █
// █      █████  █  ██         █████  █   █  █████  █   █



//-------------列舉的關聯值 (Associated Values for Enumeration) -------------
// 可以定義Swift列舉來儲存任何給定型別的關聯值，如果需要可以針對每個列舉的情況不同來給每一個case不同的值。
// 例如，一些產品標有UPC格式的"一維條碼" (barcode) ，使用數字0到9。 每個條碼都有一個數字系統，後面是五個製造商碼和五個產品碼。
// 這些前後面各是一個檢查碼，以驗證程式是否已正確掃描。其他產品則標有二維條碼 (QR-Code) ，可以編碼長達2,953個字元的字串。
// 定義Barcode (條碼) 列舉
enum Barcode {
    //注意：列舉的關聯值即是以"元組"的形式，來對應每一個case不同的值
    case upc(Int, Int, Int, Int)  //一維條碼 (UPC形式)
    case qrCode(String)  //二維條碼
}
//取得一維條碼的實體，並且賦予其關聯值
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .upc(1, 23456, 78999, 9)

productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
productBarcode = .qrCode("http://apple.com/tw")

//以下範例以列舉來從伺服器要求日出和日落的時間。伺服器會以請求的資訊來回覆，不然就以錯誤訊息回覆。
//定義ServerResponse列舉
enum ServerResponse {
    case result(String, String)  //伺服器回應日出和日落的時間
    case failure(String)  //伺服器回應錯誤
    case tide(String, String)  //《練習14》伺服器回應漲潮和退潮的時間

    func simpleDescription() -> String {
        //讀取列舉實體中的關聯值
        switch self
        {
        //  case .result(let sunrise, let sunset):
        case let .result(sunrise, sunset):
            return "Sunrise is at \(sunrise) and sunset is at \(sunset)."
        //  case .failure(let message):
        case let .failure(message):
            return "Failure...  \(message)"
        //《練習14》
        case let .tide(rising, ebb):
            return "漲潮：\(rising)，退潮：\(ebb)"
        }
    }
}

//取得伺服器回應的實體
let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

////讀取列舉實體中的關聯值
//switch success
//{
////  case .result(let sunrise, let sunset):
//    case let .result(sunrise, sunset):
//        print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
////  case .failure(let message):
//    case let .failure(message):
//        print("Failure...  \(message)")
//    case let .tide(rising, ebb):
//        print("漲潮：\(rising)，退潮：\(ebb)")
//}

////讀取列舉實體中的關聯值
//switch failure
//{
////  case .result(let sunrise, let sunset):
//    case let .result(sunrise, sunset):
//        print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
////  case .failure(let message):
//    case let .failure(message):
//        print("Failure...  \(message)")
//    case let .tide(rising, ebb):
//        print("漲潮：\(rising)，退潮：\(ebb)")
//}

//<修正>以列舉的方法來進行列舉實體的檢測，可以避免檢測程式重複撰寫
success.simpleDescription()
failure.simpleDescription()

//《練習14》在ServerResponse列舉中新增第三個case (tide~rising,ebb) ，而且在Switch檢測中，也增加第三個case。
let tide = ServerResponse.tide("6:30 am", "8:23 pm")
tide.simpleDescription()

// 使用struct來建立結構，結構支援許多與類別相同的行為，包括方法 (method) 和初始化方法 (initializer) 。
// 結構和類別之間最重要的不同是：當結構實體在程式中傳遞時，總是被複製一份，
// 但類別實體是透過"引用" (reference) 傳遞的 (會"參考"到同一塊記憶體配置空間) 。
// 定義單張撲克牌結構
struct Card {
    // 結構成員與類別屬性的宣告方式相同 (可用var或let) ，結構會自動得到一個"按照成員順序的初始化方法" (memberwise initialier)
    var rank: Rank  //撲克牌牌數的成員
    var suit: Suit  //撲克牌花色的成員
    // 實體方法 (instance method) ：列印單張撲克牌的花色和牌數
    func simpleDescription() -> String {
        return "\(suit.simpleDescription()) \(rank.simpleDescription())"
    }

    // 型別方法 (type method) ：<方法三>以CaseIterable協定取得牌數和花色的實體
    static func fullDeckOfCardsV3() -> [Card]  //以static關鍵字建立"型別方法"
    {
        //先準備撲克牌的空陣列
        var cards = [Card]()

        //外迴圈跑牌數
        for rank in Rank.allCases {
            //內迴圈跑花色
            for suit in Suit.allCases {
                //結構實體在程式中傳遞時，總是被複製一份
                let card = Card(rank: rank, suit: suit)
                //複製一份單張撲克牌，設定給陣列的第一個元素
                cards.append(card)
            }
        }

        //回傳一整副撲克牌
        return cards
    }
}
//測試
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()
//以Card結構來執行回傳一整副撲克牌的"型別方法"
Card.fullDeckOfCardsV3()

Card(rank: .jack, suit: .diamonds).simpleDescription()

//《練習15》撰寫一個全域函式，回傳一個包含一整副撲克牌的陣列，陣列的每個元素包含牌數和花色的組合。
//<方法一>自行設定牌數和花色的範圍
func fullDeckOfCardsV1() -> [Card] {
    //先準備撲克牌的空陣列
    var cards = [Card]()
    //外迴圈跑牌數
    for i in 1...13 {
        //內迴圈跑花色
        for j in 0...3 {
            //結構實體在程式中傳遞時，總是被複製一份
            let card = Card(rank: Rank(rawValue: i)!, suit: Suit(rawValue: j)!)
            //複製一份單張撲克牌，設定給陣列的第一個元素
            cards.append(card)
        }
    }
    //回傳一整副撲克牌
    return cards
}
//呼叫函式取得一整副撲克牌陣列
var cards = fullDeckOfCardsV1()
//以for-in迴圈列出撲克牌陣列
for card in cards {
    print(card.simpleDescription())
}
//<方法二>以CaseIterable協定取得牌數和花色的實體
func fullDeckOfCardsV2() -> [Card] {
    //先準備撲克牌的空陣列
    var cards = [Card]()

    //外迴圈跑牌數
    for rank in Rank.allCases {
        //內迴圈跑花色
        for suit in Suit.allCases {
            //結構實體在程式中傳遞時，總是被複製一份
            let card = Card(rank: rank, suit: suit)
            //複製一份單張撲克牌，設定給陣列的第一個元素
            cards.append(card)
        }
    }

    //回傳一整副撲克牌
    return cards
}
//呼叫函式取得一整副撲克牌陣列
cards = fullDeckOfCardsV2()
//以for-in迴圈列出撲克牌陣列
for card in cards {
    print(card.simpleDescription())
}


// █████  █████  █████  █████         █████  █   █         █████  █████
//     █  █   █      █  █             █   █  █   █         █   █  █   █
// █████  █   █  █████  █████  █████  █   █  █████  █████  █   █  █████
// █      █   █  █          █         █   █      █         █   █  █   █
// █████  █████  █████  █████         █████      █         █████  █████


// █████  █   █  ████   █████         ████   ████   █████  ████     ████
//   █     █ █   █   █  █             █   █  █   █  █   █  █   █    █
//   █      █    ████   █████         ████   ████   █   █  ████     ███
//   █      █    █      █             █      █ █    █   █  █            █
//   █      █    █      █████         █      █  ██  █████  █        ████   █



// █████  █   █   ████  █████   ███   █   █   ████  █████         ████   ████   █████  ████    ████
//   █    ██  █  █        █    █   █  ██  █  █      █             █   █  █   █  █   █  █   █  █
//   █    █ █ █   ███     █    █████  █ █ █  █      █████         ████   ████   █   █  ████    ███
//   █    █  ██      █    █    █   █  █  ██  █      █             █      █ █    █   █  █          █
// █████  █   █  ████     █    █   █  █   █   ████  █████         █      █  ██  █████  █      ████   █



//-------<補充>型別屬性 vs. 實體屬性 (Type Properties vs. Instance Properties) --------
//-----------<補充>型別方法 vs. 實體方法 (Type Methods vs. Instance Methods) ----------
struct SomeStructure {
    //@MainActor:In Swift structures, enumerations, and classes primarily arises when that property is intended to be accessed or modified only on the main thread, especially within the context of UI frameworks like UIKit.
    //型別的可讀可寫儲存屬性
    @MainActor static var storedTypeProperty = "Some value."
    //型別的唯讀計算屬性
    static var computedTypeProperty: Int {
        return 1
    }
    //型別方法
    static func someTypeMethod() {

    }
    //實體的可讀可寫儲存屬性 (注意：此屬性為結構成員，當結構成員有預設值時，結構的初始化方法會多一個不需此成員的初始化方法)
    var storedInstanceProperty = "Some value."
    //實體方法
    func someInstanceMethod() {

    }
}
//使用按照成員順序的初始化方法，配置結構實體
var someStructure = SomeStructure(storedInstanceProperty: "abc")
//使用成員預設值的初始化方法，配置結構實體
someStructure = SomeStructure()
//存取實體屬性與實體方法
someStructure.storedInstanceProperty
someStructure.someInstanceMethod()
//存取型別屬性與型別方法
SomeStructure.computedTypeProperty
SomeStructure.storedTypeProperty
SomeStructure.someTypeMethod()

SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)

enum SomeEnumeration {
    case a, b, c
    //型別的可讀可寫儲存屬性
    @MainActor static var storedTypeProperty = "Some value."
    //型別的唯讀計算屬性
    static var computedTypeProperty: Int {
        return 6
    }
    //型別方法
    static func someTypeMethod() {

    }

    //實體的可讀可寫儲存屬性 (注意：此屬性為結構成員，當結構成員有預設值時，結構的初始化方法會多一個不需此成員的初始化方法)
    //    var storedInstanceProperty = "Some value."    //列舉的實體屬性不可使用"儲存屬性"製作
    //Error:Enums must not contain stored properties
    //可讀可寫的實體計算屬性
    var computedInstanceProperty: Int
    {
        get {
            return 1
        }
        set {

        }
    }

    //實體方法
    func someInstanceMethod() {

    }
}

// 使用按照成員順序的初始化方法，配置結構實體
var someEnumeration = SomeEnumeration.a
// 存取實體屬性與實體方法
someEnumeration.computedInstanceProperty
someEnumeration.someInstanceMethod()
// 存取型別屬性與型別方法
SomeEnumeration.computedTypeProperty
SomeEnumeration.storedTypeProperty
SomeEnumeration.someTypeMethod()

class SomeClass {
    // 型別的可讀可寫儲存屬性
    @MainActor static var storedTypeProperty: String = "Some value."
    // 不能覆寫的唯讀型別計算屬性，使用static關鍵字時，不能讓子類別覆寫此段實作
    static var unoverideableComputedTypeProperty: Int {
        return 27
    }
    // 類別中的型別計算屬性，您也可以使用class關鍵字來允許子類別覆寫父類別的實作
    // 可以覆寫的型別唯讀計算屬性
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
    //不能覆寫的型別方法
    static func someUnoverideableTypeMethod() {

    }
    // 可以覆寫的型別方法
    class func someOverideableTypeMethod() {

    }
    //----------------------------------------------------------------
    // 實體的可讀可寫儲存屬性 (注意：此屬性為結構成員，當結構成員有預設值時，結構的初始化方法會多一個不需此成員的初始化方法)
    var storedInstanceProperty: String = "Some value."
    // 實體的可讀可寫計算屬性
    var computedInstanceProperty: String
    {
        get {
            return ""
        }
        set {

        }
    }
    // 實體方法
    func someInstanceMethod() {

    }
}

// 測試
let someClass = SomeClass()
// 存取實體屬性與實體方法
someClass.computedInstanceProperty
someClass.storedInstanceProperty
someClass.someInstanceMethod()

// 存取型別屬性與型別方法
print(SomeClass.unoverideableComputedTypeProperty)
SomeClass.overrideableComputedTypeProperty
SomeClass.storedTypeProperty
SomeClass.someUnoverideableTypeMethod()
SomeClass.someOverideableTypeMethod()

// 宣告"SomeSubClass"子類別繼承自"SomeClass"父類別
class SomeSubClass: SomeClass {
    // 繼承自父類別的型別唯讀計算屬性，可以覆寫為可讀可寫 (注意：如果要繼續允許SomeSubClass的子類別可以覆寫此實作，應使用class關鍵字，否則可以改用sstatic關鍵字)
    override static var overrideableComputedTypeProperty: Int
    {
        get {
            return 1
        }
        set {

        }
    }
    // 覆寫父類別的型別方法
    override class func someOverideableTypeMethod() {

    }
    //---------------------------------------------------------
    // 覆寫實體可讀可寫的計算屬性，不能覆寫成唯讀計算屬性
    override var computedInstanceProperty: String
    {
        get {
            return ""
        }
        set {

        }
    }
    // 覆寫實體方法
    override func someInstanceMethod() {

    }
}
//--------------------------------------------------------------------





/*
Properties
In addition to simple properties that are stored, properties can have a getter and a setter.

除了儲存的簡單屬性之外，屬性還可以有一個 getter 和 setter（計算屬性）。
實體的屬性有兩種，一種是實體的儲存屬性，另一種是實體的計算屬性。
計算屬性不能存值，它實際上是存到別的地方。

在 Properties 這章節裡，會講到儲存屬性(Stored Properties)和計算屬性(Computed Properties)

實體屬性 => 儲存屬性 ==> 可讀可寫：用 var 宣告的
                  ==> 單純唯讀：用 let 宣告的
實體屬性 => 計算屬性 ==> 可讀可寫：用 var 宣告的，有 get 有 set
                  ==> 單純唯讀：用 var 宣告的，只有 get
型別屬性 => 儲存屬性
型別屬性 => 計算屬性

*/




//----------------------------比較結構、列舉和類別-----------------------------
/*
Swift中的結構、列舉和類別有很多共同點：
1.定義儲存值的屬性 (property)
2.定義提供功能的方法 (method)
3.定義標註 (subscript) ，以提供使用標註語法[]來存取其值
4.定義初始化方法 (initializer) 來設定其初始狀態
5.使用擴展 (extension) 以擴充"預設實作" (default implementation) 的功能
6.符合協定 (protocol) 以提供某種標準功能
*/

extension SomeEnumeration {
    func abc() {

    }
}

/*
類別具有結構、列舉所沒有的額外功能：
1.繼承 (inheritance) 讓一個類別能夠繼承另一個類別的特徵。
2.型別轉換 (type casting) 允許您在執行時檢查和解釋類別實體的型別。
  注意：實測結構和列舉也有型別轉換的功能！ (僅適用於協定型別，不適用於繼承視角的轉換)
3.反初始化方法 (deinitializer) 使類別的實體能夠釋放其分配的任何資源。
4.引用計數 (reference counting) 允許對一個類別實體進行多次引用。
結構、列舉和類別之間最重要的不同是：當結構、列舉的實體在程式中傳遞時，總是被複製一份 (結構和列舉的記憶體配置空間永遠只有自己的變數或常數在用) ，但類別實體是透過"引用" (reference) 傳遞的 (會"參考"到同一塊記憶體配置空間) 。
*/
//定義解析度結構
struct Resolution {
    //注意：以下結構成員都有初始值，所有會得到多個結構初始化方法 (有些省略了帶初始值的成員)
    var width = 0
    var height = 0
}
//定義影像模式類別
class VideoMode {
    var resolution = Resolution()  //解析度的結構屬性
    var interlaced = false  //預設為非交錯模式
    var frameRate = 0.0  //畫面的更新頻率
    var name: String?  //影像模式的名稱

    deinit {
        if let name  //= name
        {
            print("\(name)被釋放")
        } else {
            print("影像模式的實體被釋放")
        }
    }
}
//產生結構和類別實體
let someResolution = Resolution()
let someVideoMode = VideoMode()
//存取結構實體的屬性
someResolution.width
someResolution.height
//存取類別實體的屬性
someVideoMode.resolution.width
someVideoMode.resolution.height
//變更類別實體解析度的屬性值 (單獨變更成員的值，此語法只適用於Swift)
someVideoMode.resolution.width = 1280
someVideoMode.resolution.height = 720
someVideoMode.name = "720p"
someVideoMode.resolution.width
someVideoMode.resolution.height
//注意：OBJC無法單獨變更結構的成員值，若要變更其中一個成員，只能重設整個結構。但Swift程式語言兩種做法都可以執行
someVideoMode.resolution = Resolution(width: 1280, height: 720)  //此行為是針對結構屬性進行設定，所以是初始化同時進行"複製"行為

//此行為是初始化實體，由單獨的常數抓取記憶體配置空間
let vga = Resolution(width: 640, height: 480)

//----------結構和列舉是值型別 (Structures and Enumerations Are Value Types) ----------
/*
值型別 (value type) 是指當值分配給變數或常數時，或當其傳遞給函式時，其值被複製一份的型別。
事實上，Swift中的所有基本型別 (整數、浮點數、布林、字串、陣列和字典) 都是值型別，並在背景都是以"結構"實作。
Swift中的所有結構和列舉都是值型別。這意味著您建立的任何結構和列舉實體 (以及任何的值型別當它們被當作屬性使用時) 在程式中傳遞時總是被複製。
*/
//此行為為結構的初始化 (非複製)
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd  //此行為是複製

//將cinama的解析度從原本的HD (1920x1080) 改成4K (2048x1536)
cinema.width = 2048
cinema.height = 1536
//因為cinema和hd都是結構實體，是值型別，所以更動其中一個實體，並不會影響其他實體
cinema.width
hd.width

//*************************列舉與結構的行為相同*************************
//定義不帶原始值的方向列舉
enum CompassPoint {
    case north, south, east, west
    //如果列舉的實體方法中，沒有變更實體行為，則不需加mutating關鍵字
    mutating func turnNorth() {
        //        print("abc")
        self = .north  //因為實作中變動了值型別的實體，此方法必須標名為變動實體的方法，必須加上mutating關鍵字
    }
}
//測試
var currentDirection = CompassPoint.west  //此行為是初始化
var rememberedDirection = currentDirection  //此行為是複製 (複製了西方的實體)
currentDirection.turnNorth()  //執行變動方法，將此變數變更為北方的實體

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")

rememberedDirection.turnNorth()

//*******************************************************************

//-------------類別是引用型別 (Classes Are Reference Types) -------------
/*
與值型別不同，當引用型別被分配給變數或常數時，或當它們被傳遞給函式時，不會被複製而是傳遞同一實體的引用。 (會參考到同一個記憶體配置空間)
*/
var tenEighty: VideoMode! = VideoMode()  //此時記憶體配置空間的引用計數為1
tenEighty.resolution = hd  //此行為是複製
tenEighty.interlaced = true  //此行為是更換結構屬性的值 (非複製)
tenEighty.name = "1080i"  //此行為是更換結構屬性的值 (非複製)
tenEighty.frameRate = 25.0  //此行為是更換結構屬性的值 (非複製)

var alsoTenEighty: VideoMode! = tenEighty  //此行為是引用，引用計數為2
alsoTenEighty.frameRate = 30.0  //此行為是更換結構屬性的值 (非複製)
//因為alsoTenEighty與tenEighty是同一塊記憶體配置空間，所以更動其中一個屬性值，另一個會一起變動
tenEighty.frameRate

tenEighty = nil  //此時引用計數減1，降為1
alsoTenEighty = nil  //此時引用計數減1，降為0



// █████  █████  █████  █████         █████  █   █         █████  █████
//     █  █   █      █  █             █   █  █   █         █   █  █   █
// █████  █   █  █████  █████  █████  █   █  █████  █████  █   █  █████
// █      █   █  █          █         █   █      █         █   █      █
// █████  █████  █████  █████         █████      █         █████  █████

//  ████  █████  █   █   ████  █   █  ████   ████   █████  █   █   ████  █   █
// █      █   █  ██  █  █      █   █  █   █  █   █  █      ██  █  █       █ █
// █      █   █  █ █ █  █      █   █  ████   ████   █████  █ █ █  █        █
// █      █   █  █  ██  █      █   █  █ █    █ █    █      █  ██  █        █
//  ████  █████  █   █   ████  █████  █  ██  █  ██  █████  █   █   ████    █


//==============================同時性 (Concurrency) ==============================
//asynchronous (非同步/異步) ：可以跟其他程式碼"同時"運作
//synchronous (同步) ：不能跟其他程式碼"同時"運作
//以下語法是Swift5.7之後增加
//使用async關鍵字來標記"非同步"執行的函式，以表明此函式一旦被呼叫，執行中的實作可以跟其他程式碼"同時"運作。
func fetchUserID(from server: String) async -> Int {
    //以下模擬伺服器需要耗時的運作才能取得UserID
    if server == "primary" {
        return 97
    }
    return 501
}

//你透過在非同步函式前面寫上await來標記對非同步函式的呼叫。
//以下非同步函式，模擬以UserID來從伺服器取得UserName
func fetchUsername(from server: String) async -> String {
    //以await標明此非同步函式呼叫必須得到UserID才能執行下一行
    let userID = await fetchUserID(from: server)  //當必須得到回傳值時，請寫上await關鍵字
    //以下模擬伺服器需要耗時的運作才能以UserID取得UserName
    if userID == 501 {
        return "John Appleseed"
    }
    return "Guest"
}

//使用async let呼叫非同步函式，讓它與其他非同步程式同時執行。 (不能使用async var來呼叫非同步函式)
func connectUser(to server: String) async {
    //以下兩行程式會同時執行
    async let userID = fetchUserID(from: server)
    async let username = fetchUsername(from: server)
    //以下此行程式必須等待前面兩次非同步呼叫完成，得到userID和username才能執行，所以使用await關鍵字
    //    let greeting = "Hello \(await username), user ID \(await userID)"
    let greeting = await "Hello \(username), user ID \(userID)"
    print(greeting)
}

//使用Task從"同步程式"中呼叫"非同步函式"，無需等待它們回傳。
Task {
    await connectUser(to: "primary")
}

//以下語法在Swift6以後新增
//使用任務群組 (task groups) 來構建可以同時執行的程式。
//使用withTaskGroup函式來區分可以執行多任務的區段
let userIDs = await withTaskGroup(of: Int.self) {
    group
    in
    //以for-in迴圈列出伺服器陣列
    for server in ["primary", "secondary", "development"] {
        //新增特定的任務在迴圈中，以多次呼叫非同步函式，進行同時性的運作 (群組任務)
        group.addTask {
            return await fetchUserID(from: server)
        }
    }
    //宣告紀錄從不同伺服器取得UserID的陣列
    var results = [Int]()
    //以for-in迴圈列出任務的執行結果-UserID (得到執行結果時，必須加上await關鍵字)
    for await result in group
    {
        results.append(result)
    }
    //回傳UserID的陣列
    return results
}

//actor與類別相似，只是它們在確保不同的非同步函式可以同時安全地與同一個actor的實體進行互動。
actor ServerConnection
{
    var server: String = "primary"
    //以陣列紀錄正在連線到指定伺服器 (primarty) 的User
    private var activeUsers: [Int] = []
    //此函式模擬特定User會連線到指定的伺服器 (primarty)
    func connect() async -> Int
    {
        //取得連線中的UserID
        let userID = await fetchUserID(from: server)
        // ... communicate with server ...
        //紀錄連線中的UserID
        activeUsers.append(userID)
        return userID
    }
}

//當您呼叫actor的實體方法或存取其實體屬性時，將該程式標記為await，以表明它可能必須等待已經在actor上執行中的其他程式完成。
let server = ServerConnection()
let userID = await server.connect()

//參考教材：https://www.appcoda.com.tw/swift-concurrency-actor/


// ████   ████   █████  █████  █████   ████  █████  █       ████
// █   █  █   █  █   █    █    █   █  █      █   █  █      █
// ████   ████   █   █    █    █   █  █      █   █  █       ███
// █      █ █    █   █    █    █   █  █      █   █  █          █
// █      █  ██  █████    █    █████   ████  █████  █████  ████

//================協定與擴展 (Protocols and Extensions) ================
//使用protocol宣告協定，來指名特定的要求 (requirement)
protocol ExampleProtocol
{
    //要求製作一個"至少唯讀"的實體屬性
    var simpleDescription: String { get }
    //《練習16》加入另外一個協定要求：aInt要求至少可讀可寫
    var aInt:Int {get set}
    
    //要求製作一個實體方法
    mutating func adjust()
}

class ABC:ExampleProtocol
{
    var aInt: Int = 0
    
    var simpleDescription: String = ""
    
    func adjust()
    {
        
    }
}

//類別、列舉和結構都可以採用協定
//宣告SimpleClass類別，繼承自NamedShape類別，並且採用ExampleProtocol協定
class SimpleClass:NamedShape,ExampleProtocol    //類別的繼承必須在冒號之後的第一個位置
{
    
    
    //協定要求：實作simpleDescription屬性為實體"可讀可寫"的儲存屬性
    var simpleDescription: String = "A very simple class."
    //宣告供計算屬性存取其值的"私有"中介屬性 (可讀可寫的儲存屬性) ，此屬性只供定義類別時使用，無法由實體存取
    private var tempInt = 0     //《練習16》
    //協定要求：實作aInt屬性為實體"可讀可寫"的計算屬性
    var aInt: Int
    {
        //取值段
        get
        {
            return tempInt
        }
        //設定段
        set
        {
//            self.aInt = newValue  //此行執行會造成無限遞迴 (infinity recursion)
            tempInt = newValue
        }
    }
    //宣告自己的實體可讀可寫的儲存屬性 (與協定無關)
    var anotherProperty: Int = 69105
    //協定要求：實作adjust實體方法 (注意：因為類別是引用型別，所以即使實作中變動了實體或實體屬性，不需要加上mutating關鍵字！)
    func adjust()
    {
        //實作調整了實體的屬性
        self.simpleDescription += "  Now 100% adjusted."
    }
}
//測試類別實體
var a = SimpleClass()
a.anotherProperty
a.simpleDescription
let aDescription = a.simpleDescription
//執行類別實體的變動方法，變更屬性值
a.adjust()
//確認變動過後的屬性值
a.simpleDescription

a.aInt
a.aInt = 123
a.aInt


//宣告SimpleStructure結構，採用ExampleProtocol協定
struct SimpleStructure: ExampleProtocol
{
    //協定要求：以"結構成員"實作simpleDescription
    var simpleDescription: String = "A simple structure"
    //協定要求：以"結構成員"實作aInt
    var aInt: Int       //《練習16》
    //宣告自己的成員 (與協定無關)
    var anotherProperty: Int = 69105
    //協定要求：實作實體的變動方法 (注意：因為結構是值型別，實作中變動了實體或實體成員，必須加上mutating關鍵字！)
    mutating func adjust()
    {
        //實作調整了實體的成員值
        simpleDescription += " (adjusted)"
    }
}

//測試結構實體
var b = SimpleStructure(aInt: 456)
b.simpleDescription
b.adjust()
let bDescription = b.simpleDescription
b.aInt

//《練習16》
// 在ExampleProtocol中加入另外一個協定要求：aInt要求至少可讀可寫。
// 你必須做什麼改變，才能讓SimpleClass和SimpleStructure仍然符合協定的要求？

//<補充練習>列舉採納協定
enum SimpleEnumeration:Int,ExampleProtocol
{
    case one=1,two,three
    case oneAdjusted,twoAdjusted,threeAdjusted
    //協定要求：以唯讀計算屬性實作
    var simpleDescription: String
    {
        switch self
        {
            case .one:
                return "【一】"
            case .two:
                return "【二】"
            case .three:
                return "【三】"
            case .oneAdjusted:
                return "【一】+"
            case .twoAdjusted:
                return "【二】+"
            case .threeAdjusted:
                return "【三】+"
        }
    }
    //協定要求：以可讀可寫的計算屬性實作
    var aInt: Int
    {
        get
        {
            return self.rawValue
        }
        set
        {
            print("設定此屬性無效")
        }
    }
    // 協定要求：實作adjust方法，若為調整前的one,two,three實體來執行，
    // 則將實體更換成對應的oneAdjusted,twoAdjusted,threeAdjusted，若為調整後的oneAdjusted,twoAdjusted,threeAdjusted則維持原值
    mutating func adjust()
    {
        switch self
        {
            //攔截調整前的one,two,three
            case .one:
                self = .oneAdjusted
            case .two:
                self = .twoAdjusted
            case .three:
                self = .threeAdjusted
            default:    //攔截調整後的oneAdjusted,twoAdjusted,threeAdjusted
                break   //不進行動作
        }
    }
    //宣告自己的屬性 (與協定無關) 列舉不可以使用儲存屬性，只能實作計算屬性
    var anotherProperty: Int
    {
        return 69105
    }
}
//測試列舉實體
var c = SimpleEnumeration.one
c.simpleDescription
c.adjust()
c.simpleDescription

c = SimpleEnumeration(rawValue: 5)!
c.simpleDescription
c.adjust()
c.simpleDescription


/*
基礎協議 (Fundamental Protocols):

Equatable:
    使你的自定義型別可以進行相等性比較 (==, !=)。
    當你需要比較兩個實例是否在邏輯上相等時，你需要讓你的型別遵循這個協議並實作 == 運算符。

Comparable:
    建立在 Equatable 的基礎上，使你的自定義型別可以進行大小比較 (<, >, <=, >=)。
    你需要實作 < 運算符，其他比較運算符通常可以基於 < 和 == 自動合成。

Hashable:
    使你的自定義型別可以被添加到集合類型中，例如 Set 和字典的鍵 (Dictionary 的 Key)。
    遵循這個協議需要實作 hash(into:) 方法來為實例生成一個哈希值。
    如果你的型別也遵循 Equatable，那麼當兩個實例相等時，它們的哈希值也必須相等。

Codable (Encodable & Decodable):
    使你的自定義型別可以進行序列化（編碼為外部格式，如 JSON 或 PropertyList）和反序列化
    （從外部格式解碼回實例）。Codable 是一個組合協議，包含了 Encodable 和 Decodable。

Identifiable:
    通常用於 SwiftUI 中，使你的資料模型可以被唯一地識別。
    遵循這個協議只需要聲明一個名為 id 的屬性，其型別遵循 Hashable 協議。這對於在列表中追蹤和更新元素非常有用。

*/

// █████  █████  █████  █████         █████  █   █         █████    █
//     █  █   █      █  █             █   █  █   █             █   ██
// █████  █   █  █████  █████  █████  █   █  █████  █████  █████    █
// █      █   █  █          █         █   █      █         █        █
// █████  █████  █████  █████         █████      █         █████  █████


//-----------------以協定當作型別 (Protocols as Types) -----------------
// 您可以像任何其他命名型別 (named type) 一樣使用協定名稱——例如，建立具有不同型別但都符合單一協議的物件集合[ExampleProtocol]。
// 當您處理的型別為封裝的協定型別的值時 (當以協定型別的視角來觀看時) ，協定定義之外的方法和屬性無法存取。
// 宣告常數其型別為"實作過"ExampleProtocol協定的"實體"
var protocolValue: ExampleProtocol = a          //原範例為let (注意：此行為為引用，不管是協定的視角或類別實體的視角，參考到是同一塊記憶體配置空間)
//let protocolValue: any ExampleProtocol = a    //any關鍵字為SwiftUI專用，UIKit (Storyboard) 框架，不需要any關鍵字
print(protocolValue.simpleDescription)
//以類別的視角，可以存取類別中的所有屬性和方法，不論是否與協定相關
a.anotherProperty

//以協定型別的視角，"不可以"存取類別中的與協定無關的屬性和方法
//protocolValue.anotherProperty

//以型別轉換的語法，可以操作視角轉換為原來初始化配置進去的型別實體，所以就可以存取到所有的屬性和方法
(protocolValue as! SimpleClass).anotherProperty

protocolValue = b                //注意：此行為為複製，因為b為結構實體，為值型別

b.anotherProperty

print("b.anotherProperty:\(b.anotherProperty)")

(protocolValue as! SimpleStructure).anotherProperty
print("(protocolValue as! SimpleStructure).anotherProperty:\((protocolValue as! SimpleStructure).anotherProperty)")

protocolValue = c

c.anotherProperty
print("c.anotherProperty:\(c.anotherProperty)")

(protocolValue as! SimpleEnumeration).anotherProperty
print("(protocolValue as! SimpleEnumeration).anotherProperty:\((protocolValue as! SimpleEnumeration).anotherProperty)")

//--------------------------選擇性的協定要求 (Optional Protocol Requirements) --------------------------
//協定若有不一定要實作的協定要求，必須使用 @objc protocol 來宣告協定
@objc protocol CounterDataSource
{
    //不一定要實作的協定要求，需使用 @objc optional 關鍵字標示
    @objc optional func increment(forCount count: Int) -> Int   //要求實作增值的方法
    @objc optional var fixedIncrement: Int { get }              //要求實作固定的增值數字
    //以下要求"必需實作" (不使用 @objc optional 關鍵字)  注意：這種要求在開發文件中，通常會出現required或requirement的描述
    var aInt:Int { get set }
}
//定義計數類別 (注意：通常此類別為framework的既有類別)
class Counter
{
    //紀錄累計數量
    var count = 0
    //資料來源屬性要求實作過CounterDataSource協定的實體 (此為代理機制Delegation)
    var dataSource: CounterDataSource?           //此屬性要求實作過協定的代理人
    //累計數量的增值方法 (實作中埋設了由代理人執行代理方法的程式碼)
    func increment()
    {
        if let amount = dataSource?.increment?(forCount: count)
        {
            count += amount
        }
        else if let amount = dataSource?.fixedIncrement
        {
            count += amount
        }
        else if let amount = dataSource?.aInt
        {
            count += amount
        }
    }
}

//宣告ThreeSource類別，繼承自現有類別 (一般不會是NSObject) ，並以此類別實作協定 (注意：通常此類別為自定類別)
class ThreeSource: NSObject, CounterDataSource
//NSObject為OBJC的基礎類別，任何OBJC的子類別，必須以繼承自NSObject (但Swift可以不需基礎類別)
{
    var aInt: Int = 0
    //實作固定以3來增值
    let fixedIncrement = 3
}

//初始化計數類別 (即framework的既有類別)
var counter = Counter()
//指定實作過CounterDataSource協定的代理人 (自己的ThreeSource類別實體，實作過CounterDataSource協定)
counter.dataSource = ThreeSource()  //以固定增值屬性實作的代理人

for _ in 1...4
{
    counter.increment()
    print(counter.count)
}

print(counter.count)

//宣告TowardsZeroSource類別，繼承自現有類別 (一般不會是NSObject) ，並以此類別實作協定 (注意：通常此類別為自定類別)
class TowardsZeroSource: NSObject, CounterDataSource
{
    var aInt: Int = 10
    //實作增值方法
    func increment(forCount count: Int) -> Int
    {
        //不管正負值時，都需往0的方向進行增值
        if count == 0
        {
            return 0
        }
        else if count < 0
        {
            return 1    //負數需加一，往零的方向增值
        }
        else
        {
            return -1  //正數需減一，往零的方向減值
        }
    }
}
//計數類別實體的計數從-4起算
counter.count = -4
//重設資料來源的代理人 (以增值方法實作的代理人)
counter.dataSource = TowardsZeroSource()
for _ in 1...5
{
    counter.increment()
    print(counter.count)
}

print(counter.count)





// █████  █   █  █████  █████  █   █   ████  █████  █████  █   █
// █       █ █     █    █      ██  █  █        █    █   █  ██  █
// █████    █      █    █████  █ █ █   ███     █    █   █  █ █ █
// █       █ █     █    █      █  ██      █    █    █   █  █  ██
// █████  █   █    █    █████  █   █  ████   █████  █████  █   █

//------------------------------------擴展 (Extension) ------------------------------------
//使用extension對"既有型別" (從函式庫或框架匯入的型別、在其他地方宣告的型別) 新增功能，例如新方法和計算屬性 (不能增加儲存屬性) ，以及引入協定。
extension Int: ExampleProtocol
{
    //注意：此處不能實作為唯讀計算屬性，因為協定要求至少可讀可寫
    var aInt: Int
    {
        get
        {
            return 888
        }
        set
        {
            
        }
    }
    
    var simpleDescription: String
    {
        return "The number \(self)"
    }
    
    mutating func adjust()
    {
        self += 42
    }
}

//測試Int實體
print("7.simpleDescription:\(7.simpleDescription)")

7.aInt
print("7.aInt:\(7.aInt)")

//7.adjust()      //error:Cannot use mutating member on immutable value: literals are not mutable

var testInt = 7
testInt.simpleDescription
testInt.aInt
testInt.adjust()
testInt
print("testInt:\(testInt)")

//《練習17》為Double型別撰寫擴展，該擴展會新增一個absoluteValue屬性。
extension Double
{
    var absoluteValue:Double
    {
        if self < 0
        {
            return -self
        }
        else    //self >= 0
        {
            return self
        }
    }
}

print("3.99.absoluteValue:\(3.99.absoluteValue)")

print("-3.99.absoluteValue:\((-3.99).absoluteValue)")

let testDouble = -4.88

print("testDouble.absoluteValue:\(testDouble.absoluteValue)")


//
// █████  ████   ████   █████  ████          █   █   ███   █   █  ████   █      █████  █   █   ████
// █      █   █  █   █  █   █  █   █         █   █  █   █  ██  █  █   █  █        █    ██  █  █
// █████  ████   ████   █   █  ████          █████  █████  █ █ █  █   █  █        █    █ █ █  █ ███
// █      █ █    █ █    █   █  █ █           █   █  █   █  █  ██  █   █  █        █    █  ██  █   █
// █████  █  ██  █  ██  █████  █  ██         █   █  █   █  █   █  ████   █████  █████  █   █   ████
//

//====================錯誤處理 (Error Handling) ====================
//使用任何型別採納Error協定來表示錯誤 (最好使用列舉)
//以列舉來定義印表機的錯誤
enum PrinterError: Error
{
    case outOfPaper         //缺紙
    case noToner            //沒有碳粉
    case onFire             //故障
}
//《練習19》定義其他錯誤
enum OtherError: Error
{
    case unknown
}

//使用throw來拋出錯誤，使用throws來標記可以拋出錯誤的函式。如果在函式中拋出擲錯誤，該函式將立即離開執行，並且呼叫該函式的程式應該處理該錯誤
func send(job: Int, toPrinter printerName: String) throws -> String     //使用throws來標記可以拋出錯誤的函式
{
    //在函式的實作中，設定特定狀況會拋出錯誤
    if printerName == "Never Has Toner"
    {
        throw PrinterError.noToner
    }
    //《練習19》
    else if printerName == "Out Of Paper"
    {
        throw PrinterError.outOfPaper
    }
    //《練習19》
    else if printerName == "On Fire"
    {
        throw PrinterError.onFire
    }
    else if printerName.isEmpty     //else if printerName == ""
    {
        throw OtherError.unknown
    }
    return "Job sent"
}

//處理錯誤有幾種方法：一種方法是使用do-catch，在do區塊中，您透過在do區塊前面寫try來標記可能拋出錯誤的程式。在catch區塊內，除非您給它一個不同的名稱，否則錯誤會自動被賦予預設名稱error。

//沒有錯誤時，未捕捉錯誤可以正常執行
print("\(try send(job: 123, toPrinter: "Test"))")
//有錯誤時，未捕捉錯誤會觸發執行階段錯誤
//print("\(try send(job: 123, toPrinter: "Never Has Toner"))")

//錯誤處理《方法一》使用do-try-catch進行單段式攔截
do
{
    //在do區塊中以try關鍵字呼叫可能會拋出錯誤的函式
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
}
catch
{
    //catch區段自動以預設名稱error捕捉錯誤
    print(error)
}

//《練習18》將印表機名稱更改為"Never Has Toner"，以便send(job:toPrinter:)函式會拋出錯誤。

do
{
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
}
catch
{
    print("Error:\(error)")
    print(error.localizedDescription)
}

do
{
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
}
catch(let err)          //不使用預設的error，需配合小括號和let關鍵字更改預設名稱
{
    print("Err:\(err)")
    print(err.localizedDescription)
}

//錯誤處理《方法二》使用多個處理特定錯誤的catch區塊來攔截錯誤。在catch之後撰寫一個模式，就像在switch中的case之後一樣。
do
{
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
}
catch PrinterError.onFire       //第一個catch區塊：攔截故障的錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError      //第二個區塊：攔截PrinterError的另外兩種錯誤 (沒有碳粉、缺紙的錯誤)
{
    print("Printer error: \(printerError).")
}
catch                                       //第三個區塊：攔截不屬於PrinterError的其他錯誤
{
    print(error)
}

//《練習19》
// 撰寫一段程式在do區塊內拋出錯誤。您需要拋出什麼樣的錯誤，讓第一個catch區塊捕捉並處理錯誤？
// 以及如何讓第二個區塊和第三個區塊捕捉並處給錯誤？
// 讓第一個catch區塊捕捉並處理錯誤
do
{
    let printerResponse = try send(job: 1440, toPrinter: "On Fire")
    print(printerResponse)
}
catch PrinterError.onFire       //第一個catch區塊：攔截故障的錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError      //第二個區塊：攔截PrinterError的另外兩種錯誤 (沒有碳粉、缺紙的錯誤)
{
    print("Printer error: \(printerError).")
}
catch                                       //第三個區塊：攔截不屬於PrinterError的其他錯誤
{
    print(error)
}

//讓第二個catch區塊捕捉並處理錯誤
do
{
    let printerResponse = try send(job: 1440, toPrinter: "Out Of Paper")
    print(printerResponse)
}
catch PrinterError.onFire       //第一個catch區塊：攔截故障的錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError      //第二個區塊：攔截PrinterError的另外兩種錯誤 (沒有碳粉、缺紙的錯誤)
{
    print("Printer error: \(printerError).")
}
catch                                       //第三個區塊：攔截不屬於PrinterError的其他錯誤
{
    print(error)
}

//讓第三個catch區塊捕捉並處理錯誤
do
{
    let printerResponse = try send(job: 1440, toPrinter: "")
    print(printerResponse)
}
catch PrinterError.onFire       //第一個catch區塊：攔截故障的錯誤
{
    print("I'll just put this over here, with the rest of the fire.")
}
catch let printerError as PrinterError      //第二個區塊：攔截PrinterError的另外兩種錯誤 (沒有碳粉、缺紙的錯誤)
{
    print("Printer error: \(printerError).")
}
catch                                       //第三個區塊：攔截不屬於PrinterError的其他錯誤
{
    print(error)
}
//-------------------------------------------------------------------------------------------------------------

//錯誤處理《方法三》使用try?將函式的呼叫結果轉換為選擇值。如果函式拋出錯誤，則丟棄特定錯誤，回傳結果為nil。函式呼叫成功，則得到函式回傳值的選擇值。
//函式呼叫成功，取得回傳結果的選擇值
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
//print(printerSuccess)

//函式呼叫失敗，得到nil
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")

//函式呼叫成功，配合選擇性綁定與法取得自動拆封的回傳結果 (實務最常用)
if let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
{
    print("函式呼叫成功：\(printerSuccess)")
}
else
{
    print("函式呼叫失敗！")
}

// 使用defer撰寫一段程式碼區段，該程式碼區段會在函式中所有其他程式碼之後、函式回傳之前被執行。
// 不論函式是否會拋出錯誤，defer區段的程式碼都會被執行。您可以使用defer將設定程式和清理程式碼並排編寫，即使它們是在不同的時間執行。
// 一開始設定冰箱為關閉的狀態
var fridgeIsOpen = false

//陣列設定冰箱的內容物
let fridgeContent = ["milk", "eggs", "leftovers"]

//定義確認冰箱內容物的函式
@MainActor func fridgeContains(_ food: String) -> Bool
{
    //1.模擬打開冰箱
    fridgeIsOpen = true
    //3,此defer區段會在函式最後即將離開時被執行
    defer
    {
        //模擬離開前一定要關上冰箱
        fridgeIsOpen = false
    }
    //2.確認冰箱是否包含特定食物
    let result = fridgeContent.contains(food)
    //4.函式回傳或直接離開函式
    return result
}
//呼叫確認冰箱內容物的函式
if fridgeContains("banana")
{
    print("Found a banana")
}
//確認執行過後，冰箱會自動關上 (執行defer區段)
print(fridgeIsOpen)


/*
型別屬性的共同點：
  屬於型別本身，而不是型別的任何特定實例。 這意味著你直接通過類別名稱來存取和修改它們，而不是通過創建的物件。
  在整個應用程式的生命週期中，型別屬性只存在一份副本。 所有的類別實例都共享相同的型別屬性。
*/
/*
class 和 static 的主要區別在於繼承和覆寫：
  static 關鍵字：
    用於定義靜態型別屬性。
    不允許子類別覆寫 (override)。子類別可以遮蔽 (shadow) 父類的靜態屬性，提供一個同名的新的靜態屬性，
    但這不是真正的覆寫，父類的原始實現仍然存在。

  class 關鍵字：
    用於定義類別型別屬性。
    允許子類別覆寫 (override)。子類別可以使用 override 關鍵字來提供自己的 getter 和/或 setter 實現，從而實現多型行為。
*/


/*
Cannot override mutable property with read-only property 'xxx'

這句話通常出現在程式碼編譯或執行時的錯誤訊息，表示你在子類別中嘗試覆寫父類別中一個可以修改的屬性 (mutable)，
但你在子類別中將其定義為只能讀取、不能修改的屬性 (read-only)，這是不允許的。

子類別的設計應該保持與父類別一定的行為一致性。如果你在子類別中將一個原本可以修改的屬性變為只能讀取，
可能會破壞依賴於該屬性可變性的程式碼邏輯。
編譯器或程式語言的設計通常會阻止這種不安全的覆寫行為。
*/

/*
nonisolated(unsafe) 和 @MainActor 的用法：

@MainActor：確保在主執行緒上執行
    用途：
    用來標記類別、結構、actor 或函式，強制它們在應用程式的主執行緒 (負責 UI 更新) 上執行。

    場景：
    當你的程式碼需要直接操作使用者介面 (例如更新按鈕文字、修改列表內容) 時，就必須確保這些操作在主執行緒上進行，否則可能會導致 UI 無回應或崩潰。

    效果：
    標記後的程式碼會自動在主執行緒上執行，即使你從背景執行緒呼叫它，Swift 也會幫你切換到主執行緒。
    編譯器會檢查，如果你試圖從非主執行緒直接存取被 @MainActor 標記的成員，會發出警告或錯誤。

    簡單比喻：
    @MainActor 就像一個交通警察，確保所有要更新 UI 的車輛都行駛在正確的「主幹道」上，避免交通混亂。


nonisolated(unsafe)：明確指出不要求在特定執行緒上執行，且不保證安全
    用途：
    用在 actor 中的方法或計算屬性前，明確告知編譯器這個成員不需要在 actor 的隔離域 (通常是某個特定的執行緒或執行環境) 中執行。

    場景：
    當 actor 中的某些操作是純粹的計算，不涉及 actor 的內部狀態，且可以安全地在任何執行緒上執行時。
    非常重要： 通常與一些底層的、需要手動管理並發安全的情況一起使用。使用它表示你手動負責確保並發安全，編譯器不會為你提供保護。

    效果：
    允許這個成員從任何執行緒直接存取，不會有 actor 隔離的限制。
    unsafe 的部分強調了你需要自行處理潛在的並發問題，例如資料競爭。 如果使用不當，可能會導致程式崩潰或資料損壞。

    簡單比喻：
    nonisolated(unsafe) 就像告訴交通警察：「這條小路我清楚它的狀況，不需要你指揮，我自己會注意安全。」但如果駕駛不慎，就可能發生危險。

    總結：
    @MainActor 是為了安全地在主執行緒上更新 UI 而設計的。 它是你進行 UI 相關操作的首選工具。
    nonisolated(unsafe) 是一種更底層的機制，用於 actor 中需要繞過隔離限制的特定情況，
    並且你需要非常清楚自己在做什麼，並自行保證並發安全。 通常情況下，應盡量避免使用 nonisolated(unsafe)，除非你有充分的理由和對並發的深入理解。

*/


//---------------<補充>會回拋錯誤的函式和方法 (Rethrowing Functions and Methods) ---------------
//函式或方法可以使用rethrows關鍵字宣告，以表明只有當其函式引數之一會拋出錯誤時，它才會拋出錯誤。這些函式和方法被稱為回拋函式和回拋方法。 回拋函式和回拋方法必須至少有一個回拋函式作為引數。
func someFunction(callback: () throws -> Void) rethrows
{
    //執行有可能會拋出錯誤函式，但是沒有捕捉錯誤，所以錯誤會回拋給呼叫此someFunction函式的執行者
    try callback()
}

//當傳入的閉包不會拋出錯誤時，不需要捕捉錯誤
someFunction {
    print("傳入沒有拋出錯誤的閉包實作")
}

//當傳入的閉包會拋出錯誤時，必需捕捉錯誤 (以《方法三》捕捉錯誤)
try? someFunction {
    throw OtherError.unknown
}

//<自定排序方法>當傳入的閉包不會拋出錯誤時，不需要捕捉錯誤
fridgeContent.sorted {
    str1, str2
    in
    return str1 > str2
}

//  ████  █████  █   █  █████  ████   █████   ████   ████
// █      █      ██  █  █      █   █    █    █      █
// █ ███  █████  █ █ █  █████  ████     █    █       ███
// █   █  █      █  ██  █      █ █      █    █          █
//  ████  █████  █   █  █████  █  ██  █████   ████  ████

//======================================泛用型別/泛型 (Generics) ======================================
//定義非泛型函式，製作Int陣列
func makeArray1(repeating item: Int, numberOfTimes: Int) -> [Int]
{
    var result = [Int]()
    for _ in 0..<numberOfTimes
    {
         result.append(item)
    }
    return result
}
//執行非泛型函式
makeArray1(repeating: 5, numberOfTimes: 4)

// 定義非泛型函式，製作String陣列
func makeArray1(repeating item: String, numberOfTimes: Int) -> [String]
{
    var result = [String]()
    for _ in 0..<numberOfTimes
    {
         result.append(item)
    }
    return result
}
// 執行非泛型函式
makeArray1(repeating: "test5", numberOfTimes: 4)


// 在"角括號"<>內撰寫一個泛用型別名稱，以建立泛型函式或型別。
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item]
{
    //宣告泛用型別的空陣列
    var result = [Item]()
    for _ in 0..<numberOfTimes
    {
         result.append(item)
    }
    return result
}
//執行泛用型別的函式
makeArray(repeating: "knock", numberOfTimes: 4)

let result = makeArray(repeating: 3.99, numberOfTimes: 4)

//您可以定義泛型的函式和方法，也可以定義泛型的類別、列舉和結構。
// Reimplement the Swift standard library's optional type
enum OptionalValue<Wrapped>
{
    case none
    case some(Wrapped)
    
    func simpleDescription() -> String
    {
        switch self
        {
            case .none:
                return "此列舉實體沒有關聯值"
            case let .some(myValue):
                return "此列舉實體的關聯值：\(myValue)"
        }
    }
}
//取得列舉實體
var possibleInteger: OptionalValue<Int> = .none
possibleInteger.simpleDescription()

possibleInteger = .some(100)
possibleInteger.simpleDescription()


// █████  █████  █████  █████         █████  █   █         █████  █████
//     █  █   █      █  █             █   █  █   █             █  █   █
// █████  █   █  █████  █████  █████  █   █  █████  █████  █████  █████
// █      █   █  █          █         █   █      █         █      █   █
// █████  █████  █████  █████         █████      █         █████  █████

var possibleInteger2 = OptionalValue.some(200.0)
possibleInteger2 = .none
possibleInteger2 = .some(3.99)

//在實作之前使用where來指定一系列的要求 — — 例如，要求型別實作協定、要求兩種型別相同或要求型別具有特定的父類別。
//宣告泛型函式，使用T和U兩種泛型 (必須採納Sequence協定) ，實作中比對T和U是否有任何一個相同元素
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool    //要求型別實作協定
    where T.Element: Equatable, T.Element == U.Element  //where條件式要求：1.T型別的元素必須採納相等協定 2.要求T和U兩種型別相同
{
    for lhsItem in lhs
    {
        for rhsItem in rhs
        {
            if lhsItem == rhsItem
            {
                return true
            }
        }
    }
   return false
}
//執行泛型函式
anyCommonElements([1, 2, 3], [3,5])

//《練習20》修改上述函式，使其回傳一個序列，其中的序列元素是任兩個序列的共同元素。
func anyCommonElements2<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> [T.Element]    //要求型別實作協定
    where T.Element: Equatable, T.Element == U.Element  //where條件式要求：1.T型別的元素必須採納相等協定 2.要求T和U兩種型別相同
{
    //宣告紀錄共同元素的陣列
    var commons = [T.Element]()
    for lhsItem in lhs {

        for rhsItem in rhs {

            if lhsItem == rhsItem {
                commons.append(lhsItem)
            }
        }
    }
   return commons
}
//執行泛型函式
anyCommonElements2([1,3,5,7,9], [7,3,4,1])

//<補充練習1>以上函式改版成只使用一種泛型
func anyCommonElements3<T: Sequence>(_ lhs: T, _ rhs: T) -> [T.Element]    //要求型別實作協定
    where T.Element: Equatable  //where條件式要求：T型別的元素必須採納相等協定
{
    //宣告紀錄共同元素的陣列
    var commons = [T.Element]()
    for lhsItem in lhs {

        for rhsItem in rhs {

            if lhsItem == rhsItem {

                commons.append(lhsItem)
            }
        }
    }
   return commons
}
//執行泛型函式
anyCommonElements3([1,3,5,7,9], [7,3,4,1])

//<補充練習2>相等協定、比較協定、雜湊協定
struct Point3D:Comparable,Hashable  //自定型別最好同時引入Comparable協定和Hashable協定，以確保所有基本操作都可以使用
//注意：Comparable協定及Hashable協定都包含Equatable協定，所以不需要單獨引入Equatable協定
{
    var x:Int
    var y:Int
    var z:Int
    //Equatable提供了預設實作，若不更改預設實作，不必實作以下方法，只需引入Equatable協定即可
    static func == (lhs:Point3D, rhs:Point3D) -> Bool
    {
        return lhs.x+lhs.y+lhs.z == rhs.x+rhs.y+rhs.z
    }
    //Comparable協定要求至少要實作小於的判斷邏輯，其餘的<=、>、>=會自動賦予預設實作 (此文件描述於小於方法的Discussion)
    static func < (lhs: Point3D, rhs: Point3D) -> Bool
    {
//        return lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
        return lhs.x+lhs.y+lhs.z < rhs.x+rhs.y+rhs.z
    }
}

let point1 = Point3D(x: 3, y: 4, z: 5)
let point2 = Point3D(x: 5, y: 4, z: 3)

if point1 == point2
{
    print("兩個點相等")
}
else
{
    print("兩個點不相等")
}

if point1 != point2
{
    print("兩個點不相等")
}
else
{
    print("兩個點相等")
}

if point1 > point2
{
    print("point1 > point2")
}
else if point1 < point2
{
    print("point1 < point2")
}
else
{
    print("point1 == point2")
}

//『自定型別』若沒有雜湊值，就不能當作集合的值或字典的鍵。
var dic = [point1:"第一個點"]

var set:Set<Point3D>




// █████  █   █  ████   █████          ████   ███    ████  █████  █████  █   █   ████
//   █     █ █   █   █  █             █      █   █  █        █      █    ██  █  █
//   █      █    ████   █████         █      █████   ███     █      █    █ █ █  █ ███
//   █      █    █      █             █      █   █      █    █      █    █  ██  █   █
//   █      █    █      █████          ████  █   █  ████     █    █████  █   █   ████

// 型別轉換 (type casting) 是一種檢查實體型別的方法 (way) ，或將該實體視為與其自身類別層次架構中的父類別或子類別。
// Swift中的型別轉換是使用is和as運算符號實作。這兩個運算符號用來檢查值的型別(is)或將值轉換為不同的型別(as)。
// 定義媒體項目類別
class MediaItem {
    var name: String
    init(name: String)
    {
        self.name = name
    }
}

// 以下定義電影和歌曲類別，同樣繼承自媒體項目類別
class Movie: MediaItem {
    var director: String    //導演屬性
    init(name: String, director: String)
    {
        //Step1
        self.director = director
        //Step2
        super.init(name: name)
    }
}

class Song: MediaItem
{
    var artist: String      //作曲者屬性
    init(name: String, artist: String)
    {
        self.artist = artist
        super.init(name: name)
    }
}

//此陣列元素有不同的類別實體，但因為有相同的父類別MediaItem，所以型別推測機制，自動識別此陣列為[MediaItem]型別
let library //:[Any]        //注意：當陣列元素沒有共同的父類別時，只能自己明確宣告為任意型別的陣列
=
[
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley"),
    //14
]


(library[0] as! Movie).director


//  ████  █   █  █████   ████  █  ██  █████  █   █   ████         █████  █   █  ████   █████
// █      █   █  █      █      █ ██     █    ██  █  █               █     █ █   █   █  █
// █      █████  █████  █      ██       █    █ █ █  █ ███           █      █    ████   █████
// █      █   █  █      █      █ ██     █    █  ██  █   █           █      █    █      █
//  ████  █   █  █████   ████  █  ██  █████  █   █   ████           █      █    █      █████

//----------------------型別檢查 (Checking Type) ----------------------
//分別宣告兩個統計電影和歌曲數量的變數
var movieCount = 0
var songCount = 0

//for in迴圈列出library陣列
for item in library {
    if item is Movie        //檢查item是否為Movie的類別實體
    {
        movieCount += 1
        (item as! Movie).director
    }
    else if item is Song    //檢查item是否為Song的類別實體
    {
        songCount += 1
        (item as! Song).artist
    }
}

// ████   █████  █   █  █   █   ████   ███    ████  █████  █████  █   █   ████
// █   █  █   █  █   █  ██  █  █      █   █  █        █      █    ██  █  █
// █   █  █   █  █ █ █  █ █ █  █      █████   ███     █      █    █ █ █  █ ███
// █   █  █   █  ██ ██  █  ██  █      █   █      █    █      █    █  ██  █   █
// ████   █████  █   █  █   █   ████  █   █  ████     █    █████  █   █   ████

print("Media library contains \(movieCount) movies and \(songCount) songs")

//------------------向下轉型 (Downcasting)------------------
/*
特定類別型別的常數或變數，實際上背景可能指的是實際配置的子類別實體。如果您認為情況是這樣的，
您可以嘗試使用型別轉換運算符號向下轉換到子類別的型別 (使用as? 或者as!) 。
 
由於向下轉型可能會失敗，型別轉換運算符號有兩種不同的形式：
1.條件形式(as?)：回傳您嘗試向下轉換的型別的選擇值。
2.強制形式(as!)：嘗試向下轉型，並將轉換結果和強制拆封結合為單一複合作業。
*/
for item in library
{
    if let movie = item as? Movie
    //條件形式的轉型，若轉換成功會回傳選擇值，若轉換失敗則回傳nil。條件形式的轉型，配合選擇性綁定語法可自動拆封。
    {
        print("Movie: \(movie.name), dir. \(movie.director)")
    }
    else if let song = item as? Song
    {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// 注意：
// 型別轉換實際上不會修改實體或變更其值。背景的實體會始終保持不變，它只是被當作被轉換的型別實體來"處理"和"存取"
// (以父類別的視角或子類別的視角處理) 。

// 可以操作"向上轉型" (視角轉回父類別實體) ，但是"向上轉型"一定成功，轉換只需要as關鍵字，不需要條件形式或強制形式
(library[0] as! Movie) as MediaItem

//---------------------Any和AnyObject的型別轉換---------------------
/*
 Swift 為處理非特定型別提供了兩種特殊型別：
 1.Any 型別：可以代表任何型別的實體，包括函式型別。
 2.AnyObject 型別：可以表示任何類別型別的實體。
*/

var things = [Any]()

things.append(0)                // Int 實體其值為0
things.append(0.0)              // Double 實體其值為0
things.append(42)               // Int 實體其值為42
things.append(3.14159)          // Double 實體其值為3.14159
things.append(-2.88)            // Double 實體其值為-2.88
things.append("hello")          // String 實體其值為hello
things.append((3.0, 5.0))       // (Double,Double) 的 Tuple 實體其值為(3.0,5.0)
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))    //Movie實體
things.append({ (name: String) -> String in "Hello, \(name)" })         //閉包實體
things.append([1,3,5])

for thing in things
{
    switch thing
    {
        case 0 as Int:                  //判斷是否為Int型別的實體0
            print("zero as an Int")
        case 0 as Double:               //判斷是否為Double型別的實體0
            print("zero as a Double")
        case let someInt as Int:
            print("an integer value of \(someInt)")
        case let someDouble as Double where someDouble > 0:         //判斷是否為正數的Double值
            print("a positive double value of \(someDouble)")
//        case let someDouble as Double where someDouble < 0:
        case is Double:                                            //判斷是否為負數的Double值
            print("some other double value:\(thing) that I don't want to print")
        case let someString as String:
            print("a string value of \"\(someString)\"")
        case let (x, y) as (Double, Double):
            print("an (x, y) point at \(x), \(y)")
        case let movie as Movie:
            print("a movie called \(movie.name), dir. \(movie.director)")
        case let stringConverter as (String) -> String:
            print(stringConverter("Michael"))
        default:
            print("something else:\(thing)")
    }
}

// 特別注意事項：Any 型別可以表示任何型別的值，包括選擇性型別。如果您使用選擇值，而期望值為Any型別，Swift 會向您發出警告。
// 如果您真的需要使用選擇值作為 Any 值，您可以使用 as 運算符號將選擇值明確轉換為 Any，如下所示：
let optionalNumber: Int? = 3
things.append(optionalNumber)        // Warning(系統建議不要把包裝盒直接丟到Any型別的位置)
//warning: Expression implicitly coerced from 'Int?' to 'Any'

var testThing = things[2]
print(testThing as! Int)

things.append(optionalNumber as Any) // No warning(如果要把包裝盒直接丟到Any型別的位置，要自己明確轉型為Any)
testThing = things[11]
print(testThing as! Int)

//以下是開發建議 (前兩種做法都盡量避免使用)
var newThings = [Any?]()
newThings.append(12)
newThings.append("ABC")

for thing in newThings
{
    if let t = thing as? Int
    {
        print("t:\(t)")
    }
    else if let s = thing as? String
    {
        print("s:\(s)")
    }
}

// █   █  █████  █              ████  █████   ███   █      █████   ████   ████  █████  █   █   ████
// ██  █    █    █             █      █   █  █   █  █      █      █      █        █    ██  █  █
// █ █ █    █    █             █      █   █  █████  █      █████   ███   █        █    █ █ █  █ ███
// █  ██    █    █             █      █   █  █   █  █      █          █  █        █    █  ██  █   █
// █   █  █████  █████          ████  █████  █   █  █████  █████  ████    ████  █████  █   █   ████

// nil coalescing operator ??
// 在 Swift 中，?? 是一個稱為「nil coalescing operator」（nil 合併運算子）的運算符。
// 它的主要作用是提供一個預設值，當一個可選型別（optional type）的值為 nil 時，就使用這個預設值。

// 功能
// ?? 運算符會檢查一個可選型別的值是否為 nil。
// 如果可選型別有值，它會解包（unwrap）這個值，並回傳它。
// 如果可選型別為 nil，它會回傳 ?? 右側提供的預設值。

// 語法
// optionalValue ?? defaultValue
//     optionalValue：一個可選型別的值。
//     defaultValue：一個與 optionalValue 型別相容的預設值。

/* 範例
let optionalName: String? = "John"
let name = optionalName ?? "Guest"
print(name) // 輸出：John

let optionalAge: Int? = nil
let age = optionalAge ?? 0
print(age) // 輸出：0
*/
