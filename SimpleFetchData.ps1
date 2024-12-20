# 現在のUNIX時間を取得
$unixTime = [int][double]::Parse((Get-Date -UFormat %s))

# URLを生成
$url = "http://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?$unixTime&tool=icatw"

# GETリクエストを送信
$response = Invoke-WebRequest -Uri $url -Method GET

# レスポンスをJSONとして解析
$jsonResponse = $response.Content | ConvertFrom-Json

# 整形して表示
$jsonResponse | ConvertTo-Json -Depth 10
