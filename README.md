[![IMAGE ALT TEXT HERE](https://jphacks.com/wp-content/uploads/2021/07/JPHACKS2021_ogp.jpg)](https://www.youtube.com/watch?v=LUPQFB4QyVo)

# D2G(Daily to Game)
<img src="https://github.com/jphacks/B_2114/blob/readme_image/d2g_main.png" width="100%">

| | |
|--|--|
|[![IMAGE ALT TEXT HERE](https://github.com/jphacks/B_2114/blob/readme_image/ss_walk.jpg)](https://www.youtube.com/watch?v=LUPQFB4QyVo)|[![IMAGE ALT TEXT HERE](https://github.com/jphacks/B_2114/blob/readme_image/ss_home.png)](https://www.youtube.com/watch?v=LUPQFB4QyVo)|

## 製品概要
### 背景(製品開発のきっかけ、課題等）
コロナ禍で暗いニュースが続く中、日常生活に「楽しさ」が必要であると私達は考えました。日常生活では通勤通学や買い物・散歩など、あらゆるシチュエーションで”移動”が伴います。そこで私達はより多くのユーザに影響を与えつつ、楽しいと感じる時間を最大化するために”移動”という行動そのものに着目しました。ではどのようにして移動を楽しくするのか、その答えの一つに「移動までもゲームにしてしまう」というアイデアを提案します。多くの人が感じたことのある「ゲームの楽しさ」を現実世界で感じることができれば社会はより明るくなります。この製品は日常生活行動を認識し、行動に対応するゲーム音を自動再生することでユーザを新たな世界観へと引き込みます。Daily to Game（日常にゲームを）。あなたがいる空間そのものをゲームの舞台へと変えてしまいましょう。もちろん、主人公はあなた自身です。

### 製品説明（具体的な製品の説明）
#### 日常×ゲーム×TECH
このシステムはスマートフォンに搭載されている各種センサの情報をもとにユーザの動作を認識し、それに対応するフィードバック（音声や画面描画）を行います。スマホアプリとして実装し、内蔵センサのみを使用するものでより多くの方に利用いただけます。

### 特長
- 歩く、走る、ジャンプするといった動作を認識し、それぞれに対応するゲーム音を自動的に再生します。
- BLEビーコンのシグナルを認識し、空間への入退室を識別した上で同様に対応するゲーム音を再生します。
- 上記の行動に応じてアプリの画面が変化します。画面上にはあなたの分身が登場し、現実世界とゲームの世界が同期します。

### 解決出来ること
移動という行動に対して”楽しさ”という新たな価値を提供することで、人々のストレス低減を図ります。

### 今後の展望
このシステムは移動というごく当たり前の行動に焦点を当てています。そのため、認識できる動作を増やすことでより多くの場面に適用することができます。例えば、「自動ドアの開扉」や「階段の上り下り」など、効果音再生のトリガーとなり得る動作は無数に存在します。

### 注力したこと（こだわり等）
* アプリのUIでは横スクロールアクションのゲームを意識することで、誰もがひと目でその振る舞いを認識できるよう心がけました。
* CreateMLを用いて独自に認識モデルを作成しました。クライアント側で処理が完結するため、アクティビティのプライバシーも保たれます。

## 開発技術
### 活用した技術
<img src="https://github.com/jphacks/B_2114/blob/readme_image/tech_spec.png" width="100%">

#### フレームワーク・ライブラリ・モジュール
* Swift
* SwiftUI
* CoreML
* CreateML

#### デバイス
* iPhone
* BLE Beacon

### デモ
https://youtu.be/ijUwAjiHuRA

### 独自技術
#### ハッカソンで開発した独自機能・技術
* 歩く，走る，ジャンプの行動認識モデル
* https://github.com/jphacks/B_2114/commit/f823d29c6130f016bada3cff459f6c18f1df601c
* https://github.com/jphacks/B_2114/commit/6e9830c206fc35e3569a54f91157d211288ed111
