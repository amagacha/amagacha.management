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
- `start-server.bat`: Windowsでローカル確認するための起動ファイル

Windowsでローカル確認する場合は、`index.html`を直接開かず `start-server.bat` をダブルクリックしてください。直接開いて白画面になるのは、ブラウザが `file://` のJavaScriptモジュールを制限するためです。

## Supabaseの安全性

`config.js` に入っているのはブラウザ公開用のSupabase URLとanonキーだけです。anonキーはRLSと組み合わせて使う公開キーです。`service_role`キー、DBパスワード、Management APIトークンは絶対にアップロードしないでください。

Supabase Dashboardの `Authentication` → `URL Configuration` で、公開後のGitHub Pages URLをSite URLまたはRedirect URLsに追加してください。将来メール確認やパスワードリセットを使う場合に必要です。

## プロジェクトサイト用の重要設定

通常のリポジトリで `https://ユーザー名.github.io/リポジトリ名/` として公開する場合、アップロード前に `config.js` の末尾を変更します。

```js
window.__KAISHI_BASE_PATH__ = "/リポジトリ名";
```

例としてリポジトリ名が `kaishi` なら、次のようにします。

```js
window.__KAISHI_BASE_PATH__ = "/kaishi";
```

この設定により、リンク移動とブラウザ再読み込みの両方がGitHub Pagesのサブフォルダ内で動作します。

## オーナー専用アカウント登録について

画面のアカウント管理はSupabase Edge Function `admin-users` を使用します。Edge Functionはservice_roleキーをサーバー側だけで使用するため、GitHub PagesのJavaScriptには秘密鍵を含めません。

この関数は `supabase/functions/admin-users/index.ts` に同梱しています。Supabase Dashboardの Edge Functions から `admin-users` としてデプロイし、`SUPABASE_SERVICE_ROLE_KEY` をサーバー側の秘密値として設定してください。Edge Functionのデプロイ権限があるSupabaseアクセストークンを使える場合は、プロジェクトルートで次を実行できます。

```bash
supabase functions deploy admin-users --project-ref lpzlhxfzosycqcgevfhk
```

デプロイ後、設定画面のオーナー専用「アカウント・権限管理」から名前・メールアドレス・一人ずつ異なる既定パスワード・権限を入力して登録できます。既定パスワードは表示せず、サーバー側で暗号化して保存します。

## 権限

- オーナー：全機能、ユーザー登録、権限変更、既定パスワード変更
- 管理者：商品・在庫・経費・生産の管理、売上管理
- 社員：売上登録、在庫参照、生産操作

日次パスワード更新を有効にするには、Edge Functionの環境変数に `ADMIN_USERS_ENCRYPTION_KEY`（32バイトBase64）と `DAILY_RESET_SECRET` を設定し、Supabase Cronまたは外部スケジューラから毎日次のJSONをPOSTしてください。ヘッダーの `x-cron-secret` は `DAILY_RESET_SECRET` と同じ値にします。

```json
{"action":"daily_reset"}
```

実行先は `https://lpzlhxfzosycqcgevfhk.supabase.co/functions/v1/admin-users` です。既定パスワードは平文でデータベースに保存されません。
