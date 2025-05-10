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





