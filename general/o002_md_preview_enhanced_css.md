### 使用 Markdown Preview Enhanced

先去 Extensions 安裝  
Markdown Preview Enhanced / Yiyi Wang  
![ss 2025-05-27 15-26-11](https://raw.githubusercontent.com/naminemo/pic/main/dev/ss%202025-05-27%2015-26-11.jpg#w80)


安裝完後在 VS Code 中按下 Cmd + Shift + P  
輸入 mpecss  
![mpecss](https://raw.githubusercontent.com/naminemo/pic/main/dev/css%20%0A.jpg)  
選擇 Markdown Preview Enhanced: Customize CSS (Global)


把內容替換成下面內容
```css

/* Please visit the URL below for more information: */
/*   https://shd101wyy.github.io/markdown-preview-enhanced/#/customize-css */

@font-face {
  //font-family: 'cwTeX 圓體';
  //src: local('cwTeX 圓體');
  // 或
  font-family: 'myfont';
  src: url("/Users/yourhomename/fonts/超研澤字型/HEE01M.TTF") format("truetype");

}

.markdown-preview.markdown-preview {
  // modify your style here
  // eg: background-color: blue;
  // 在這裡編寫你的樣式
  // 例如：
  //  color: blue;          // 改變字體顏色
  //  font-size: 14px;      // 改變字體大小

  font-size: 18px;
  font-family: 'myfont', 'Courier New', Courier, monospace;

  img[src*="#w100"] {
    width: 100%;
  }

  img[src*="#w90"] {
    width: 90%;
  }

  img[src*="#w80"] {
    width: 80%;
  }

  img[src*="#w70"] {
    width: 70%;
  }

  img[src*="#w60"] {
    width: 60%;
  }

  img[src*="#w50"] {
    width: 50%;
  }

  img[src*="#w40"] {
    width: 40%;
  }

  img[src*="#w30"] {
    width: 30%;
  }

  img[src*="#w20"] {
    width: 20%;
  }

  img[src*="#w10"] {
    width: 10%;
  }

  // 自定義 pdf 導出樣式
  @media print {}

  pre,
  code {
    font-family: 'Fira Code';
    white-space: pre-wrap;
    font-size: 15px;
  }

  // 自定義 prince pdf 導出樣式
  &.prince {
    size: A4 Landscape;
    counter-reset: page 1 //  @bottom{
    //     content: "Page " counter(page) "  of " counter(page)
    //  }
  }

  // 自定義 presentation 樣式
  .reveal .slides {
    // 修改所有幻燈片
  }

  // 自定義 presentation 樣式
  .slides>section:nth-child(1) {
    // 修改 `第 1 個幻燈片`
  }

  .red {
    color: red;
  }

  .green {
    color: green;
  }

  .blue {
    color: blue;
  }

  .black {
    background-color: black;
  }

  .language-python {
    color: black;
  }

  .language-dart {
    color: red;
  }

  .language-java {
    color: black;
  }

  .inline {
    display: inline-block;
  }
}
```
