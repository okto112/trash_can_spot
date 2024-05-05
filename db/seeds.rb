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
  { name: "燃えるゴミ", color: "red" },
  { name: "プラスチック", color: "purple" },
  { name: "ペットボトル", color: "blue" },
  { name: "カン", color: "yellow" },
  { name: "ビン", color: "green" }
])

User.find_or_create_by!(email: "taro@example.com") do |user|
  user.name = "太郎"
  user.password = "password"
end

User.find_or_create_by!(email: "jiro@example.com") do |user|
  user.name = "次郎"
  user.password = "password"
end

User.find_or_create_by!(email: "saburo@example.com") do |user|
  user.name = "三郎"
  user.password = "password"
end

Spot.create!([
  { user_id: 1, name: "コンビニのゴミ箱", introduction: "コンビニ前にゴミ箱があるます！", latitude: 34.70546234794342, longitude: 135.4913046582531, kind_ids: [1, 2, 3, 4 ,5] },
  { user_id: 1, name: "駅のゴミ箱", introduction: "改札の中ですが、ゴミ箱があります。", latitude: 34.697135786374965, longitude: 135.48666980107538, kind_ids: [1, 3, 4] },
  { user_id: 1, name: "自販機のゴミ箱", introduction: "自販機横にペットボトルのゴミ箱とカンとビンが捨てれるゴミ箱が2つあります！", latitude: 34.70256931561154, longitude: 135.50804164250604, kind_ids: [3, 4 ,5] },
  { user_id: 2, name: "ペットボトル専用！", introduction: "自販機から北側に少し離れたところ、ペットボトル専用のゴミ箱があります！", latitude: 34.6989705244564, longitude: 135.49739863713495, kind_ids: [3] },
  { user_id: 2, name: "地下のコンビニ", introduction: "コンビニ内にゴミ箱があります！", latitude: 34.7058504299508, longitude: 135.49901869137994, kind_ids: [1, 2, 3, 4 ,5] },
  { user_id: 2, name: "3階のトイレ前", introduction: "トイレ前に大きめのゴミ箱があります！", latitude: 34.70275895345108, longitude: 135.5006870253872, kind_ids: [1] }
])

Comment.create!([
  { user_id: 2, spot_id: 2, comment: "よく使う駅なので、とても助かります！" },
  { user_id: 2, spot_id: 3, comment: "ゴミの種類ごとにゴミ箱があって捨てやすいです" },
  { user_id: 1, spot_id: 5, comment: "少し小さめのゴミ箱なので、いっぱいになっている可能性があります" },
  { user_id: 3, spot_id: 2, comment: "ゴミ箱が改札の近くからトイレ前に移動していました" },
  { user_id: 3, spot_id: 5, comment: "この前ゴミが溢れていました！他のゴミ箱を探す方が良いかも" }
])