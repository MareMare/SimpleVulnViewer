# SimpleVulnViewer
脆弱性情報を簡単に表示するツールです。

### pwsh
https://github.com/MareMare/SimpleVulnViewer/blob/b4d9336c76c8336041bdeafd0f02361023c0807b/SimpleFetchData.ps1#L1-L47

### Power Query Formula Language
```m
let
    // 現在の日時を取得
    CurrentDateTime = DateTime.LocalNow(),
    // UNIX時間を計算
    UnixTime = Number.ToText(Duration.TotalSeconds(CurrentDateTime - #datetime(1970, 1, 1, 0, 0, 0))),
    // URLにUNIX時間を含める
    SourceUrl = "http://isec-myjvn-feed1.ipa.go.jp/IPARssReader.php?" & UnixTime & "&tool=icatw",
    // JSONデータを取得
    // Source = Json.Document(Web.Contents(SourceUrl)),
    Source = try Json.Document(Web.Contents(SourceUrl)) otherwise [itemdata = {}],
    // JSONの "itemdata" フィールドを取得
    ItemData = Source[itemdata],
    // テーブル形式に変換
    ItemTable = Table.FromList(ItemData, Splitter.SplitByNothing(), {"Column1"}),
    // レコードを展開
    ExpandedTable = Table.ExpandRecordColumn(ItemTable, "Column1", {"item_date", "item_title", "item_link"}),
    // フィルタリング条件を設定
    FilteredTable = Table.SelectRows(ExpandedTable, each Text.Contains([item_title], "Microsoft") or Text.Contains([item_title], "Adobe Acrobat") or Text.Contains([item_title], "Java"))
in
    FilteredTable
```
