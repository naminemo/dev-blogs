# CocoaPods

先確認本地有沒有安裝 CocoaPods

`$ pod --version`
zsh: command not found: pod

## 在開始安裝前先確認一些套件資料

### 確認 Homebrew
https://brew.sh/

`% brew --version`
zsh: command not found: brew


### 確認 ruby 資訊

`ruby -v`
ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.arm64e-darwin24]

`% which ruby`
/usr/bin/ruby



## 方法一：用 rbenv 更新 Ruby（推薦）

### 1. 安裝 Homebrew（如果還沒有）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"# macOS 內建的 Ruby 不建議直接覆蓋更新
```

==> /usr/bin/sudo /usr/sbin/chown -R xemao:admin /opt/homebrew
==> /usr/bin/sudo /bin/mkdir -p /Users/xemao/Library/Caches/Homebrew
==> /usr/bin/sudo /bin/chmod g+rwx /Users/xemao/Library/Caches/Homebrew
==> /usr/bin/sudo /usr/sbin/chown -R xemao /Users/xemao/Library/Caches/Homebrew
==> Searching online for the Command Line Tools
==> /usr/bin/sudo /usr/bin/touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
==> Installing Command Line Tools for Xcode-16.4
==> /usr/bin/sudo /usr/sbin/softwareupdate -i Command\ Line\ Tools\ for\ Xcode-16.4
Software Update Tool

Finding available software

Downloading Command Line Tools for Xcode

(這裡網速慢的話會卡住等一些時間)

...


Installing Command Line Tools for Xcode
(這裡會等一些時間)

Done with Command Line Tools for Xcode
Done.
==> /usr/bin/sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
==> /usr/bin/sudo /bin/rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
==> Downloading and installing Homebrew...
remote: Enumerating objects: 309600, done.
remote: Counting objects: 100% (86/86), done.
remote: Compressing objects: 100% (61/61), done.
remote: Total 309600 (delta 33), reused 71 (delta 25), pack-reused 309514 (from 2)
remote: Enumerating objects: 55, done.
remote: Counting objects: 100% (34/34), done.
remote: Total 55 (delta 34), reused 34 (delta 34), pack-reused 21 (from 1)
==> /usr/bin/sudo /bin/mkdir -p /etc/paths.d
==> /usr/bin/sudo tee /etc/paths.d/homebrew
/opt/homebrew/bin
==> /usr/bin/sudo /usr/sbin/chown root:wheel /etc/paths.d/homebrew
==> /usr/bin/sudo /bin/chmod a+r /etc/paths.d/homebrew
==> Updating Homebrew...
==> Downloading https://ghcr.io/v2/homebrew/portable-ruby/portable-ruby/blobs/sha256:20fa657858e44a4b39171d6e4111f8a9716eb62a78ebbd1491d94f90bb7b830a
##################################################################################################### 100.0%
==> Pouring portable-ruby-3.4.5.arm64_big_sur.bottle.tar.gz
==> Installation successful!

安裝好後要重新打開 terminal


### 2. 安裝 rbenv 與 ruby-build

```bash
brew install rbenv ruby-build
```

### 3. 初始化 rbenv（將以下內容加到你的 shell 設定檔 .zshrc 或 .bashrc）
```bash
nano ~/.zshrc
```

進到裡裡面加入以下指令
如果有其他指令，此指令要排在最下面

```bash
eval "$(rbenv init - zsh)"
```

### 4. 重新載入 shell
```bash
source ~/.zshrc
```

#### 4.1 確認 rbenv 排在 PATH 前面
```bash
which ruby
```

如果正確，應該會看到類似：
```bash
/Users/你的帳號/.rbenv/shims/ruby
```

錯誤的話應該是看到：
```bash
/usr/bin/ruby
```
若此時有錯的話可以先跳過，這是因為你還沒安裝其他版本的 ruby

### 5. 安裝最新版本 Ruby
```bash
rbenv install -l   # 查看可安裝版本
rbenv install 3.4.5 # 安裝你想要的版本
```

==> Installed ruby-3.4.5 to /Users/your_name/.rbenv/versions/3.4.5

NOTE: to activate this Ruby version as the new default, run: rbenv global 3.4.5



### 6. 確認 ruby 目前版本
```bash
ruby -v
```

ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.arm64e-darwin24]

### 7. 設為預設版本
```bash
rbenv global 3.4.5
```

### 7.1
```bash
rbenv rehash
```

### 7.2 確認 ruby 目前版本

```bash
ruby -v
```  
ruby 3.4.5 (2025-07-16 revision 20cda200d3) +PRISM [arm64-darwin24]


## CocoaPods

### 1. 安裝 CocoaPods
```bash
gem install cocoapods
```

Fetching nanaimo-0.4.0.gem
Fetching colored2-3.1.2.gem
Fetching claide-1.1.0.gem
Fetching CFPropertyList-3.0.7.gem
Fetching atomos-0.1.3.gem
Fetching xcodeproj-1.27.0.gem
Fetching ruby-macho-2.5.1.gem
Fetching nap-1.1.0.gem
Fetching molinillo-0.8.0.gem
Fetching gh_inspector-1.1.3.gem
Fetching fourflusher-2.3.1.gem
Fetching escape-0.0.4.gem
Fetching cocoapods-try-1.2.0.gem
Fetching netrc-0.11.0.gem
Fetching cocoapods-trunk-1.6.0.gem
Fetching cocoapods-search-1.0.1.gem
Fetching cocoapods-plugins-1.0.0.gem
Fetching cocoapods-downloader-2.1.gem
Fetching cocoapods-deintegrate-1.0.5.gem
Fetching ffi-1.17.2-arm64-darwin.gem
Fetching ethon-0.16.0.gem
Fetching typhoeus-1.4.1.gem
Fetching public_suffix-4.0.7.gem
Fetching fuzzy_match-2.0.4.gem
Fetching concurrent-ruby-1.3.5.gem
Fetching httpclient-2.9.0.gem
Fetching algoliasearch-1.27.5.gem
Fetching addressable-2.8.7.gem
Fetching tzinfo-2.0.6.gem
Fetching i18n-1.14.7.gem
Fetching connection_pool-2.5.3.gem
Fetching activesupport-7.2.2.1.gem
Fetching cocoapods-1.16.2.gem
Fetching cocoapods-core-1.16.2.gem
Successfully installed nanaimo-0.4.0
Successfully installed colored2-3.1.2
Successfully installed claide-1.1.0
Successfully installed CFPropertyList-3.0.7
Successfully installed atomos-0.1.3
Successfully installed xcodeproj-1.27.0
Successfully installed ruby-macho-2.5.1
Successfully installed nap-1.1.0
Successfully installed molinillo-0.8.0
Successfully installed gh_inspector-1.1.3
Successfully installed fourflusher-2.3.1
Successfully installed escape-0.0.4
Successfully installed cocoapods-try-1.2.0
Successfully installed netrc-0.11.0
Successfully installed cocoapods-trunk-1.6.0
Successfully installed cocoapods-search-1.0.1
Successfully installed cocoapods-plugins-1.0.0
Successfully installed cocoapods-downloader-2.1
Successfully installed cocoapods-deintegrate-1.0.5
Successfully installed ffi-1.17.2-arm64-darwin
Successfully installed ethon-0.16.0
Successfully installed typhoeus-1.4.1
Successfully installed public_suffix-4.0.7
Successfully installed fuzzy_match-2.0.4
Successfully installed concurrent-ruby-1.3.5
Successfully installed httpclient-2.9.0
A new major version is available for Algolia! Please now use the https://rubygems.org/gems/algolia gem to get the latest features.
Successfully installed algoliasearch-1.27.5
Successfully installed addressable-2.8.7
Successfully installed tzinfo-2.0.6
Successfully installed i18n-1.14.7
Successfully installed connection_pool-2.5.3
Successfully installed activesupport-7.2.2.1
Successfully installed cocoapods-core-1.16.2
Successfully installed cocoapods-1.16.2
34 gems installed

A new release of RubyGems is available: 3.6.9 → 3.7.1!
Run `gem update --system 3.7.1` to update your installation.

CocoaPods 已經安裝成功（cocoapods-1.16.2）並且 RubyGems 提醒你有新版可以更新。

### 2. 檢查是否有安裝 CocoaPods
```bash
pod --version
```
1.16.2

### 2.1 也可以使用 gem list 來查
```bash
gem list cocoapods
```
LOCAL GEMS

cocoapods (1.16.2)
cocoapods-core (1.16.2)
cocoapods-deintegrate (1.0.5)
cocoapods-downloader (2.1)
cocoapods-plugins (1.0.0)
cocoapods-search (1.0.1)
cocoapods-trunk (1.6.0)
cocoapods-try (1.2.0)


### 2.2 檢查 rbenv 或系統 Ruby 的 gem

```bash
which pod
```
/Users/your_name/.rbenv/shims/pod

```bash
rbenv which pod
```

/Users/your_name/.rbenv/versions/3.4.5/bin/pod

能找到檔案路徑（例如 /Users/你/.rbenv/versions/3.4.5/bin/pod）就表示安裝在該 Ruby 版本底下。




