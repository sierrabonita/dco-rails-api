# frozen_string_literal: true

Rails.logger.debug '=== シードデータの投入を開始します ==='

# db/seeds/ フォルダ内の .rb ファイルを名前順に取得して実行する
Rails.root.glob('db/seeds/*.rb').each { |file| require file }

Rails.logger.debug '=== シードデータの投入が完了しました ==='
