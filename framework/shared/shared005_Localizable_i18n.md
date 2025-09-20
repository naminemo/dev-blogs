# 多國語系

## 建立檔案
點擊專案資料夾，不是藍色 icon 的那個
新增一個檔案： File → New → Empty File
名稱輸入 Localizable.strings

## 設置選項
如果還沒做過設置的話，很可能會都出現一個 Englisg 的選項。
這樣的話在使用 File inspector 時，會很麻煩，造成其他語系都出不來

所以要先去做設置

點擊藍色專案 icon
在 PROJECT 與 TARGETS 先確認是否選取 PROJECT，
在確認是 PROJECT 後，再點擊 Info。
Info 底下應該會有
Configrations 及 Localizations 這兩個區塊

然後在 Localizations 新增你想要的多國語系配置

## 加入選項
這些選項做好配置後，就能實際加入了。

點擊側邊欄的 Localizable.strings 這支檔案
點擊 Hide or show the inspectorss
點擊 Show the File inspectors
找到 Localization 區塊把要的語系勾選起來即可
