# frozen_string_literal: true

Rails.logger.debug '--- 02_users.rb を実行中 ---'

User.destroy_all

users_data = [
  { name: '管理太郎', email: 'admin_1@test.com', password: 'Password0_', role: 'admin' },
  { name: '山田太郎', email: 'normal_1@test.com', password: 'Password0_', role: 'normal' },
  { name: '田中花子', email: 'normal_2@test.com', password: 'Password0_', role: 'normal' }
]

users_data.each { |data| User.create!(data) }

Rails.logger.debug '--- 02_users.rb が完了しました ---'
