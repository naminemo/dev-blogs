# Merge Sort

合併排序 (Merge Sort) 是一種高效、通用的比較排序演算法。它的核心思想是分而治之 (Divide and Conquer)。簡單來說，它會把一個大問題分解成若干個小問題，解決這些小問題，然後再將小問題的解合併起來，從而解決原始的大問題。

## 運作原理

合併排序主要分為三個步驟：

1. 分解 (Divide)：將待排序的數列從中間分成兩個子數列。這個過程會不斷遞迴地進行，直到每個子數列都只剩下一個元素（因為單個元素的數列自然是有序的）。
2. 治理 (Conquer)：對每個子數列進行排序。由於分解步驟最終會使每個子數列只剩下一個元素，所以這一步其實是隱含在遞迴分解中的。
3. 合併 (Combine)：將兩個已排序的子數列合併成一個更大的已排序數列。這是演算法中最重要的步驟，也是效率的關鍵所在。

這個合併的過程是其效率的關鍵：它通過比較兩個子數列的頭部元素，將較小的那個取出並放入新的數列中，直到其中一個子數列為空，然後將另一個子數列中剩餘的所有元素直接複製到新數列的末尾。

## 特性

- 時間複雜度：無論是最好、最壞還是平均情況，合併排序的時間複雜度都是 O(n*logn)。這使其在處理大量數據時非常高效。
- 空間複雜度：O(n)，因為合併過程需要一個額外的空間來暫存合併後的數列。
- 穩定性：合併排序是一種穩定 (Stable) 的排序演算法，這表示如果數列中有兩個相同的元素，它們在排序前後的相對位置不會改變。

## java 範例

```java
public class Main {

    /**
     * 合併排序的主方法
     * 遞迴地將陣列分成兩半，然後合併
     *
     * @param arr 待排序的整數陣列
     */
    public static void mergeSort(int[] arr) {
        if (arr == null || arr.length <= 1) {
            return; // 陣列為空或只有一個元素，無需排序
        }
        // 調用遞迴的排序方法
        sort(arr, new int[arr.length], 0, arr.length - 1);
    }

    /**
     * 遞迴排序方法
     *
     * @param arr   原始陣列
     * @param temp  用於合併的暫存陣列
     * @param left  子陣列的起始索引
     * @param right 子陣列的結束索引
     */
    private static void sort(int[] arr, int[] temp, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2; // 找到中間點

            // 遞迴地對左半部分進行排序
            sort(arr, temp, left, mid);

            // 遞迴地對右半部分進行排序
            sort(arr, temp, mid + 1, right);

            // 合併兩個已排序的子陣列
            merge(arr, temp, left, mid, right);
        }
    }

    /**
     * 合併兩個已排序的子陣列
     *
     * @param arr   原始陣列
     * @param temp  用於合併的暫存陣列
     * @param left  第一個子陣列的起始索引
     * @param mid   第一個子陣列的結束索引 (也是第二個子陣列的前一個索引)
     * @param right 第二個子陣列的結束索引
     */
    private static void merge(int[] arr, int[] temp, int left, int mid, int right) {
        // 將原始陣列中要合併的範圍複製到暫存陣列中
        // 這樣在合併時，可以直接從 temp 讀取數據，避免修改正在比較的原始數據
        for (int i = left; i <= right; i++) {
            temp[i] = arr[i];
        }

        int i = left;      // 左半部分陣列的起始索引 (在 temp 中)
        int j = mid + 1;   // 右半部分陣列的起始索引 (在 temp 中)
        int k = left;      // 原始陣列中要放置合併後元素的起始索引

        // 比較 temp 陣列的左右兩部分，將較小的元素放回 arr 陣列
        while (i <= mid && j <= right) {
            if (temp[i] <= temp[j]) { // 如果左半部分的元素較小或相等
                arr[k] = temp[i];
                i++;
            } else { // 如果右半部分的元素較小
                arr[k] = temp[j];
                j++;
            }
            k++;
        }

        // 將左半部分剩餘的元素複製回 arr 陣列 (如果有的話)
        // 因為右半部分可能已經全部合併完畢，但左半部分還有剩餘
        while (i <= mid) {
            arr[k] = temp[i];
            i++;
            k++;
        }

        // 將右半部分剩餘的元素複製回 arr 陣列 (如果有的話)
        // 註：這段程式碼其實可以省略，因為如果左半部分已複製完，j 走到 right，
        // 且右半部分剩餘的部分已在 temp 裡，下次迭代會自動複製到 arr，
        // 但為了清晰起見，通常會保留。
        // 而實際上，如果第一個 while 循環結束是因為 i > mid，
        // 那麼剩下的就是 temp[j...right] 的內容，直接拷貝即可。
        // 但這裡我們是將 temp[left...right] 複製到 arr[k...]，
        // 所以只需要考慮一個循環（上面那個 `while (i <= mid)`）即可。
        // 如果上面那個循環結束了，說明左邊已經完全拷貝完，那麼右邊剩下的就已經在原位置了，所以這個循環可以省略。
        // 為了理解方便，可以將兩個 while 循環都保留，但實際優化時，一個就夠了。
        // while (j <= right) {
        //     arr[k] = temp[j];
        //     j++;
        //     k++;
        // }
    }

    public static void main(String[] args) {
        int[] data = {5, 2, 4, 1, 3};
        System.out.println("原始陣列:");
        printArray(data);

        mergeSort(data);

        System.out.println("排序後的陣列:");
        printArray(data);
    }

    // 輔助方法：列印陣列內容
    public static void printArray(int[] arr) {
        for (int i = 0; i < arr.length; i++) {
            System.out.print(arr[i] + (i == arr.length - 1 ? "" : ", "));
        }
        System.out.println();
    }
}
```

### 範例說明

mergeSort(int[] arr)：

這是公開的主入口點。

它檢查陣列是否為空或只有一個元素，如果是，則直接返回。

它創建一個與原始陣列大小相同的暫存陣列 temp。這個 temp 陣列在整個排序過程中只會被創建一次，避免了在遞迴中重複創建，從而提高了效率。

它調用私有的 sort 方法來啟動遞迴排序過程。

sort(int[] arr, int[] temp, int left, int right)：

這是遞迴的核心。

遞迴終止條件：當 left >= right 時，表示子陣列只包含一個或零個元素，它已經是有序的，所以直接返回。

計算 mid 索引，將子陣列分成兩半。

遞迴調用 sort 方法對左半部分 (left 到 mid) 和右半部分 (mid + 1 到 right) 進行排序。

在左右兩半部分都排好序之後，調用 merge 方法將它們合併。

merge(int[] arr, int[] temp, int left, int mid, int right)：

這是合併排序最關鍵的部分。

複製到暫存陣列：首先，將 arr 中 left 到 right 範圍的元素複製到 temp 陣列中。這樣做是為了在合併過程中，我們始終從 temp 讀取已排序的子數列，然後將結果寫回 arr，避免了讀寫衝突。

初始化三個指針：

i：指向 temp 中左半部分的起始。

j：指向 temp 中右半部分的起始。

k：指向 arr 中合併結果的寫入位置。

比較與合併：在 while (i <= mid && j <= right) 循環中，比較 temp[i] 和 temp[j]。將較小的元素複製到 arr[k]，並移動相應的指針。

處理剩餘元素：在上述循環結束後，可能其中一個子陣列還有剩餘元素（因為另一個已經全部合併完畢）。例如，如果左半部分還有剩餘元素，它們一定是比已合併部分中所有元素都大的，所以直接將它們全部複製回 arr。由於我們是將原始區間複製到 temp，所以這裡只需要處理左半部分剩餘的拷貝，右半部分如果剩餘，其位置就是正確的，無需額外拷貝（因為它們本身就在 temp 中且已經在原位置，只是 k 沒有移動到足夠遠的地方去填充）。