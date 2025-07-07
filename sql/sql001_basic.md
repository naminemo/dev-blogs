
# sql

##　CREATE TABLE

```sql
-- INIT database
CREATE TABLE employee (
    id INT,
    name varchar(50),
    score INT,
    department_id  INT
);

CREATE TABLE department (
    id INT,
    name varchar(50)
);

-- INSERT　data
INSERT INTO employee VALUES (1, 'Apple', 83, 1);
INSERT INTO employee VALUES (2, 'Sam', 76, 2);
INSERT INTO employee VALUES (3, 'Helen', 83, 1);
INSERT INTO employee VALUES (4, 'Jimmy', 83, 3);
INSERT INTO employee VALUES (5, 'Amyay', 88, 1);
INSERT INTO employee VALUES (6, 'Bob', 72, 2);
INSERT INTO employee VALUES (7, 'Ken', 69, 2);
INSERT INTO employee VALUES (8, 'Johny', 67, 1);
INSERT INTO employee VALUES (9, 'Sara', 80, 3);
INSERT INTO employee VALUES (10, 'Vivian', 70, 3);

INSERT INTO department VALUES (1, 'Appointment');
INSERT INTO department VALUES (2, 'Billing');
INSERT INTO department VALUES (3, 'Pharmacy');
```

## SELECT ____ FROM ____

當只有對單張表做查詢時，直接

```sql
SELECT 
    id, score
FROM 
    employee 
```

Results:
name	score
Apple	83
Sam	    76
Helen	83
Jimmy	83
Amyay	88
Bob	    72
Ken	    69
Johny	67
Sara	80
Vivian	70

## WHERE

把 department_id 為 2 的值從 employee 資料表找出來

```sql
SELECT 
    name, score
FROM 
    employee 
WHERE
    department_id = 2
```

Results:

name	score
Sam	    76
Bob	    72
Ken	    69

## JOIN

```sql
SELECT 
    e.name, e.score
FROM 
    employee e
JOIN
    department d ON e.department_id = d.id
WHERE
    d.name = 'Billing'
```

name	score
Sam	    76
Bob	    72
Ken	    69

## AS 

```sql
SELECT 
    e.name AS good_employee,
    e.score AS point
FROM 
    employee e
JOIN
    department d ON e.department_id = d.id
WHERE
    d.name = 'Appointment'
```

good_employee	point
Apple	        83
Helen	        83
Amyay	        88
Johny	        67

## ORDER BY

```sql
SELECT 
    e.name AS good_employee,
    e.score AS point
FROM 
    employee e
JOIN
    department d ON e.department_id = d.id
WHERE
    d.name = 'Appointment'
ORDER BY
    e.score DESC
```

good_employee	point
Amyay	        88
Apple	        83
Helen	        83
Johny	        67

## LIMIT

```sql
SELECT 
    e.name AS good_employee,
    e.score AS point
FROM 
    employee e
JOIN
    department d ON e.department_id = d.id
WHERE
    d.name = 'Appointment'
ORDER BY
    e.score DESC
LIMIT 2
```

good_employee	point
Amyay	        88
Helen	        83

## Common Table Expression (CTE)

## WITH (CTE)

WITH 在 SQL 中是 Common Table Expression (CTE) 的關鍵字。  
可以把它想像成一個 "臨時的、只用一次的虛擬表格"。

當在 SQL 查詢中看到 WITH，它通常表示你正在定義一個或多個 臨時的結果集。  
這些結果集只在緊接著它後面的那個 SELECT、INSERT、UPDATE 或 DELETE 語句中有效。  
一旦那個主查詢執行完畢，這個臨時的結果集就消失了。

### 為什麼要使用 WITH (CTE)

主要有這幾個好處

1. 提高可讀性 (Readability)：
- 對於複雜的查詢，如果把它們分解成幾個小的、有邏輯意義的步驟，會比寫一個超級長的巢狀查詢更容易理解。
- 每個 CTE 都有一個名字，就像給一個變數命名一樣，讓程式碼更清晰。

2. 簡化複雜查詢 (Simplification)：
- 你可以把一個複雜的邏輯 (例如，先計算排名，然後再篩選) 拆分成多個 CTE。
- 有些查詢，特別是用到像 RANK() 這種視窗函數時，必須先計算出結果，然後才能在外層查詢中引用，CTE 就是解決這個問題的好方法。

3. 重複使用 (Reusability)：
- 如果在一個複雜的查詢中需要多次用到同一個子查詢的結果，你可以把它定義成一個 CTE，然後在同一個主查詢中多次引用這個 CTE，避免重複寫相同的程式碼。

### 基本語法

```sql
WITH CTE_名稱 AS (
    -- 這個括號裡面放的是的 SELECT 查詢，它的結果會成為這個 CTE
    SELECT 欄位1, 欄位2
    FROM 某個資料表
    WHERE 某個條件
)
-- 然後，你可以在這裡使用這個 CTE，就像使用普通的資料表一樣
SELECT *
FROM CTE_名稱
WHERE 另一個條件;
```

## 

```sql
WITH RankedSalesEmployees AS (
    SELECT
        e.name AS good_employee,
        e.score AS point,
        d.name AS department_name,
        RANK() OVER (ORDER BY e.score DESC) as rnk
    FROM
        employee e
    JOIN
        department d ON e.department_id = d.id
    WHERE
        d.name = 'Appointment'
)
SELECT
    good_employee,
    point,
    department_name
FROM
    RankedSalesEmployees
WHERE
    rnk <= 2
```

Results

good_employee	point	department_name
Amyay	        88	    Appointment
Apple	        83  	Appointment
Helen	        83  	Appointment

注意:
雖然這也是查找排名前二的，但它會把同分的也給找出來。
所以資料可能會有兩筆以上。

## COUNT + GROUP BY

```sql
SELECT
    d.name AS department_name,       -- 選取部門名稱
    COUNT(e.name) AS total_employees -- 計算每個部門的員工總數
FROM
    employee e                       -- 從 'employee' (員工) 資料表開始
JOIN
    department d ON e.department_id = d.id -- 把 'employee' 和 'department' 資料表連接起來
GROUP BY
    d.name;                          -- 根據部門名稱進行分組
```

COUNT(e.id) AS total_employees 這裡的 COUNT() 是聚合函數

Results

department_name	total_employees
Appointment 	4
Billing	        3
Pharmacy	    4

## AVG + GROUP BY

```sql
SELECT
    d.name AS department_name,    -- 選取部門名稱
    AVG(e.score) AS average_score -- 計算每個部門的平均分數
FROM
    employee e
JOIN
    department d ON e.department_id = d.id
GROUP BY
    d.name;                       -- 根據部門名稱進行分組

```

Results:

department_name	average_score
Appointment	    80.2500
Billing	        72.3333
Pharmacy	    77.6667

## HAVING

HAVING 語句通常與 GROUP BY 一起使用。  
它的作用是：在資料經過 GROUP BY 分組並進行聚合計算後，對這些分組後的結果再進行一次篩選。

簡單來說：
- WHERE：用於在分組之前，對原始資料的每一行進行篩選。
- HAVING：用於在分組之後，對**聚合結果（例如 COUNT()、SUM()、AVG() 等的結果）**進行篩選。

### HAVING 的例子：找出員工人數超過 3 人的部門

假設你找出那些員工人數超過 3 人的部門。  
這時候，你就需要先用 GROUP BY 統計每個部門的員工人數，然後再用 HAVING 來篩選出人數超過 3 的部門。

```sql
SELECT
    d.name AS department_name,      -- 選取部門名稱
    COUNT(e.id) AS total_employees  -- 計算每個部門的員工總數
FROM
    employee e                      -- 從 'employee' (員工) 資料表開始
JOIN
    department d ON e.department_id = d.id -- 把 'employee' 和 'department' 資料表連接起來
GROUP BY
    d.name                          -- 根據部門名稱進行分組
HAVING
    COUNT(e.id) > 3;                -- 只顯示員工總數大於 3 的部門
```

Results:

department_name	total_employees
Appointment	    4


### 另一個例子：找出平均分數高於 80 分的部門

```sql
SELECT
    d.name AS department_name,      -- 選取部門名稱
    AVG(e.score) AS average_score   -- 計算每個部門的平均分數
FROM
    employee e
JOIN
    department d ON e.department_id = d.id
GROUP BY
    d.name
HAVING
    AVG(e.score) > 80;              -- 只顯示平均分數高於 80 的部門
```

department_name	average_score
Appointment	    80.2500

## WHERE vs. HAVING

- WHERE：在分組前篩選行資料。  
  不能在 WHERE 子句中使用聚合函數，如 COUNT()、SUM()。
  但能依照本身欄位資料的值來篩選。
  - 例如：WHERE e.score > 80 (篩選出分數高於 80 的員工)

- HAVING：在分組後篩選聚合結果。
  必須先使用 GROUP BY 才能使用 HAVING。
  - 例如：HAVING AVG(e.score) > 80 (篩選出平均分數高於 80 的部門)


## DISTINCT

找出公司裡有哪些不同的員工分數

```sql
SELECT DISTINCT
    score
FROM
    employee;
```

score
83
76
88
72
69
67
80
70

只有 8 種不同的分數，但原始資料是 10 筆資料。

## OFFSET

OFFSET 在 SQL 中用於跳過結果集的前 N 筆記錄，然後再開始返回資料。  
它通常與 LIMIT 一起使用，用來實現分頁 (Pagination) 的功能。

想像你有一本很厚的書，OFFSET 就是告訴你從第幾頁開始看，而 LIMIT 則是你一次看幾頁。
- OFFSET N: 跳過結果集的前 N 筆資料。
- LIMIT M: 在跳過 N 筆之後，再取出接下來的 M 筆資料。

```sql
SELECT
    id,
    name,
    score
FROM
    employee
ORDER BY
    id ASC -- 依然需要排序來確保結果穩定
LIMIT 3    -- 先指定要取出多少筆資料
OFFSET 3;  -- 然後指定要跳過多少筆資料
```

假設你想顯示員工列表，每頁顯示 3 筆資料，現在要看第二頁的資料。
- 第一頁：資料 1, 2, 3
- 第二頁：資料 4, 5, 6 (這就需要跳過前 3 筆)


id	name	score
4	Jimmy	83
5	Amyay	88
6	Bob	    72

重要!
```sql
ORDER BY 
    id ASC:
```
這段非常重要！ 
在使用 OFFSET 進行分頁時，一定要有 ORDER BY。  
如果沒有 ORDER BY，資料的順序是不確定的，每次查詢的「第一筆」、「第二筆」可能會不同，導致分頁結果混亂。這裡按 id 升序排列，確保每次都得到穩定的排序。


##  SQL 查詢的執行順序

SQL 查詢的邏輯執行順序
SQL 查詢通常會遵循一個特定的邏輯執行順序，即使你寫程式碼的順序不是這樣。  
這個順序大致如下：

1. FROM：
首先，資料庫會確定要從哪些表格獲取數據。這包括了你指定的所有表格，並會處理 JOIN（例如 INNER JOIN、LEFT JOIN 等）操作，將多個表格的行組合起來，形成一個「虛擬表格」。

這是所有其他操作的基礎數據集。

2. ON：
如果有 JOIN 操作，ON 子句會在連接表格時，定義這些表格之間如何匹配的連接條件。不符合 ON 條件的行在 INNER JOIN 中會被排除。

3. WHERE：
接下來，資料庫會對 FROM 和 ON 生成的虛擬表格中的每一行進行篩選。
只有符合 WHERE 子句中條件的行會被保留，進入下一步。請記住，聚合函數（如 COUNT(), SUM() 等）不能在這裡使用，因為數據還沒被分組。

4. GROUP BY：
如果有 GROUP BY 子句，資料庫會將經過 WHERE 篩選後的行，按照你指定的欄位進行分組。
這會創建出許多邏輯上的「組」，每個組代表 GROUP BY 欄位的一個獨特組合。

5. HAVING：
HAVING 子句在 GROUP BY 之後執行。它會對每個分組應用篩選條件。
在這裡可以使用聚合函數，因為數據已經被分組，並且聚合值（如每組的總和、平均值）已經被計算出來。只有符合 HAVING 條件的分組會被保留。

6. SELECT：
現在，資料庫會根據你 SELECT 子句中指定的欄位，從經過前面步驟處理的數據中選取最終要顯示的列。
這裡會處理 DISTINCT（如果有的話，會在選擇欄位後移除重複的行）、聚合函數的最終計算，以及任何欄位別名 (AS) 的應用。
視窗函數 (RANK() OVER(), ROW_NUMBER() OVER() 等) 也在這個階段執行，因為它們需要在選取數據之前就計算出其值。

7. DISTINCT：
如果在 SELECT 語句中使用了 DISTINCT 關鍵字，它會在選取所有欄位後，移除所有完全重複的行。

8. ORDER BY：
這是最後一個步驟。資料庫會對最終的結果集進行排序，按照你指定的欄位和順序（升序 ASC 或降序 DESC）。

9. LIMIT / OFFSET (或 FETCH NEXT / TOP)：
如果有這些子句，它們會在排序之後執行，用於限制返回的行數（例如分頁）。OFFSET 會跳過指定數量的行，LIMIT (或 FETCH NEXT) 則會取出指定數量的行。

## UPDATE

基本語法

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

修改單個 row 的資料

```sql
SELECT
    name, score
FROM
    employee
WHERE id = 5;

UPDATE employee
SET 
    score = 90, 
    name = 'Amy'
WHERE id = 5;

SELECT
    name, score
FROM
    employee
WHERE id = 5;
```

修改複數 row 的資料

```sql
SELECT
    name, score
FROM
    employee;

UPDATE employee e
JOIN department d ON e.department_id = d.id
SET e.score = e.score + 5
WHERE d.name = 'Pharmacy';

SELECT
    e.name, e.score, d.name AS department_name
FROM
    employee e
JOIN 
    department d ON e.department_id = d.id;
```
