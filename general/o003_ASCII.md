# ASCII

ASCII (美國資訊交換標準碼，American Standard Code for Information Interchange) 是一種文字編碼標準，用來讓電腦用數字來表示英文文字與符號。

## 簡單介紹

- 它是一種 將字元轉換成數字 (編碼) 的系統
- 每個英文字母、數字、標點符號、控制符號都有一個對應的 7-bit 整數編號（0 ~ 127）
- ASCII 是最早期電腦之間傳輸文字資料的基礎

## ASCII 範圍與分類

類別	      範例	                        數值範圍
控制字元	   Enter, Tab, Backspace 等	    0 ~ 31
可顯示符號     英文標點（, . ! ? 等）	     32 ~ 47
數字           0 ~ 9	                   48 ~ 57
大寫英文字母    A ~ Z	                    65 ~ 90
小寫英文字母	a ~ z	                    97 ~ 122
特殊符號	    @, #, $, % 等	            33 ~ 47, 58~64, 等

### 範例：字元與 ASCII 編號

字元	ASCII 編號
'A'	    65
'B'	    66
'a'	    97
'0'	    48
' '     32 (空格)
'\n'    10 (換行)	

### Java 範例

```java
public class ASCIIDemo {
    public static void main(String[] args) {
        char ch = 'A';
        int ascii = ch;
        System.out.println("A 的 ASCII 編碼是: " + ascii); //  65

        int num = 65;
        char character = (char) num;
        System.out.println("65 對應的字元是: " + character); // A
    }
}
```

## 常見問題

### ASCII 是 Unicode 嗎？

不是，但：
- ASCII 是 Unicode 的子集合
- Unicode 的前 128 個字元（0 ~ 127）與 ASCII 完全相同


### 為什麼我們還要了解 ASCII？
- 即使今天常用 Unicode（支援全世界語言），底層資料格式還是廣泛使用 ASCII
- 網路協定（如 HTTP）、程式語言（如 Java、C）、舊系統檔案格式，仍大量用到 ASCII 表示控制碼、字元等