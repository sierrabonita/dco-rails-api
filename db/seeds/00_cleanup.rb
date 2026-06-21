# frozen_string_literal: true

Rails.logger.debug '--- 00_cleanup.rb を実行します（データの初期化） ---'

# 中間テーブルの削除
UserSkill.delete_all

# マスターテーブルの削除
Skill.delete_all

# メインテーブルの削除
User.delete_all

Rails.logger.debug '--- 00_cleanup.rb が完了しました ---'
