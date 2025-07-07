
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




