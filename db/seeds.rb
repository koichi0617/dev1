Major.create(:name => '文・文')
Major.create(:name => '文・総人')
Major.create(:name => '文・コミ情')
Major.create(:name => '文・歴史')
Major.create(:name => '教・小学校')
Major.create(:name => '教・中学校')
Major.create(:name => '教・特別支援')
Major.create(:name => '教・養教')
Major.create(:name => '教・社会')
Major.create(:name => '法・法')
Major.create(:name => '理・理')
Major.create(:name => '工・建築')
Major.create(:name => '工・社環')
Major.create(:name => '工・情電')
Major.create(:name => '工・機シス')
Major.create(:name => '工・数理')
Major.create(:name => '工・物生')
Major.create(:name => '工・マテ')
Major.create(:name => '医・医')
Major.create(:name => '医・保健')
Major.create(:name => '薬・薬')
Major.create(:name => '薬・創薬')

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             major_id: 1)

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               major_id: 2)
end

users = User.order(:created_at).take(6)
5.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content, major_id: 2, subject: content) }
end


Resolve.create!(:name => '解決済み', :solve => true)
Resolve.create!(:name => '未解決', :solve => false)

Board.create!(:name => 'メンバー募集！', :content => 'みんなおいで！', :user_id => 1)
Board.create!(:name => 'メンバー募集！', :content => 'みんなこいよ！', :user_id => 2)
Board.create!(:name => 'メンバー募集！', :content => 'みんなカモン！', :user_id => 3)