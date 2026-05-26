# frozen_string_literal: true

puts "=== シードデータの投入を開始します ==="

# db/seeds/ フォルダ内の .rb ファイルを名前順に取得して実行する
Dir[Rails.root.join("db", "seeds", "*.rb")].sort.each { |file| require file }

puts "=== シードデータの投入が完了しました ==="
