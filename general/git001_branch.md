### 永造先看目前狀態
```bash
git status
```

### 確認目前所在分支
```bash
git branch
```

### 創建分支
```bash
git branch 分支名稱
```

### 切換分支
```bash
git checkout 分支名稱
```

### 直接切換到新創建的分支
```bash
git checkout -b 分支名稱
```
假設現在在 main 底下，
使用 git checkout -b bugfix
那麼就會立即新建且切換到新分支上，新分支的名稱為 bugfix。

### 列出所有遠端追蹤分支
```bash
git branch -r
```
-r 表示 --remotes


### 列出所有本地和遠端追蹤分支
```bash
git branch -a
```
-a 表示 --all


### 合併分支
```bash
git merge origin/分支名稱
```
切換到 main 分支再進行合併

#### 合拼完成後更新遠端倉庫
```bash
git push origin main
```

### 刪除分支
```bash
git branch -d 分支名稱
```
假設本地分支已被合併，通常是合併到 main 分支去，那麼我們可以刪除不要的分支。
先回到 main 分支底下再進行刪除其他分支的動作。

### 把新建的分支推上遠端
```bash
git push --set-upstream origin 分支名稱
```
由於遠端上並沒有剛剛本地所建立的分支資訊，所以要來把本地的分支給推送上去。
第一次推送本地分支到遠端的話，會需要指定遠端倉庫的名稱 (通常是 origin) 以及你想要推送的本地分支名稱，並建立與遠端分支的追蹤關係。
--set-upstream 也能直接縮寫成 -u。
此選項會將你的本地分支與遠端倉庫上的 <你的本地分支名稱> 建立追蹤關係。
```bash
git push -u origin 分支名稱
```

### 刪除遠端分支
```bash
git push origin -d general
```
-d 為 --delete 的簡寫形式


### 清理失效的遠端追蹤分支
```bash
git fetch -p
```
-p 為 --prune 的簡寫形式





