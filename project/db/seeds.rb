# 기본 시드 : 다른 관리자를 임명하기 위한 Super user(User)와 경기 규칙에 해당하는 Rule(id: 1~7)만 생성
# 주석 처리된 시드 : test를 위한 dummy seed
# 명령어 : rails/rake db:seed
# 싱글 인스턴스 형식 : Character.create(name: 'Luke', movie: movies.first)
# 복수 인스턴스 형식 : Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])

User.create([
  {name: 'sanam1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_owner", email: 'simian114@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 123, two_factor_auth: false},
  {name: 'yohlee1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_owner", email: 'yohan9612@naver.com', image_url: '/assets/test/t_avatar_2.png', point: 122, two_factor_auth: false},
  {name: 'eunhkim1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_owner", email: 'valhalla.host@gmail.com', image_url: '/assets/test/t_avatar_3.png', point: 33, two_factor_auth: false},
  {name: 'iwoo1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_owner", email: 'injun.woo30000@gmail.com', image_url: '/assets/test/t_avatar_4.png', point: 42, two_factor_auth: false},
  {name: 'jujeong1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_owner", email: 'juhyeonjeong92@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 90, two_factor_auth: false},
  {name: 'iwoo2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  position: "web_admin", email: 'injun.woo30001@gmail.com', image_url: '/assets/test/t_avatar_6.png', point: 78, two_factor_auth: false},
  {name: 'yohlee2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_admin", email: 'yohan9613@yonsei.ac.kr', image_url: '/assets/test/t_avatar_7.png', point: 83},
  {name: 'sanam2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_admin", email: 'simian115@gmail.com', image_url: '/assets/test/t_avatar_8.png', point: 92},
  {name: 'eunhkim2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_admin", email: 'valhalla.host2@gmail.com', image_url: '/assets/test/t_avatar_9.png', point: 20},
  {name: 'jujeong2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", position: "web_admin", email: 'juhyeonjeong93@gmail.com', image_url: '/assets/test/t_avatar_10.png', point: 40},
  {name: 'test', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'juhyeonjeong94@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 14},
  {name: 'test1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1@gmail.com', image_url: '/assets/test/t_avatar_2.png', point: 15},
  {name: 'test2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test2@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 12},
  {name: 'test3', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test3@gmail.com', image_url: '/assets/test/t_avatar_3.png', point: 13},
  {name: 'test4', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test4@gmail.com', image_url: '/assets/test/t_avatar_4.png', point: 14},
  {name: 'test5', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test5@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 15},
  {name: 'test6', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test6@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 16},
  {name: 'test7', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 17},
  {name: 'test8', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test8@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 18},
  {name: 'test9', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test9@gmail.com', image_url: '/assets/test/t_avatar_4.png', point: 19},
  {name: 'test10', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test10@gmail.com', image_url: '/assets/test/t_avatar_2.png', point: 11},
  {name: 'test11', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test11@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 12},
  {name: 'test12', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test12@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 13},
  {name: 'test13', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test13@gmail.com', image_url: '/assets/test/t_avatar_3.png', point: 14},
  {name: 'test14', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test14@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 15},
  {name: 'test15', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test15@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 16},
  {name: 'test16', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test16@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 17},
  {name: 'test17', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test17@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 18},
  {name: 'test18', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test18@gmail.com', image_url: '/assets/test/t_avatar_3.png', point: 19},
  {name: 'test19', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test19@gmail.com', image_url: '/assets/test/t_avatar_6.png', point: 11},
  {name: 'test20', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test20@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 12},
  {name: 'test21', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test21@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 13},
  {name: 'test22', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tessdfjt4@gmail.com', image_url: '/assets/test/t_avatar_7.png', point: 14},
  {name: 'test23', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tsdes1t5@gmail.com', image_url: '/assets/test/t_avatar_3.png', point: 15},
  {name: 'test24', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test126@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 16},
  {name: 'test25', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7zzzh@sdfgmail.com', image_url: '/assets/test/t_avatar_1.png', point: 17},
  {name: 'test26', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1238@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 18},
  {name: 'test27', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1239@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 19},
  {name: 'test28', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test28@gmail.com', image_url: '/assets/test/t_avatar_5.png', point: 11},
  {name: 'test29', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test29@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 12},
  {name: 'test30', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test30@gmail.com', image_url: '/assets/test/t_avatar_8.png', point: 13},
  {name: 'test31', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test31@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 14},
  {name: 'test32', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test32@gmail.com', image_url: '/assets/test/t_avatar_7.png', point: 15},
  {name: 'test33', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test33@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 16},
  {name: 'test34', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test34@gmail.com', image_url: '/assets/test/t_avatar_6.png', point: 17},
  {name: 'test35', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test35@gmail.com', image_url: '/assets/test/t_avatar_8.png', point: 18},
  {name: 'test36', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test36@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 19},
  {name: 'test37', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test37@gmail.com', image_url: '/assets/test/t_avatar_8.png', point: 11},
  {name: 'test38', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test38@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 12},
  {name: 'test39', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test39@gmail.com', image_url: '/assets/test/t_avatar_6.png', point: 13},
  {name: 'test40', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test40@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 14},
  {name: 'test41', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test41@gmail.com', image_url: '/assets/test/t_avatar_7.png', point: 15},
  {name: 'test42', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test42@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 16},
  {name: 'test43', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test43@sdfgmail.com', image_url: '/assets/test/t_avatar_1.png', point: 17},
  {name: 'test44', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test44@gmail.com', image_url: '/assets/test/t_avatar_8.png', point: 18},
  {name: 'test45', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test45@gmail.com', image_url: '/assets/test/t_avatar_1.png', point: 19},
])

Friendship.create([
  {user_id: 1, friend_id: 2},
  {user_id: 1, friend_id: 3},
  {user_id: 2, friend_id: 3},
  {user_id: 2, friend_id: 4},
])

Rule.create([
  {name: "classic"},
  {name: "invisible", invisible: true},
  {name: "dwindle", dwindle: true},
  {name: "accel_wall", accel_wall: true},
  {name: "accel_paddle", accel_paddle: true},
  {name: "bound_wall", bound_wall: true},
  {name: "bound_paddle", bound_paddle: true},
])

Guild.create([
  {owner_id: 1, name: "GUN42seoul", anagram: "@GUN4", image_url: "assets/test/t_guild_gun.png", point: 2000},
  {owner_id: 2, name: "GON42seoul", anagram: "@GON4", image_url: "assets/test/t_guild_gon.png", point: 150},
  {owner_id: 3, name: "GAM42seoul", anagram: "@GAM4", image_url: "assets/test/t_guild_gam.png", point: 200},
  {owner_id: 4, name: "LEE42seoul", anagram: "@LEE4", image_url: "assets/test/t_guild_lee.png", point: 300},
  {owner_id: 5, name: "142seoul", anagram: "@142", image_url: "assets/test/t_guild_lee.png", point: 400},
  {owner_id: 6, name: "2", anagram: "@2", image_url: "assets/test/t_guild_lee.png", point: 500},
  {owner_id: 7, name: "abcd", anagram: "@ad", image_url: "assets/test/t_guild_gun.png", point: 600},
  {owner_id: 8, name: "12eoul", anagram: "@12e", image_url: "assets/test/t_guild_gon.png", point: 700},
  {owner_id: 9, name: "seoul", anagram: "@soul", image_url: "assets/test/t_guild_gam.png", point: 800},
  {owner_id: 10, name: "123123", anagram: "@123", image_url: "assets/test/t_guild_lee.png", point: 900},
  {owner_id: 11, name: "42seoul", anagram: "@42se", image_url: "assets/test/t_guild_gun.png", point: 1000},
])

# Guild_id: 12, 13/ owner: test1, test6
Guild.create([
  {owner_id: 12, name: "test1", anagram: "@te1", image_url: "assets/test/t_guild_gun.png", point: 900},
  {owner_id: 17, name: "test2", anagram: "@te2", image_url: "assets/test/t_guild_lee.png", point: 1000},
])

WarRequest.create([
  {rule_id: 1, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 19 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 25 }), war_time: Time.zone.now.change({ hour: 10 }), max_no_reply_count: 3, include_ladder: true, include_tournament: true, target_match_score: 3, status: "accepted"},
  # {rule_id: 1, bet_point: 100, start_date: Time.zone.yesterday.midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 11 }), war_time: Time.zone.now.change({ hour: 10 }), max_no_reply_count: 3, include_ladder: true, include_tournament: true, target_match_score: 3, status: "accepted"},
  {rule_id: 2, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 20 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 26 }).midnight, war_time: Time.zone.now.change({ hour: 11 }), max_no_reply_count: 4, include_ladder: false, include_tournament: true, target_match_score: 5, status: "pending"},
  {rule_id: 3, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 21 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 27 }).midnight, war_time: Time.zone.now.change({ hour: 12 }), max_no_reply_count: 5, include_ladder: true, include_tournament: false, target_match_score: 7, status: "pending"},
  {rule_id: 4, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 22 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 24 }).midnight, war_time: Time.zone.now.change({ hour: 13 }), max_no_reply_count: 6, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
  {rule_id: 5, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 23 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 25 }).midnight, war_time: Time.zone.now.change({ hour: 14 }), max_no_reply_count: 6, include_ladder: false, include_tournament: false, target_match_score: 3, status: "pending"},
  {rule_id: 6, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 24 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 25 }).midnight, war_time: Time.zone.now.change({ hour: 15 }), max_no_reply_count: 3, include_ladder: true, include_tournament: true, target_match_score: 5, status: "pending"},
  {rule_id: 7, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 25 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 28 }).midnight, war_time: Time.zone.now.change({ hour: 16 }), max_no_reply_count: 9, include_ladder: true, include_tournament: true, target_match_score: 7, status: "pending"},
  {rule_id: 1, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 26 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 29 }).midnight, war_time: Time.zone.now.change({ hour: 17 }), max_no_reply_count: 10, include_ladder: false, include_tournament: false, target_match_score: 10, status: "pending"},
])

war_request_list = [
  {rule_id: 2, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 5 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 6 }).midnight, war_time: Time.zone.now.change({ hour: 18 }), max_no_reply_count: 3, include_ladder: false, include_tournament: false, target_match_score: 3, status: "pending"},
  {rule_id: 3, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 4 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 6 }).midnight, war_time: Time.zone.now.change({ hour: 19 }), max_no_reply_count: 5, include_ladder: false, include_tournament: true, target_match_score: 5, status: "accepted"},
  {rule_id: 4, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 3 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 4 }).midnight, war_time: Time.zone.now.change({ hour: 18 }), max_no_reply_count: 8, include_ladder: true, include_tournament: false, target_match_score: 7, status: "accepted"},
  {rule_id: 5, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 2 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 5 }).midnight, war_time: Time.zone.now.change({ hour: 17 }), max_no_reply_count: 10, include_ladder: false, include_tournament: true, target_match_score: 10, status: "accepted"},
  {rule_id: 6, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 3, day: 1 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 3, day: 5 }).midnight, war_time: Time.zone.now.change({ hour: 16 }), max_no_reply_count: 10, include_ladder: true, include_tournament: false, target_match_score: 3, status: "accepted"},
  {rule_id: 7, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 2, day: 1 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 2, day: 4 }).midnight, war_time: Time.zone.now.change({ hour: 15 }), max_no_reply_count: 10, include_ladder: false, include_tournament: true, target_match_score: 5, status: "accepted"},
  {rule_id: 1, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 2, day: 2 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 2, day: 7 }).midnight, war_time: Time.zone.now.change({ hour: 14 }), max_no_reply_count: 10, include_ladder: true, include_tournament: false, target_match_score: 3, status: "accepted"},
  {rule_id: 2, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 2, day: 3 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 2, day: 8 }).midnight, war_time: Time.zone.now.change({ hour: 13 }), max_no_reply_count: 10, include_ladder: false, include_tournament: true, target_match_score: 5, status: "accepted"},
  {rule_id: 3, bet_point: 100, start_date: Time.zone.now.change({ year: 2021, month: 2, day: 4 }).midnight, end_date: Time.zone.now.change({ year: 2021, month: 2, day: 9 }).midnight, war_time: Time.zone.now.change({ hour: 12 }), max_no_reply_count: 10, include_ladder: true, include_tournament: false, target_match_score: 3, status: "accepted"},
  {rule_id: 4, bet_point: 100, start_date: Time.zone.tomorrow.midnight, end_date: Time.zone.tomorrow.midnight + 3.days, war_time: Time.zone.now.change({ hour: 11 }), max_no_reply_count: 10, include_ladder: false, include_tournament: true, target_match_score: 5, status: "accepted"},
  # 테스트용
  {rule_id: 1, bet_point: 100, start_date: Time.zone.yesterday.midnight, end_date: Time.zone.yesterday.midnight.change({ year: 2021, month: 3, day: 13 }) + 3.days, war_time: Time.zone.now, max_no_reply_count: 3, include_ladder: true, include_tournament: true, target_match_score: 3, status: "accepted"},
]

war_request_list.each do |war_request|
  WarRequest.new(war_request).save(validate: false)
end

War.create([
  {war_request_id: 10, status: "completed"},
  {war_request_id: 11, status: "completed"},
  {war_request_id: 12, status: "completed"},
  {war_request_id: 13, status: "completed"},
  {war_request_id: 14, status: "completed"},
  {war_request_id: 15, status: "completed"},
  {war_request_id: 16, status: "completed"},
  {war_request_id: 17, status: "completed"},
  {war_request_id: 18, status: "pending"},
])

War.create([
  {war_request_id: 19, status: "progress"},
])

Match.create([
  {rule_id: 6, status: "completed", match_type: "dual"},
  {rule_id: 1, status: "completed", match_type: "dual"},
  {rule_id: 2, status: "completed", match_type: "ladder"},
  {rule_id: 4, status: "completed", match_type: "ladder"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "war"},
  {rule_id: 3, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "war"},
  {rule_id: 5, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "war"},
  {rule_id: 3, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "war"},
  {rule_id: 5, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "war"},
  {rule_id: 1, status: "pending", eventable_type: "Tournament", eventable_id: 1, match_type: "tournament", start_time: Time.find_zone('Seoul').parse('2021-03-04 15pm')},
  {rule_id: 2, status: "pending", eventable_type: "Tournament", eventable_id: 2, match_type: "tournament", start_time: Time.find_zone('Seoul').parse('2021-03-04 16pm')},
  {rule_id: 3, status: "pending", eventable_type: "Tournament", eventable_id: 3, match_type: "tournament", start_time: Time.find_zone('Seoul').parse('2021-03-04 17pm')},
])

Match.create([
  # TODO: updated_at 시간을 어제와 지금 사이로 만들기
  {rule_id: 1, status: "completed", match_type: "dual", updated_at: Time.zone.yesterday},
  {rule_id: 1, status: "completed", match_type: "dual", updated_at: Time.zone.yesterday},
  {rule_id: 1, status: "completed", match_type: "ladder", updated_at: Time.zone.yesterday},
  {rule_id: 1, status: "completed", match_type: "ladder", updated_at: Time.zone.yesterday},
  {rule_id: 1, status: "completed", match_type: "dual", updated_at: Time.zone.yesterday},
  {rule_id: 1, status: "completed", match_type: "dual", updated_at: Time.zone.yesterday},
])

Scorecard.create([
  {user_id: 12, score: 3, result: "win", match_id: 18, side: "left"},
  {user_id: 17, score: 2, result: "lose", match_id: 18, side: "right"},

  {user_id: 12, score: 3, result: "lose", match_id: 19, side: "left"},
  {user_id: 17, score: 2, result: "win", match_id: 19, side: "right"},

  {user_id: 13, score: 3, result: "win", match_id: 20, side: "left"},
  {user_id: 18, score: 2, result: "lose", match_id: 20, side: "right"},

  {user_id: 14, score: 3, result: "lose", match_id: 21, side: "left"},
  {user_id: 19, score: 2, result: "win", match_id: 21, side: "right"},

  {user_id: 15, score: 3, result: "lose", match_id: 22, side: "left"},
  {user_id: 20, score: 2, result: "win", match_id: 22, side: "right"},

  {user_id: 16, score: 3, result: "lose", match_id: 23, side: "left"},
  {user_id: 21, score: 2, result: "win", match_id: 23, side: "right"},
])

Scorecard.create([
  {user_id: 2, score: 3, result: "win", match_id: 1, side: "left"},
  {user_id: 2, score: 3, result: "win", match_id: 2, side: "left"},
  {user_id: 2, score: 3, result: "win", match_id: 3, side: "left"},
  {user_id: 2, score: 3, result: "win", match_id: 4, side: "right"},
  {user_id: 2, score: 3, result: "win", match_id: 5, side: "left"},
  {user_id: 2, score: 3, result: "win", match_id: 6, side: "left"},
  {user_id: 2, score: 2, result: "win", match_id: 7, side: "left"},
  {user_id: 2, score: 2, result: "win", match_id: 8, side: "right"},
  {user_id: 2, score: 2, result: "lose", match_id: 9, side: "right"},
  {user_id: 2, score: 1, result: "lose", match_id: 10, side: "left"},
  {user_id: 2, score: 0, result: "lose", match_id: 11, side: "right"},
  {user_id: 1, score: 2, result: "lose", match_id: 1, side: "right"},
  {user_id: 3, score: 1, result: "lose", match_id: 2, side: "right"},
  {user_id: 4, score: 0, result: "lose", match_id: 3, side: "right"},
  {user_id: 5, score: 2, result: "lose", match_id: 4, side: "left"},
  {user_id: 6, score: 1, result: "lose", match_id: 5, side: "right"},
  {user_id: 7, score: 0, result: "lose", match_id: 6, side: "right"},
  {user_id: 8, score: 1, result: "lose", match_id: 7, side: "right"},
  {user_id: 9, score: 2, result: "lose", match_id: 8, side: "left"},
  {user_id: 10, score: 1, result: "win",  match_id: 9, side: "left"},
  {user_id: 8, score: 2, result: "win",  match_id: 10, side: "right"},
  {user_id: 1, score: 0, result: "win", match_id: 11, side: "left"},
  {user_id: 1, score: 1, result: "win", match_id: 12, side: "left"},
  {user_id: 1, score: 2, result: "win", match_id: 13, side: "left"},
  {user_id: 1, score: 3, result: "win", match_id: 14, side: "left"},
  {user_id: 10, score: 0, result: "lose", match_id: 12, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 13, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 14, side: "right"},

  {user_id: 1, score: 0, result: "wait", match_id: 15, side: "left"},
  {user_id: 4, score: 0, result: "wait", match_id: 15, side: "right"},
  {user_id: 2, score: 0, result: "wait", match_id: 16, side: "left"},
  {user_id: 5, score: 0, result: "wait", match_id: 16, side: "right"},
  {user_id: 3, score: 0, result: "wait", match_id: 17, side: "left"},
  {user_id: 6, score: 0, result: "wait", match_id: 17, side: "right"},
])

GroupChatRoom.create([
  {owner_id: 1, room_type: "public", title: "room 1", channel_code: "XXX-XXX-XX1", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 1, room_type: "public", title: "room 2", channel_code: "XXX-XXX-XX2" },
  {owner_id: 2, room_type: "public", title: "room 3", channel_code: "XXX-XXX-XX3", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 2, room_type: "public", title: "room 4", channel_code: "XXX-XXX-XX4" },
  {owner_id: 3, room_type: "public", title: "room 5", channel_code: "XXX-XXX-XX5", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 3, room_type: "public", title: "room 6", channel_code: "XXX-XXX-XX6" },

  {owner_id: 1, room_type: "private", title: "room 7", channel_code: "XXX-XXX-XX7", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 1, room_type: "private", title: "room 8", channel_code: "XXX-XXX-XX8" },
  {owner_id: 2, room_type: "private", title: "room 9", channel_code: "XXX-XXX-XX9", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 2, room_type: "private", title: "room 10", channel_code: "XXX-XXX-X10" },
  {owner_id: 3, room_type: "private", title: "room 11", channel_code: "XXX-XXX-X11", password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO"},
  {owner_id: 3, room_type: "private", title: "room 12", channel_code: "XXX-XXX-X12" },
])

GroupChatMembership.create([
  {user_id: 1, group_chat_room_id: 1, position: "owner", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 2, position: "owner", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 3, position: "admin", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 4, position: "admin", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 5, position: "member", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 6, position: "member", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 7, position: "owner", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 8, position: "owner", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 9, position: "admin", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 10, position: "admin", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 11, position: "member", ban_ends_at: nil},
  {user_id: 1, group_chat_room_id: 12, position: "member", ban_ends_at: nil},

  {user_id: 2, group_chat_room_id: 3, position: "owner", ban_ends_at: nil},
  {user_id: 2, group_chat_room_id: 4, position: "owner", ban_ends_at: nil},
  {user_id: 2, group_chat_room_id: 9, position: "owner", ban_ends_at: nil},
  {user_id: 2, group_chat_room_id: 10, position: "owner", ban_ends_at: nil},

  {user_id: 3, group_chat_room_id: 5, position: "owner", ban_ends_at: nil},
  {user_id: 3, group_chat_room_id: 6, position: "owner", ban_ends_at: nil},
  {user_id: 3, group_chat_room_id: 11, position: "owner", ban_ends_at: nil},
  {user_id: 3, group_chat_room_id: 12, position: "owner", ban_ends_at: nil},

  {user_id: 4, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 5, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 6, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 7, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 8, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 9, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 10, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
  {user_id: 11, group_chat_room_id: 1, position: "member", ban_ends_at: nil},
])

DirectChatRoom.create([
  {symbol: '1+3'},
])

DirectChatMembership.create([
  {user_id: 1, direct_chat_room_id: 1},
  {user_id: 3, direct_chat_room_id: 1},
])

ChatMessage.create([
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "Hello, eunhkim!"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "Hi, Sanam!"},
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "안녕하세요. eunhkim!"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "안녕하세요, Sanam!"},
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "메시지는 잘 뜨나요?"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "네. 잘 뜨네요!"},

  {user_id: 1, room_type: "GroupChatRoom", room_id: 1, message: "쓸쓸한 부패를 긴지라 사는가 이는 속에서 영원히 영락과 소리다.이것은 것이다. 귀는 청춘의 발휘하기 대한 봄바람이다. 피어나기 충분히 들어 부패뿐이다. 작고 얼마나 피부가 군영과 천고에 끝에 이것이다. 영락과 맺어, 사랑의 대중을 어디 약동하다. 착목한는 더운지라 그들은 피가 곳으로 있는가? 무엇이 우리의 대중을 곳이 할지라도 남는 구할 청춘의 커다란 것이다. 피가 새가 과실이 그것을 부패를 우리는 것이다. 품었기 가는 있음으로써 것이다."},
  {user_id: 4, room_type: "GroupChatRoom", room_id: 1, message: "1"},
  {user_id: 5, room_type: "GroupChatRoom", room_id: 1, message: "2!"},
  {user_id: 6, room_type: "GroupChatRoom", room_id: 1, message: "것은 우리 품고 맺어, 생의 사랑의 가치를 봄바람이다. 가슴에 보이는 구하지 청춘의 교향악이다. 끓는 이상의 자신과 가진 우는 가슴이 인생을 돋고, 부패뿐이다. 끓는 발휘하기 어디 가장 청춘의 오아이스도 사막이다. 이상의 꽃이 끝에 교향악이다. 뛰노는 속에서 가치를 대고, 방황하였으며, 하여도 위하여서 산야에 약동하다. 가치를 피가 싹이 쓸쓸하랴? 용기가 용감하고 그들의 보라. 이것은 길지 뼈 넣는 인생을 들어 가치를 위하여 발휘하기 때문이다. 있을 관현악이며, 열락의 꽃이 불어 따뜻한 충분히 그러므로 물방아 이것이다. 커다란 뛰노는 찾아다녀도, 끓는다.
    것이 보는 뜨고, 것이다. 실로 인간의 곳이 타오르고 끓는다. 주며, 이상의 광야에서 이상의 미묘한 거친 발휘하기 것이다. 두손을 청춘에서만 사랑의 위하여서, 노년에게서 않는 방지하는 것이다. 아니한 그들에게 있는 것이다. 소리다.이것은 있는 충분히 따뜻한 있다. 없는 더운지라 뼈 하여도 인생의 것이다. 능히 얼음이 피고 아름답고 황금시대의 같이, 이것을 위하여서. 천자만홍이 기관과 것은 두손을 천고에 현저하게 그것을 행복스럽고 그들은 보라. 돋고, 곧 속에 싹이 그들에게 청춘을 위하여서 남는 심장의 보라. 그림자는 무엇을 방황하여도, 맺어, 아름다우냐?
    것은 기관과 봄날의 그리하였는가? 길지 석가는 피어나기 것은 이것이다. 돋고, 가치를 아니한 더운지라 봄바람이다. 우리는 위하여 품에 무엇을 듣는다. 같이 우리 만물은 생명을 인간의 없는 아름답고 있으랴? 이 수 실현에 피가 거친 구하지 쓸쓸하랴? 피가 새가 구하기 지혜는 칼이다. 보배를 찾아다녀도, 많이 심장의 눈이 사막이다. 않는 그들은 풀밭에 열락의 발휘하기 보배를 운다."},
  {user_id: 7, room_type: "GroupChatRoom", room_id: 1, message: "test3"},
  {user_id: 1, room_type: "GroupChatRoom", room_id: 1, message: "test4"},
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "Hello, eunhkim!"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "Hi, Sanam!"},
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "안녕하세요. eunhkim!"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "안녕하세요, Sanam!"},
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "메시지는 잘 뜨나요?"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 1, message: "네. 잘 뜨네요!"},

  {user_id: 1, room_type: "GroupChatRoom", room_id: 1, message: "쓸쓸한 부패를 긴지라 사는가 이는 속에서 영원히 영락과 소리다.이것은 것이다. 귀는 청춘의 발휘하기 대한 봄바람이다. 피어나기 충분히 들어 부패뿐이다. 작고 얼마나 피부가 군영과 천고에 끝에 이것이다. 영락과 맺어, 사랑의 대중을 어디 약동하다. 착목한는 더운지라 그들은 피가 곳으로 있는가? 무엇이 우리의 대중을 곳이 할지라도 남는 구할 청춘의 커다란 것이다. 피가 새가 과실이 그것을 부패를 우리는 것이다. 품었기 가는 있음으로써 것이다."},
  {user_id: 4, room_type: "GroupChatRoom", room_id: 1, message: "1"},
  {user_id: 5, room_type: "GroupChatRoom", room_id: 1, message: "2!"},
  {user_id: 6, room_type: "GroupChatRoom", room_id: 1, message: "것은 우리 품고 맺어, 생의 사랑의 가치를 봄바람이다. 가슴에 보이는 구하지 청춘의 교향악이다. 끓는 이상의 자신과 가진 우는 가슴이 인생을 돋고, 부패뿐이다. 끓는 발휘하기 어디 가장 청춘의 오아이스도 사막이다. 이상의 꽃이 끝에 교향악이다. 뛰노는 속에서 가치를 대고, 방황하였으며, 하여도 위하여서 산야에 약동하다. 가치를 피가 싹이 쓸쓸하랴? 용기가 용감하고 그들의 보라. 이것은 길지 뼈 넣는 인생을 들어 가치를 위하여 발휘하기 때문이다. 있을 관현악이며, 열락의 꽃이 불어 따뜻한 충분히 그러므로 물방아 이것이다. 커다란 뛰노는 찾아다녀도, 끓는다.
    것이 보는 뜨고, 것이다. 실로 인간의 곳이 타오르고 끓는다. 주며, 이상의 광야에서 이상의 미묘한 거친 발휘하기 것이다. 두손을 청춘에서만 사랑의 위하여서, 노년에게서 않는 방지하는 것이다. 아니한 그들에게 있는 것이다. 소리다.이것은 있는 충분히 따뜻한 있다. 없는 더운지라 뼈 하여도 인생의 것이다. 능히 얼음이 피고 아름답고 황금시대의 같이, 이것을 위하여서. 천자만홍이 기관과 것은 두손을 천고에 현저하게 그것을 행복스럽고 그들은 보라. 돋고, 곧 속에 싹이 그들에게 청춘을 위하여서 남는 심장의 보라. 그림자는 무엇을 방황하여도, 맺어, 아름다우냐?
    것은 기관과 봄날의 그리하였는가? 길지 석가는 피어나기 것은 이것이다. 돋고, 가치를 아니한 더운지라 봄바람이다. 우리는 위하여 품에 무엇을 듣는다. 같이 우리 만물은 생명을 인간의 없는 아름답고 있으랴? 이 수 실현에 피가 거친 구하지 쓸쓸하랴? 피가 새가 구하기 지혜는 칼이다. 보배를 찾아다녀도, 많이 심장의 눈이 사막이다. 않는 그들은 풀밭에 열락의 발휘하기 보배를 운다."},
  {user_id: 7, room_type: "GroupChatRoom", room_id: 1, message: "test3"},
  {user_id: 1, room_type: "GroupChatRoom", room_id: 1, message: "test4"},
])

ChatBan.create([
  {user_id: 1, banned_user_id: 2},
  {user_id: 2, banned_user_id: 3},
  {user_id: 3, banned_user_id: 4},
])

DirectChatMembership.create([
  {user_id: 1, direct_chat_room_id:1},
  {user_id: 2, direct_chat_room_id:1},
  {user_id: 3, direct_chat_room_id:2},
  {user_id: 4, direct_chat_room_id:2},
])

GuildMembership.create([
  {user_id: 1, guild_id: 1, position: "master"},
  {user_id: 2, guild_id: 2, position: "master"},
  {user_id: 3, guild_id: 3, position: "master"},
  {user_id: 4, guild_id: 4, position: "master"},
  {user_id: 5, guild_id: 5, position: "master"},
  {user_id: 6, guild_id: 6, position: "master"},
  {user_id: 7, guild_id: 7, position: "master"},
  {user_id: 8, guild_id: 8, position: "master"},
  {user_id: 9, guild_id: 9, position: "master"},
  {user_id: 10, guild_id: 1, position: "officer"},
  {user_id: 11, guild_id: 1, position: "officer"},

  # test1 길드원 test1 ~ test5
  {user_id: 12, guild_id: 12, position: "master"},
  {user_id: 13, guild_id: 12, position: "officer"},
  {user_id: 14, guild_id: 12, position: "member"},
  {user_id: 15, guild_id: 12, position: "member"},
  {user_id: 16, guild_id: 12, position: "member"},

  # test2 길드원 test6~ test10
  {user_id: 17, guild_id: 13, position: "master"},
  {user_id: 18, guild_id: 13, position: "officer"},
  {user_id: 19, guild_id: 13, position: "member"},
  {user_id: 20, guild_id: 13, position: "member"},
  {user_id: 21, guild_id: 13, position: "member"},

  {user_id: 22, guild_id: 11, position: "officer"},
  {user_id: 23, guild_id: 1, position: "officer"},
  {user_id: 24, guild_id: 3, position: "member"},
  {user_id: 25, guild_id: 3, position: "member"},
  {user_id: 26, guild_id: 4, position: "member"},
  {user_id: 27, guild_id: 5, position: "member"},
  {user_id: 28, guild_id: 6, position: "member"},
  {user_id: 29, guild_id: 10, position: "member"},
  {user_id: 30, guild_id: 8, position: "member"},
  {user_id: 31, guild_id: 8, position: "member"},
  {user_id: 32, guild_id: 9, position: "member"},
  {user_id: 33, guild_id: 11, position: "member"},
  {user_id: 34, guild_id: 10, position: "member"},
  {user_id: 35, guild_id: 1, position: "member"},
  {user_id: 36, guild_id: 1, position: "member"},
  {user_id: 37, guild_id: 1, position: "member"},
  {user_id: 38, guild_id: 1, position: "member"},
  {user_id: 39, guild_id: 1, position: "member"},
  {user_id: 40, guild_id: 4, position: "member"},
  {user_id: 41, guild_id: 3, position: "member"},
  {user_id: 42, guild_id: 2, position: "member"},
  {user_id: 43, guild_id: 1, position: "member"},
  {user_id: 44, guild_id: 11, position: "member"},
  {user_id: 45, guild_id: 11, position: "member"},
  {user_id: 46, guild_id: 10, position: "member"},
  {user_id: 47, guild_id: 9, position: "member"},
  {user_id: 48, guild_id: 8, position: "member"},
  {user_id: 49, guild_id: 8, position: "member"},
  {user_id: 50, guild_id: 7, position: "member"},
  {user_id: 51, guild_id: 6, position: "member"},
  {user_id: 52, guild_id: 5, position: "member"},
  {user_id: 53, guild_id: 4, position: "member"},
  {user_id: 54, guild_id: 3, position: "member"},

])

GuildInvitation.create([
  {user_id: 1, invited_user_id: 55, guild_id: 1},
  {user_id: 2, invited_user_id: 55, guild_id: 2},
  {user_id: 3, invited_user_id: 55, guild_id: 3},
  {user_id: 4, invited_user_id: 56, guild_id: 4},
  {user_id: 5, invited_user_id: 56, guild_id: 5},
  {user_id: 1, invited_user_id: 56, guild_id: 1},
  {user_id: 7, invited_user_id: 56, guild_id: 7},
  {user_id: 1, invited_user_id: 56, guild_id: 1},
])

Tournament.create([
  {rule_id: 1, title: "둘다접속토너먼트", status: "progress", start_date: Time.zone.tomorrow.midnight, tournament_time: Time.zone.now.change({hour:15}) },
  {rule_id: 2, title: "한명접속토너먼트", status: "progress", start_date: Time.zone.tomorrow.midnight, tournament_time: Time.zone.now.change({hour:16}) },
  {rule_id: 3, title: "미접속토너먼트", status: "progress", start_date: Time.zone.tomorrow.midnight, tournament_time: Time.zone.now.change({hour:17})},
])

TournamentMembership.create([
  {user_id: 1, tournament_id: 1, status: "progress"},
  {user_id: 4, tournament_id: 1, status: "progress"},
  {user_id: 2, tournament_id: 2, status: "progress"},
  {user_id: 5, tournament_id: 2, status: "progress"},
  {user_id: 3, tournament_id: 3, status: "progress"},
  {user_id: 6, tournament_id: 3, status: "progress"},
])

WarStatus.create([
  {guild_id: 3, war_request_id: 2, position: "challenger", point: "400"},
  {guild_id: 1, war_request_id: 2, position: "enemy", point: "300"},
  {guild_id: 4, war_request_id: 3, position: "challenger", point: "400"},
  {guild_id: 1, war_request_id: 3, position: "enemy", point: "300"},
  {guild_id: 5, war_request_id: 4, position: "challenger", point: "400"},
  {guild_id: 1, war_request_id: 4, position: "enemy", point: "300"},
  {guild_id: 6, war_request_id: 5, position: "challenger", point: "400"},
  {guild_id: 1, war_request_id: 5, position: "enemy", point: "300"},
  {guild_id: 3, war_request_id: 6, position: "challenger", point: "400"},
  {guild_id: 2, war_request_id: 6, position: "enemy", point: "300"},
  {guild_id: 4, war_request_id: 7, position: "challenger", point: "400"},
  {guild_id: 2, war_request_id: 7, position: "enemy", point: "300"},
  {guild_id: 5, war_request_id: 8, position: "challenger", point: "400"},
  {guild_id: 2, war_request_id: 8, position: "enemy", point: "300"},
  {guild_id: 1, war_request_id: 9, position: "challenger", point: "400"},
  {guild_id: 3, war_request_id: 9, position: "enemy", point: "300"},
  {guild_id: 1, war_request_id: 10, position: "challenger", point: "200"},
  {guild_id: 4, war_request_id: 10, position: "enemy", point: "300"},
  {guild_id: 2, war_request_id: 11, position: "challenger", point: "500"},
  {guild_id: 5, war_request_id: 11, position: "enemy", point: "400"},
  {guild_id: 2, war_request_id: 12, position: "challenger", point: "500"},
  {guild_id: 6, war_request_id: 12, position: "enemy", point: "600"},
  {guild_id: 1, war_request_id: 13, position: "challenger", point: "100"},
  {guild_id: 5, war_request_id: 13, position: "enemy", point: "300"},
  {guild_id: 1, war_request_id: 14, position: "challenger", point: "200"},
  {guild_id: 6, war_request_id: 14, position: "enemy", point: "400"},
  {guild_id: 2, war_request_id: 15, position: "challenger", point: "500"},
  {guild_id: 1, war_request_id: 15, position: "enemy", point: "300"},
  {guild_id: 1, war_request_id: 16, position: "challenger", point: "100"},
  {guild_id: 2, war_request_id: 16, position: "enemy", point: "100"},
  {guild_id: 5, war_request_id: 17, position: "challenger", point: "350"},
  {guild_id: 1, war_request_id: 17, position: "enemy", point: "450"},
  # war pending 상태
  {guild_id: 10, war_request_id: 18, position: "challenger"},
  {guild_id: 11, war_request_id: 18, position: "enemy"},
])


WarStatus.create([
  # war progress 상태
  {guild_id: 12, war_request_id: 19, position: "challenger", point: "50", no_reply_count: 1},
  {guild_id: 13, war_request_id: 19, position: "enemy", point: "250", no_reply_count: 2}
])
