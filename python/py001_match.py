def describe_point(point):
    """
    使用 match 語句來描述一個點的座標。

    Args:
        point: 一個元組 (tuple)，代表點的座標，例如 (x, y)。
               也可以是其他型別，用於測試 ValueError。
    """
    match point:
        case (0, 0):
            print("Origin")  # 匹配點在原點 (0, 0)
        case (0, y):
            print(f"Y={y}")   # 匹配點在 Y 軸上 (x=0, y!=0)
        case (x, 0):
            print(f"X={x}")   # 匹配點在 X 軸上 (x!=0, y=0)
        case (x, y):
            print(f"X={x}, Y={y}") # 匹配點在四個象限 (x!=0, y!=0)
        case _:
            # 如果以上所有模式都不匹配，則執行這裡
            # 例如，如果 point 不是一個長度為 2 的元組
            raise ValueError(f"'{point}' 不是一個有效的點 (Point) 格式。請提供 (x, y) 格式的元組。")

print("--- 測試不同點的座標 ---")

# 測試 (0, 0)
print("測試 (0, 0):")
describe_point((0, 0))

print("\n測試 (0, 5):")
describe_point((0, 5))

print("\n測試 (10, 0):")
describe_point((10, 0))

print("\n測試 (3, 7):")
describe_point((3, 7))

print("\n測試 (-2, -8):")
describe_point((-2, -8))

print("\n--- 測試無效輸入 ---")

# 測試無效輸入，應該觸發 ValueError
try:
    print("測試 'hello':")
    describe_point("hello")
except ValueError as e:
    print(f"捕獲到錯誤: {e}")

try:
    print("\n測試 (1, 2, 3):")
    describe_point((1, 2, 3))
except ValueError as e:
    print(f"捕獲到錯誤: {e}")

try:
    print("\n測試 [4, 5]:")
    describe_point([4, 5]) # 雖然是 (x,y) 形式，但型別是列表，而不是元組
except ValueError as e:
    print(f"捕獲到錯誤: {e}")