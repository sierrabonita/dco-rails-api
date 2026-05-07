puts "=== Skillsの初期化を開始します ==="

Skill.destroy_all

skills = [
  {
    name: "React",
    layer: "Frontend",
    rating: 5,
    description: "Vite, Next.js, ReactNativeの実装基盤"
  },
  {
    name: "Next.js",
    layer: "Frontend",
    rating: 4,
    description: "App Router / SSR / SSG / ルーティング設計"
  },
  {
    name: "Vite",
    layer: "Frontend",
    rating: 5,
    description: "SPA構築・Hooks・パフォーマンス最適化など"
  },
  {
    name: "React Native",
    layer: "NativeApp",
    rating: 4,
    description: "スマートフォンのネイティブアプリ開発"
  },
  {
    name: "NestJS",
    layer: "Backend",
    rating: 1,
    description: "認証・CRUD API・Prismaを用いたAPI実装"
  }
]

skills.each do |skill_param|
  Skill.create!(skill_param)
end

puts "=== Skillsの初期化が完了しました ==="
