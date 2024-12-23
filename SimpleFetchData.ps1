# 現在のUNIX時間を取得
$unixTime = [int][double]::Parse((Get-Date -UFormat %s))

# URLを生成
$url = "http://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?$unixTime&tool=icatw"
$url

# GETリクエストを送信
try {
    $response = Invoke-WebRequest -Uri $url -Method GET
} catch {
    Write-Error "APIリクエストに失敗しました: $_"
    return
}

# レスポンスをJSONとして解析
$jsonResponse = $response.Content | ConvertFrom-Json

# 整形したJSONを表示
# $jsonResponse | ConvertTo-Json -Depth 10

# フィルタリング条件に一致する項目を抽出
$filteredItems = $jsonResponse.itemdata | Where-Object {
    $_.item_title -match "Microsoft" -or
    $_.item_title -match "Adobe Acrobat" -or
    $_.item_title -match "Java"
}

# 必要なデータ (item_date, item_title, item_link) を抽出してテーブルとして整形
$filteredItems | ForEach-Object {
    [PSCustomObject]@{
        Date  = $_.item_date
        Title = $_.item_title
        Link  = $_.item_link
    }
} | Format-Table -AutoSize

# 必要なデータ (item_date, item_title, item_link) を抽出してJSONとして出力
$filteredJson = $filteredItems | ForEach-Object {
    [PSCustomObject]@{
        Date  = $_.item_date
        Title = $_.item_title
        Link  = $_.item_link
    }
} | ConvertTo-Json -Depth 10

$filteredJson
