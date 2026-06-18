# frozen_string_literal: true

# 1ページあたりのデフォルト取得件数（Pagy 8以降は limit を使用）
Pagy::OPTIONS[:limit] = 20

# JSONレスポンスのメタデータに含める項目を指定
Pagy::OPTIONS[:metadata] = [:count, :page, :limit, :pages, :next, :prev]
