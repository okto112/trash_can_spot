# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: 'admin@example.com',
  password: 'admin!'
)

Kind.create!([
  {name: "燃えるゴミ", color: "red" },
  { name: "プラスチック", color: "purple" },
  { name: "ペットボトル", color: "blue" },
  { name: "カン", color: "yellow" },
  { name: "ビン", color: "green" }
])
