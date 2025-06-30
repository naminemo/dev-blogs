import json
import os
from datetime import datetime


def process_json_list_file(file_path, tag_to_check, default_value=None):
    """
    讀取一個 JSON 檔案，期望其根層級是一個列表。
    所謂列表是指 JSON 檔案的內容應該是類似這樣的結構:
    [ { "key1": "value1", "key2": "value2" }, { "key3": "value3" } ]
    如果列表中的字典沒有指定的 tag (鍵)，則新增該 tag
    遍歷列表中的每個字典，檢查並新增指定的 tag。

    而另一種不是列表的情況是指 JSON 檔案的內容是這樣的結構:
    { "key1": "value1", "key2": "value2" }
    在這種情況下，這個函式不會處理，因為它預期的是一個列表。

    Args:
        file_path (str): JSON 檔案的路徑。
        tag_to_check (str): 要檢查的 tag (鍵)。
        default_value (any, optional): 如果 tag 不存在時要賦予的值。預設為 None。
    Returns:
        bool: 如果檔案被更新了則回傳 True，否則回傳 False。
    """
    updated = False
    data = []  # 預期 data 會是一個列表

    # 1. 檢查檔案是否存在，並嘗試讀取其內容
    if os.path.exists(file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)  # 將 JSON 內容載入為 Python 列表
            print(f"成功讀取檔案: '{file_path}'")

            # 確保載入的資料確實是一個列表
            if not isinstance(data, list):
                print(f"錯誤: 檔案 '{file_path}' 的根層級不是一個列表，而是 {type(data)}。無法處理。")
                return False

        except json.JSONDecodeError:
            print(f"錯誤: 無法解析 '{file_path}' 中的 JSON 內容。檔案可能為空或格式錯誤。")
            return False
        except Exception as e:
            print(f"讀取檔案 '{file_path}' 時發生未知錯誤: {e}")
            return False
    else:
        print(f"警告: 檔案 '{file_path}' 不存在。將會建立一個包含空列表的新檔案。")
        data = []  # 如果檔案不存在，初始化為空列表

    # 2. 遍歷列表中的每個項目 (預期每個項目都是字典)
    for i, item in enumerate(data):
        if isinstance(item, dict):  # 確保列表中的每個項目是字典
            if tag_to_check not in item:
                print(f"在列表索引 {i} 處，Tag '{tag_to_check}' 不存在。正在新增此 tag 並設定值為: {default_value}")
                item[tag_to_check] = default_value  # 新增 tag 到該字典
                updated = True
            else:
                print(f"在列表索引 {i} 處，Tag '{tag_to_check}' 已存在，其值為: {item[tag_to_check]}")
        else:
            print(f"警告: 列表索引 {i} 處的項目不是字典 ({type(item)})，跳過。")

    # 3. 如果資料有更新（或檔案一開始不存在），則將資料寫回檔案
    if updated or not os.path.exists(file_path):
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=4, ensure_ascii=False)
            print(f"檔案 '{file_path}' 已成功更新。" if updated else f"檔案 '{file_path}' 已成功建立/儲存。")
            return updated
        except Exception as e:
            print(f"寫入檔案 '{file_path}' 時發生錯誤: {e}")
            return False

    return updated


# --- 範例使用 ---
if __name__ == "__main__":
    json_file_path = "config.json"  # 確保這個檔案名與你實際的 JSON 檔案名一致

    print(f"程式正在使用的 config.json 完整路徑是: {os.path.abspath(json_file_path)}")

    # --- 情境 1: 加入 "isCompleted": false 到列表的每個物件中 ---
    print("\n--- 情境 1: 檢查並新增 'isCompleted' 到列表的每個物件中 ---")

    # 使用新的 process_json_list_file 函式來處理列表結構
    process_json_list_file(json_file_path, "isCompleted", False)

    print("\n--- 'config.json' 目前內容 (情境 1 之後) ---")
    if os.path.exists(json_file_path):
        with open(json_file_path, 'r', encoding='utf-8') as f:
            print(f.read())
    print("-" * 50)

    # --- 情境 2: 再次檢查 'isCompleted' (已存在) ---
    print("\n--- 情境 2: 再次檢查 'isCompleted' (已存在) ---")
    # 即使現在傳入 True，因為 'isCompleted' 已經存在，其值也不會被改變
    process_json_list_file(json_file_path, "isCompleted", True)

    print("\n--- 'config.json' 目前內容 (情境 2 之後) ---")
    if os.path.exists(json_file_path):
        with open(json_file_path, 'r', encoding='utf-8') as f:
            print(f.read())
    print("-" * 50)

    # --- 情境 3: 檢查並新增另一個 tag，例如 'createdAt' ---
    print("\n--- 情境 3: 檢查並新增 'isLocked' 到列表的每個物件中 ---")
    # current_date = datetime.now().strftime("%Y-%m-%d")  # 只取日期
    process_json_list_file(json_file_path, "isLocked", False)

    print("\n--- 'config.json' 目前內容 (情境 3 之後) ---")
    if os.path.exists(json_file_path):
        with open(json_file_path, 'r', encoding='utf-8') as f:
            print(f.read())
    print("-" * 50)

    # 如果需要清理測試檔案，可以取消下方註解
    # if os.path.exists(json_file_path):
    #     os.remove(json_file_path)
    #     print(f"\n清理完成: 已刪除 '{json_file_path}'")