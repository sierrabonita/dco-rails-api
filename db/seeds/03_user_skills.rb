# frozen_string_literal: true

Rails.logger.debug '--- 03_user_skills.rb を実行中 ---'

UserSkill.destroy_all

user_skills_data_map = {
  'normal_1@test.com' => [
    {
      name: 'React',
      rating: 4,
      description: 'Vite, Next.js, ReactNativeの実装基盤'
    },
    {
      name: 'Next.js',
      rating: 3,
      description: 'App Router / SSR / SSG / ルーティング設計'
    },
    { name: 'Vite', rating: 5, description: 'SPA構築・Hooks・パフォーマンス最適化など' },
    { name: 'React Native', rating: 4, description: 'スマートフォンのネイティブアプリ開発' },
    {
      name: 'Ruby on Rails',
      rating: 1,
      description: '認証・CRUD API・ActiveRecordを用いたAPI実装'
    }
  ],
  'normal_2@test.com' => [
    { name: 'Vue.js', rating: 4, description: 'Composition APIによるコンポーネント設計' },
    { name: 'TypeScript', rating: 4, description: '型安全なフロントエンド開発' },
    { name: 'Go', rating: 3, description: 'バックエンドAPIの実装' },
    { name: 'Docker/Kubernetes', rating: 2, description: 'コンテナ基盤の構築と運用' }
  ]
}

user_skills_data_map.each do |email, skills_data|
  user = User.find_by!(email: email)

  skills_data.each do |data|
    skill_master = Skill.find_by!(name: data[:name])

    user.user_skills.create!(
      skill: skill_master,
      rating: data[:rating],
      description: data[:description]
    )
  end
end

Rails.logger.debug '--- 03_user_skills.rb が完了しました ---'
