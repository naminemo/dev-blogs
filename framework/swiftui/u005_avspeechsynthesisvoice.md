# 語音處理

##

### AVSpeechSynthesisVoic

AVSpeechSynthesisVoice 使用的是 BCP 47 語言標籤來表示語言和地區。  
這些標籤的格式通常是 language-region，例如 en-US 代表美式英文，en-GB 代表英式英文。

要獲取設備上所有可用的語音列表，可以在程式碼中這樣做：

```swift
import AVFoundation
            
func printAllAvailableVoiceIdentifiers() {
    let voices = AVSpeechSynthesisVoice.speechVoices()
    print("--- Available Voices ---")
    for voice in voices {
        print("Identifier: \(voice.identifier)")
        print("  Language: \(voice.language)")
        print("  Name: \(voice.name)")
        print("  Quality: \(voice.quality.rawValue)")
        print("------------------------")
    }
}

// 調用這個函數來打印所有可用的語音
printAllAvailableVoiceIdentifiers()
```

```swift
/*
以下只列出幾個常用的
--- Available Voices ---
------------------------
Identifier: com.apple.voice.compact.en-GB.Daniel
  Language: en-GB
  Name: Daniel
  Quality: 1
------------------------
Identifier: com.apple.speech.synthesis.voice.Kathy
  Language: en-US
  Name: Kathy
  Quality: 1
------------------------
Identifier: com.apple.speech.synthesis.voice.Fred
  Language: en-US
  Name: Fred
  Quality: 1
------------------------
Identifier: com.apple.voice.compact.ja-JP.Kyoko
  Language: ja-JP
  Name: Kyoko
  Quality: 1
------------------------
Identifier: com.apple.voice.compact.ko-KR.Yuna
  Language: ko-KR
  Name: Yuna
  Quality: 1
------------------------
Identifier: com.apple.voice.compact.zh-CN.Tingting
  Language: zh-CN
  Name: 婷婷
  Quality: 1
------------------------
Identifier: com.apple.voice.compact.zh-HK.Sinji
  Language: zh-HK
  Name: 善怡
  Quality: 1
------------------------
Identifier: com.apple.voice.compact.zh-TW.Meijia
  Language: zh-TW
  Name: 美佳
  Quality: 1
------------------------
*/
```

該設備上所有可用的語音列表

```swift
/*
Language: ar-001, Name: Majed, Quality: 1
Language: bg-BG, Name: Daria, Quality: 1
Language: ca-ES, Name: Montse, Quality: 1
Language: cs-CZ, Name: Zuzana, Quality: 1
Language: da-DK, Name: Sara, Quality: 1
Language: de-DE, Name: Anna, Quality: 1
Language: el-GR, Name: Melina, Quality: 1
Language: en-AU, Name: Karen, Quality: 1
Language: en-GB, Name: Daniel, Quality: 1
Language: en-IE, Name: Moira, Quality: 1
Language: en-IN, Name: Rishi, Quality: 1
Language: en-US, Name: Trinoids, Quality: 1
Language: en-US, Name: Albert, Quality: 1
Language: en-US, Name: Jester, Quality: 1
Language: en-US, Name: Samantha, Quality: 1
Language: en-US, Name: Whisper, Quality: 1
Language: en-US, Name: Superstar, Quality: 1
Language: en-US, Name: Bells, Quality: 1
Language: en-US, Name: Organ, Quality: 1
Language: en-US, Name: Bad News, Quality: 1
Language: en-US, Name: Bubbles, Quality: 1
Language: en-US, Name: Junior, Quality: 1
Language: en-US, Name: Bahh, Quality: 1
Language: en-US, Name: Wobble, Quality: 1
Language: en-US, Name: Boing, Quality: 1
Language: en-US, Name: Good News, Quality: 1
Language: en-US, Name: Zarvox, Quality: 1
Language: en-US, Name: Ralph, Quality: 1
Language: en-US, Name: Cellos, Quality: 1
Language: en-US, Name: Kathy, Quality: 1
Language: en-US, Name: Fred, Quality: 1
Language: en-ZA, Name: Tessa, Quality: 1
Language: es-ES, Name: Mónica, Quality: 1
Language: es-MX, Name: Paulina, Quality: 1
Language: fi-FI, Name: Satu, Quality: 1
Language: fr-CA, Name: Amélie, Quality: 1
Language: fr-FR, Name: Thomas, Quality: 1
Language: he-IL, Name: Carmit, Quality: 1
Language: hi-IN, Name: Lekha, Quality: 1
Language: hr-HR, Name: Lana, Quality: 1
Language: hu-HU, Name: Tünde, Quality: 1
Language: id-ID, Name: Damayanti, Quality: 1
Language: it-IT, Name: Alice, Quality: 1
Language: ja-JP, Name: Kyoko, Quality: 1
Language: ko-KR, Name: Yuna, Quality: 1
Language: ms-MY, Name: Amira, Quality: 1
Language: nb-NO, Name: Nora, Quality: 1
Language: nl-BE, Name: Ellen, Quality: 1
Language: nl-NL, Name: Xander, Quality: 1
Language: pl-PL, Name: Zosia, Quality: 1
Language: pt-BR, Name: Luciana, Quality: 1
Language: pt-PT, Name: Joana, Quality: 1
Language: ro-RO, Name: Ioana, Quality: 1
Language: ru-RU, Name: Milena, Quality: 1
Language: sk-SK, Name: Laura, Quality: 1
Language: sl-SI, Name: Tina, Quality: 1
Language: sv-SE, Name: Alva, Quality: 1
Language: th-TH, Name: Kanya, Quality: 1
Language: tr-TR, Name: Yelda, Quality: 1
Language: uk-UA, Name: Lesya, Quality: 1
Language: vi-VN, Name: Linh, Quality: 1
Language: zh-CN, Name: 婷婷, Quality: 1
Language: zh-HK, Name: 善怡, Quality: 1
Language: zh-TW, Name: 美佳, Quality: 1
*/
```
