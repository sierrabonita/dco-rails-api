puts "--- 03_user_skills.rb を実行中 ---"

UserSkill.destroy_all

test_user = User.find_by!(email: "test_1@test.com")
test_user_skills_data = [
  { name: "React", rating: 4, description: "Vite, Next.js, ReactNativeの実装基盤" },
  {
    name: "Next.js",
    rating: 3,
    description: "App Router / SSR / SSG / ルーティング設計"
  },
  { name: "Vite", rating: 5, description: "SPA構築・Hooks・パフォーマンス最適化など" },
  { name: "React Native", rating: 4, description: "スマートフォンのネイティブアプリ開発" },
  {
    name: "Ruby on Rails",
    rating: 1,
    description: "認証・CRUD API・ActiveRecordを用いたAPI実装"
  }
]

test_user_skills_data.each do |data|
  skill_master = Skill.find_by!(name: data[:name])

  test_user.user_skills.create!(
    skill: skill_master,
    rating: data[:rating],
    description: data[:description]
  )
end

puts "--- 03_user_skills.rb が完了しました ---"
