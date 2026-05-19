puts "--- 01_skills.rb を実行中 ---"

Skill.destroy_all

skills_data = [
  { name: "React", layer: "Frontend" },
  { name: "Next.js", layer: "Frontend" },
  { name: "Vue.js", layer: "Frontend" },
  { name: "TypeScript", layer: "Frontend" },
  { name: "Vite", layer: "Frontend" },
  { name: "React Native", layer: "NativeApp" },
  { name: "Ruby on Rails", layer: "Backend" },
  { name: "Go", layer: "Backend" },
  { name: "Python", layer: "Backend" },
  { name: "AWS", layer: "Infrastructure" },
  { name: "Docker/Kubernetes", layer: "Infrastructure" },
  { name: "Figma", layer: "Design" }
]

skills_data.each { |data| Skill.create!(data) }

puts "--- 01_skills.rb が完了しました ---"
