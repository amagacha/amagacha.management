# 海士ガチャ GitHub Pages版

このフォルダは、HTTPSで公開できるGitHub Pages用の静的配布版です。GitHub Pagesは標準でHTTPSになります。

## 推奨公開方法

最も簡単で確実なのは、GitHubのユーザーサイトとして公開する方法です。

1. `ユーザー名.github.io` という名前のGitHubリポジトリを作成する
2. このフォルダ内のファイルをリポジトリのルートへアップロードする
3. `Settings` → `Pages` → `Build and deployment` で `Deploy from a branch` を選択する
4. Branchを `main`、Folderを `/ (root)` にして保存する
5. `https://ユーザー名.github.io/` を開く
6. `Settings` → `Pages` で `Enforce HTTPS` が有効になっていることを確認する

独自ドメインをGitHub Pagesに設定してルート公開する場合も同じ構成で利用できます。

## GitHubの通常リポジトリで公開する場合

`https://ユーザー名.github.io/リポジトリ名/` のようなプロジェクトサイトでは、Reactアプリのベースパス設定が必要です。現在の配布版はルート公開向けです。プロジェクトサイトで使う場合は、リポジトリ名に合わせてViteの `base` とルーターのベースパスを設定して再ビルドしてください。

`404.html` は `/sales` や `/inventory` などのSPAルートを直接開いたときのためのフォールバックです。
`.nojekyll` はGitHub PagesのJekyll処理を無効化します。

## ファイル

- `index.html`: HTMLエントリーポイント
- `app.js`: 本番ビルド済みJavaScript
- `styles.css`: 本番ビルド済みCSS
- `config.js`: Supabaseの公開URL・anonキーのみ
- `404.html`: SPAルート用のフォールバック
- `.nojekyll`: Jekyll処理の無効化
- `robots.txt`: 検索エンジンのクロール禁止

## Supabaseの安全性

`config.js` に入っているのはブラウザ公開用のSupabase URLとanonキーだけです。anonキーはRLSと組み合わせて使う公開キーです。`service_role`キー、DBパスワード、Management APIトークンは絶対にアップロードしないでください。

Supabase Dashboardの `Authentication` → `URL Configuration` で、公開後のGitHub Pages URLをSite URLまたはRedirect URLsに追加してください。将来メール確認やパスワードリセットを使う場合に必要です。
