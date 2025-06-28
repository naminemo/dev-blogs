# named constant

Python 本身並沒有內建的語法來 "強制" 一個變數成為常數，使其值無法被修改。

在 Python 中，附名常數更多的是一種約定 (convention)，也可以說成是慣例，再或者說是一種開發者之間的共識。

## 附名常數/具名常數

```py
from enum import Enum
class Color(Enum):
    RED = 'red'
    GREEN = 'green'
    BLUE = 'blue'

print(Color.RED)
```

```py
from enum import Enum

class HttpStatus(Enum):
    OK = 200
    NOT_FOUND = 404
    INTERNAL_SERVER_ERROR = 500
    FORBIDDEN = 403

def handle_request(status):
    if status == HttpStatus.OK:
        print("請求成功")
    elif status == HttpStatus.NOT_FOUND:
        print("資源未找到")
    else:
        print("處理其他狀態")

handle_request(HttpStatus.OK)
handle_request(HttpStatus.FORBIDDEN)

# 查值
print(HttpStatus.OK.value)

# 反向查找
print(HttpStatus(200))
```
