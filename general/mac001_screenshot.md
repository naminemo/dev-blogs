## mac 整理截圖

先在桌面新增一個 Screenshot 資料夾
開啓 terminal

把截圖儲存位置指定到資料夾  
`
$ defaults write com.apple.screencapture location ~/Desktop/Screenshot
`

改回預設位置  
`$ defaults write com.apple.screencapture location ~/Users/使用者電腦名稱/Desktop`

修改預設檔名的開頭  
`$ defaults write com.apple.screencapture name ss`

修改預設副檔名，預設為 png，若想改為 jpg，可以使用  
`$ defaults write com.apple.screencapture type jpg`

不包含時間格式  
`$ defaults write com.apple.screencapture "include-date" 0`

恢復時間格式  
`$ defaults write com.apple.screencapture "include-date" 1`

預設是 12 小時制，若要改成 24 小時制請到  
系統設定 > 一般 > 日期與時間  

![ss 2025-05-06 15-01-31](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-06%2015-01-31.jpg)

以上若成功更新的話可以先執行  
`$ killall SystemUIServer`

## 安裝 rename

由於 iMac 截圖預設出來的檔名不是我想要的，使用 rename 來變更它  
先檢查有無 rename  
`$ which rename`

安裝 homebrew  
`$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

安裝 rename  
`$ brew install rename`

在終端機中導航到儲存截圖的資料夾後  
執行下列指令即可   
`$ rename 's/\./-/; s/\./-/;' "ss "*` 

以後要快速整批重新命名截圖出來的檔名  
以後只要執行下列兩行即可

```bash
cd Desktop/Screenshot/
```  

```bash
rename 's/\./-/; s/\./-/;' "ss "*
```
