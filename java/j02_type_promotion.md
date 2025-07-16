# Type promotion

當在 Java 中進行數值運算時，Type Promotion (型別提升) 是一種自動發生的行為，Java 會將某些較小的數值類型 (如 byte, short, char) "自動" 提升成 int 或更高的類型來確保運算正確。

## byte

```java
public class TypePromotionExample1 {
    public static void main(String[] args) {
        byte a = 10;
        byte b = 20;
        // byte c = a + b; // 錯誤，a + b 結果是 int 類型
        int c = a + b;      // 正確
        System.out.println(c);  // 輸出 30
    }
}
```

雖然 a 和 b 是 byte，但運算時會提升為 int，所以不能直接存到 byte。

```java
byte a = 10;
byte b = 20;
byte c = a + b; // 錯誤：Type mismatch: cannot convert from int to byte
```

在這行： `byte c = a + b;` 中
- a + b → 會被 Java 編譯器轉換成 int 計算
- 結果是 int，不能直接指派給 byte，因為 可能會溢位 (overflow)
- Java 是 強型別語言，不會自動把 int 轉回 byte (需要你明確地轉型)

### 強制轉型 type cast

```java
byte c = (byte)(a + b); // 強制將 int 轉回 byte
System.out.println(c);  // 輸出 30
```



## int + long

```java
public class TypePromotionExample2 {
    public static void main(String[] args) {

        int a = 100;
        // 使用 L 表示 long 型別，小寫 l 也可以，但不推薦
        // 在這裡也可以不加 L，因為數值小 
        long b = 300L; 
        long result = a + b;  // int 自動提升為 long
        System.out.println(result); // 300
    }
}
```

在這個範例中
long b = 300L;  
long b = 300l;  
long b = 300;
都是可行的

但 
long b = 300;
它的運作原理是有些不同的
300 這樣的字面值預設是 int 
在賦值給 long 時自動做了 int ➜ long 的 type promotion  


300L 是 long 常數
加上 L (或小寫 l) 表示這個值是 long
如果不加的話當超過 int 的範圍就會出現錯誤

```java
long big = 3000000000L; // ✅
long big = 3000000000;  // ❌ 編譯錯誤，超過 int 範圍
// The literal 3000000000 of type int is out of range Java(536871066)
```

### float + double

```java
public class TypePromotionExample3 {
    public static void main(String[] args) {
        float f = 10.5f;
        double d = 20.5;
        double result = f + d;  // float 提升為 double
        System.out.println(result); // 31.0
    }
}
```

### char + int

```java
char a = 'a'; 
int b = 3;

int c = a + b; // 'a' 的 ASCII 值是 97，所以 c = 97 + 3 = 100
System.out.println("c 的值是: " + c); 
```

## Java 的 Type Promotion 規則 (基本型別)

原始類型	        提升為
byte, short, char	➜ int
int + long	        ➜ long
float + double  	➜ double

