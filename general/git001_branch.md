### 永造先看目前狀態
```git
git status
```

### 確認目前所在分支
```git
git branch
```

### 創建分支
```git
git branch 分支名稱
```

### 切換分支
```git
git checkout 分支名稱
```

### 直接切換到新創建的分支
```bash
git checkout -b 分支名稱
```
假設現在在 main 底下
使用 git checkout -b bug-fix-download
那麼就會立即新建且切換到新分支上


### 刪除分支
假計本地分支已被合併，那麼我們可以刪除不要的分支。
先回到 main 分支底下再進行刪除其他分支的動作。
```bash
git branch -d 分支名稱
```




