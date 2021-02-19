# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {name: 'sanam1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'simian114@gmail.com', image_url: 'assets/sanam1.png', point: 123, two_factor_auth: false},
  {name: 'yohlee1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'yohan9612@naver.com', image_url: 'assets/yohlee1.png', point: 122, two_factor_auth: false},
  {name: 'eunhkim1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'valhalla.host@gmail.com', image_url: '/assets/eunhkim1.png', point: 33, two_factor_auth: false},
  {name: 'iwoo1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'injun.woo30000@gmail.com', image_url: '/assets/iwoo1.png', point: 42, two_factor_auth: false},
  {name: 'jujeong1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'juhyeonjeong92@gmail.com', image_url: '/assets/jujeong1.png', point: 90, two_factor_auth: false},
  {name: 'iwoo2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'injun.woo30001@gmail.com', image_url: '/assets/iwoo2.png', point: 78, two_factor_auth: false},
  {name: 'yohlee2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'yohan9613@yonsei.ac.kr', image_url: '/assets/yohlee2.png', point: 83},
  {name: 'sanam2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'simian115@gmail.com', image_url: '/assets/sanam2.png', point: 92},
  {name: 'eunhkim2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'valhalla.host2@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 20},
  {name: 'jujeong2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'juhyeonjeong93@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 40},
  {name: 'test', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'juhyeonjeong94@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1@gmail.com', image_url: '/assets/yohlee1.png', point: 15},
  {name: 'test2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test2@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test3', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test3@gmail.com', image_url: '/assets/iwoo2.png', point: 13},
  {name: 'test4', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test4@gmail.com', image_url: '/assets/sanam2.png', point: 14},
  {name: 'test5', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test5@gmail.com', image_url: '/assets/kristy.png', point: 15},
  {name: 'test6', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test6@gmail.com', image_url: '/assets/jujeong1.png', point: 16},
  {name: 'test7', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7@gmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test8', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test8@gmail.com', image_url: '/assets/jujeong1.png', point: 18},
  {name: 'test9', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test9@gmail.com', image_url: '/assets/sanam2.png', point: 19},
  {name: 'test10', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test10@gmail.com', image_url: '/assets/yohlee1.png', point: 11},
  {name: 'test11', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test11@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test12', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test12@gmail.com', image_url: '/assets/jujeong1.png', point: 13},
  {name: 'test13', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test13@gmail.com', image_url: '/assets/iwoo2.png', point: 14},
  {name: 'test14', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test14@gmail.com', image_url: '/assets/kristy.png', point: 15},
  {name: 'test15', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test15@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test16', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test16@gmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test17', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test17@gmail.com', image_url: '/assets/kristy.png', point: 18},
  {name: 'test18', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test18@gmail.com', image_url: '/assets/iwoo2.png', point: 19},
  {name: 'test19', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test19@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 11},
  {name: 'test20', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test20@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test21', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test21@gmail.com', image_url: '/assets/kristy.png', point: 13},
  {name: 'test22', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tessdfjt4@gmail.com', image_url: '/assets/eunhkim1.png', point: 14},
  {name: 'test23', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tsdes1t5@gmail.com', image_url: '/assets/iwoo2.png', point: 15},
  {name: 'test24', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test126@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test25', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7zzzh@sdfgmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test26', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1238@gmail.com', image_url: '/assets/jujeong1.png', point: 18},
  {name: 'test27', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1239@gmail.com', image_url: '/assets/kristy.png', point: 19},
  {name: 'test28', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test28@gmail.com', image_url: '/assets/jujeong1.png', point: 11},
  {name: 'test29', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test29@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test30', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test30@gmail.com', image_url: '/assets/sanam1.png', point: 13},
  {name: 'test31', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test31@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test32', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test32@gmail.com', image_url: '/assets/eunhkim1.png', point: 15},
  {name: 'test33', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test33@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test34', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test34@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 17},
  {name: 'test35', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test35@gmail.com', image_url: '/assets/sanam1.png', point: 18},
  {name: 'test36', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test36@gmail.com', image_url: '/assets/kristy.png', point: 19},
  {name: 'test37', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test37@gmail.com', image_url: '/assets/sanam1.png', point: 11},
  {name: 'test38', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test38@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test39', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test39@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 13},
  {name: 'test40', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test40@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test41', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test41@gmail.com', image_url: '/assets/eunhkim1.png', point: 15},
  {name: 'test42', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test42@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test43', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test43@sdfgmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test44', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test44@gmail.com', image_url: '/assets/sanam1.png', point: 18},
  {name: 'test45', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test45@gmail.com', image_url: '/assets/kristy.png', point: 19},
  
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
  {owner_id: 1, name: "gun of 42seoul", anagram: "GUN", image_url: "assets/gun.png"},
  {owner_id: 2, name: "gon of 42seoul", anagram: "GON", image_url: "assets/gon.png"},
  {owner_id: 3, name: "gam of 42seoul", anagram: "GAM", image_url: "assets/gam.png"},
  {owner_id: 4, name: "lee of 42seoul", anagram: "LEE", image_url: "assets/lee.png"},
  {owner_id: 5, name: "1 of 42seoul", anagram: "1o4", image_url: "assets/lee.png"},
  {owner_id: 6, name: "2", anagram: "TWO", image_url: "assets/lee.png"},
  {owner_id: 7, name: "333333ul", anagram: "thee", image_url: "assets/lee.png"},
  {owner_id: 8, name: "121l2112ee of 42seoul", anagram: "121EE", image_url: "assets/lee.png"},
  {owner_id: 9, name: "seoul", anagram: "SEOUL", image_url: "assets/lee.png"},
  {owner_id: 10, name: "4444444444444", anagram: "@4", image_url: "assets/lee.png"},
  {owner_id: 11, name: "5 of 42seoul", anagram: "@5", image_url: "assets/lee.png"},
  # 긴 길드이름
  {owner_id: 12, name: "6 of 42sdsadaaaiodaseoul", anagram: "@6aa", image_url: "assets/lee.png"},
  # 5자 이상 anagram
  {owner_id: 13, name: "7 of 42seoul", anagram: "@61231231a", image_url: "assets/lee.png"},
  # owner_id 중복
  {owner_id: 1, name: "7 of 42seoul", anagram: "@7", image_url: "assets/lee.png"},
  # anagram 중복
  {owner_id: 13, name: "GUN", anagram: "@7", image_url: "assets/lee.png"},
  # name 중복
  {owner_id: 17, name: "gun of 42seoul", anagram: "@7", image_url: "assets/lee.png"},
])

WarRequest.create([
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,3,21,14), end_date: DateTime.new(2021,3,24,16), war_time: Time.new(1,1,1,10), max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 3, status: "pending"},
  {rule_id: 2, bet_point: 20, start_date: DateTime.new(2021,3,22,15), end_date: DateTime.new(2021,3,24,17), war_time: Time.new(1,1,1,1), max_no_reply_count: 5, include_ladder: false, include_tournament: true, target_match_score: 5, status: "approved"},
  {rule_id: 3, bet_point: 30, start_date: DateTime.new(2021,3,23,16), end_date: DateTime.new(2021,3,24,18), war_time: Time.new(1,1,1,12), max_no_reply_count: 1, include_ladder: true, include_tournament: false, target_match_score: 7, status: "approved"},
  {rule_id: 4, bet_point: 40, start_date: DateTime.new(2021,3,24,17), end_date: DateTime.new(2021,3,24,19), war_time: Time.new(1,1,1,19), max_no_reply_count: 3, include_ladder: true, include_tournament: true, target_match_score: 10, status: "approved"},
  {rule_id: 5, bet_point: 50, start_date: DateTime.new(2021,3,10,18), end_date: DateTime.new(2021,3,20,20), war_time: Time.new(1,1,1,10), max_no_reply_count: 60, include_ladder: false, include_tournament: false, target_match_score: 3, status: "approved"},
  {rule_id: 6, bet_point: 60, start_date: DateTime.new(2021,3,12,19), end_date: DateTime.new(2021,3,22,21), war_time: Time.new(1,1,1,12), max_no_reply_count: 20, include_ladder: true, include_tournament: true, target_match_score: 5, status: "approved"},
  {rule_id: 7, bet_point: 70, start_date: DateTime.new(2021,3,14,20), end_date: DateTime.new(2021,3,24,22), war_time: Time.new(1,1,1,10), max_no_reply_count: 2, include_ladder: true, include_tournament: true, target_match_score: 7, status: "canceled"},
  {rule_id: 1, bet_point: 80, start_date: DateTime.new(2021,3,16,10), end_date: DateTime.new(2021,3,16,20), war_time: Time.new(1,1,1,11), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 10, status: "canceled"},
  {rule_id: 2, bet_point: 80, start_date: DateTime.new(2021,3,16,12), end_date: DateTime.new(2021,3,16,14), war_time: Time.new(1,1,1,2), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 3, status: "canceled"},
  {rule_id: 3, bet_point: 80, start_date: DateTime.new(2021,3,16,14), end_date: DateTime.new(2021,3,16,22), war_time: Time.new(1,1,1,5), max_no_reply_count: 12, include_ladder: false, include_tournament: true, target_match_score: 5, status: "canceled"},
  {rule_id: 4, bet_point: 80, start_date: DateTime.new(2021,3,16,16), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,9), max_no_reply_count: 12, include_ladder: true, include_tournament: false, target_match_score: 7, status: "canceled"},
  {rule_id: 5, bet_point: 80, start_date: DateTime.new(2021,3,16,18), end_date: DateTime.new(2021,3,26,24), war_time: Time.new(1,1,1,10), max_no_reply_count: 12, include_ladder: false, include_tournament: true, target_match_score: 10, status: "canceled"},
  {rule_id: 6, bet_point: 10, start_date: DateTime.new(2021,3,16,20), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,11), max_no_reply_count: 12, include_ladder: true, include_tournament: false, target_match_score: 3, status: "pending"},
  {rule_id: 7, bet_point: 20, start_date: DateTime.new(2021,3,16,21), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,14), max_no_reply_count: 12, include_ladder: false, include_tournament: true, target_match_score: 5, status: "pending"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,4,14,21), end_date: DateTime.new(2021,4,26,23), war_time: Time.new(1,1,1,11), max_no_reply_count: 12, include_ladder: true, include_tournament: false, target_match_score: 3, status: "pending"},
  {rule_id: 2, bet_point: 20, start_date: DateTime.new(2021,4,15,21), end_date: DateTime.new(2021,4,26,23), war_time: Time.new(1,1,1,14), max_no_reply_count: 12, include_ladder: false, include_tournament: true, target_match_score: 5, status: "pending"},
  {rule_id: 3, bet_point: 10, start_date: DateTime.new(2021,4,16,21), end_date: DateTime.new(2021,4,26,23), war_time: Time.new(1,1,1,11), max_no_reply_count: 12, include_ladder: true, include_tournament: false, target_match_score: 3, status: "pending"},
  {rule_id: 4, bet_point: 20, start_date: DateTime.new(2021,4,17,21), end_date: DateTime.new(2021,4,26,23), war_time: Time.new(1,1,1,14), max_no_reply_count: 12, include_ladder: false, include_tournament: true, target_match_score: 5, status: "pending"},
  
  # 예외처리 확인용
  #  start_date, end_date가 지났거나 end_date가 start_date보다 빠를 때
  {rule_id: 1, bet_point: 30, start_date: DateTime.new(2021,1,14,21), end_date: DateTime.new(2021,1,24,23), war_time: Time.new(1,1,1,2), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 7, status: "pending"},
  {rule_id: 2, bet_point: 40, start_date: DateTime.new(2021,1,15,21), end_date: DateTime.new(2021,1,25,23), war_time: Time.new(1,1,1,9), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 10, status: "approved"},
  {rule_id: 3, bet_point: 50, start_date: DateTime.new(2021,1,16,21), end_date: DateTime.new(2021,1,26,23), war_time: Time.new(1,1,1,19), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 3, status: "canceled"},
  {rule_id: 3, bet_point: 50, start_date: DateTime.new(2021,2,17,19), end_date: DateTime.new(2021,1,26,23), war_time: Time.new(1,1,1,19), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 3, status: "pending"},
    
    #  없는 Rule Id
  {rule_id: 100, bet_point: 60, start_date: DateTime.new(2021,3,16,21), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,20), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 5, status: "pending"},

    #  이상한 Target Match Score
  {rule_id: 5, bet_point: 10, start_date: DateTime.new(2021,3,16,21), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,22), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 777, status: "pending"},

    #  status 이상한거
  {rule_id: 6, bet_point: 20, start_date: DateTime.new(2021,3,16,21), end_date: DateTime.new(2021,3,26,23), war_time: Time.new(1,1,1,4), max_no_reply_count: 12, include_ladder: false, include_tournament: false, target_match_score: 10, status: "seed is not defined"},
])

War.create([
  {war_request_id: 1},
  {war_request_id: 2},
  {war_request_id: 3},
  {war_request_id: 4},
  {war_request_id: 5},
  {war_request_id: 6},
])

Match.create([
  {rule_id: 6, status: "completed", match_type: "dual"},
  {rule_id: 1, status: "completed", match_type: "dual"},
  {rule_id: 2, status: "completed", match_type: "ladder"},
  {rule_id: 4, status: "completed", match_type: "ladder"},
  {rule_id: 1, status: "completed", eventable_type: "war", eventable_id: 1, match_type: "war"},
  {rule_id: 3, status: "completed", eventable_type: "war", eventable_id: 2, match_type: "war"},
  {rule_id: 5, status: "completed", eventable_type: "war", eventable_id: 3, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "war", eventable_id: 4, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "war", eventable_id: 5, match_type: "war"},
  {rule_id: 1, status: "completed", eventable_type: "tournament", eventable_id: 1, match_type: "tournament"},
  {rule_id: 1, status: "completed", eventable_type: "tournament", eventable_id: 2, match_type: "tournament"},
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
])

GroupChatRoom.create([
  {owner_id: 1, room_type: "public", title: "room 1", channel_code: "XXX-XXX-XX1", password: "123123"},
  {owner_id: 1, room_type: "public", title: "room 2", channel_code: "XXX-XXX-XX2" },
  {owner_id: 2, room_type: "public", title: "room 3", channel_code: "XXX-XXX-XX3", password: "123123"},
  {owner_id: 2, room_type: "public", title: "room 4", channel_code: "XXX-XXX-XX4" },
  {owner_id: 3, room_type: "public", title: "room 5", channel_code: "XXX-XXX-XX5", password: "123123"},
  {owner_id: 3, room_type: "public", title: "room 6", channel_code: "XXX-XXX-XX6" },

  {owner_id: 1, room_type: "private", title: "room 7", channel_code: "XXX-XXX-XX7", password: "123123"},
  {owner_id: 1, room_type: "private", title: "room 8", channel_code: "XXX-XXX-XX8" },
  {owner_id: 2, room_type: "private", title: "room 9", channel_code: "XXX-XXX-XX9", password: "123123"},
  {owner_id: 2, room_type: "private", title: "room 10", channel_code: "XXX-XXX-X10" },
  {owner_id: 3, room_type: "private", title: "room 11", channel_code: "XXX-XXX-X11", password: "123123"},
  {owner_id: 3, room_type: "private", title: "room 12", channel_code: "XXX-XXX-X12" },
])

GroupChatMembership.create([
  {user_id: 1, group_chat_room_id: 1, position: "owner"},
  {user_id: 1, group_chat_room_id: 2, position: "owner"},
  {user_id: 1, group_chat_room_id: 3, position: "admin"},
  {user_id: 1, group_chat_room_id: 4, position: "admin"},
  {user_id: 1, group_chat_room_id: 5, position: "member"},
  {user_id: 1, group_chat_room_id: 6, position: "member"},
  {user_id: 1, group_chat_room_id: 7, position: "owner"},
  {user_id: 1, group_chat_room_id: 8, position: "owner"},
  {user_id: 1, group_chat_room_id: 9, position: "admin"},
  {user_id: 1, group_chat_room_id: 10, position: "admin"},
  {user_id: 1, group_chat_room_id: 11, position: "member"},
  {user_id: 1, group_chat_room_id: 12, position: "member"},

  {user_id: 2, group_chat_room_id: 3, position: "owner"},
  {user_id: 2, group_chat_room_id: 4, position: "owner"},
  {user_id: 2, group_chat_room_id: 9, position: "owner"},
  {user_id: 2, group_chat_room_id: 10, position: "owner"},

  {user_id: 3, group_chat_room_id: 5, position: "owner"},
  {user_id: 3, group_chat_room_id: 6, position: "owner"},
  {user_id: 3, group_chat_room_id: 11, position: "owner"},
  {user_id: 3, group_chat_room_id: 12, position: "owner"},

  {user_id: 4, group_chat_room_id: 1, position: "member"},
  {user_id: 5, group_chat_room_id: 1, position: "member"},
  {user_id: 6, group_chat_room_id: 1, position: "member"},
  {user_id: 7, group_chat_room_id: 1, position: "member"},
  {user_id: 8, group_chat_room_id: 1, position: "member"},
  {user_id: 9, group_chat_room_id: 1, position: "member"},
  {user_id: 10, group_chat_room_id: 1, position: "member"},
  {user_id: 11, group_chat_room_id: 1, position: "member"},
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
  {user_id: 1, guild_id: 1, position: "owner"},
  {user_id: 2, guild_id: 2, position: "owner"},
  {user_id: 3, guild_id: 3, position: "owner"},
  
  {user_id: 4, guild_id: 4, position: "owner"},
  {user_id: 5, guild_id: 5, position: "owner"},
  {user_id: 6, guild_id: 6, position: "owner"},
  {user_id: 7, guild_id: 7, position: "owner"},
  {user_id: 8, guild_id: 8, position: "owner"},
  {user_id: 9, guild_id: 9, position: "owner"},
  {user_id: 10, guild_id: 10, position: "owner"},
  {user_id: 11, guild_id: 10, position: "owner"},

  {user_id: 12, guild_id: 1, position: "officer"},
  {user_id: 13, guild_id: 2, position: "officer"},
  {user_id: 14, guild_id: 3, position: "officer"},
  {user_id: 15, guild_id: 4, position: "officer"},
  {user_id: 16, guild_id: 5, position: "officer"},
  {user_id: 17, guild_id: 6, position: "officer"},
  {user_id: 18, guild_id: 7, position: "officer"},
  {user_id: 19, guild_id: 8, position: "officer"},
  {user_id: 20, guild_id: 9, position: "officer"},
  {user_id: 21, guild_id: 10, position: "officer"},
  {user_id: 22, guild_id: 11, position: "officer"},
  {user_id: 23, guild_id: 1, position: "officer"},

  # {user_id: 24, guild_id: 3, position: "member"},
  # {user_id: 25, guild_id: 3, position: "member"},
  # {user_id: 26, guild_id: 4, position: "member"},
  # {user_id: 27, guild_id: 5, position: "member"},
  # {user_id: 28, guild_id: 6, position: "member"},
  # {user_id: 29, guild_id: 10, position: "member"},
  # {user_id: 30, guild_id: 8, position: "member"},
  # {user_id: 31, guild_id: 8, position: "member"},
  # {user_id: 32, guild_id: 9, position: "member"},
  # {user_id: 33, guild_id: 11, position: "member"},

  {user_id: 34, guild_id: 10, position: "member"},
  {user_id: 35, guild_id: 3, position: "member"},
  {user_id: 36, guild_id: 7, position: "member"},
  {user_id: 37, guild_id: 6, position: "member"},
  {user_id: 38, guild_id: 3, position: "member"},
  {user_id: 39, guild_id: 5, position: "member"},
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
  {user_id: 55, guild_id: 2, position: "member"},
  {user_id: 56, guild_id: 1, position: "member"},
  
])

GuildInvitation.create([
  {user_id: 1, invited_user_id: 2, guild_id: 1},
  {user_id: 3, invited_user_id: 2, guild_id: 2},
  {user_id: 4, invited_user_id: 2, guild_id: 3},
  {user_id: 5, invited_user_id: 2, guild_id: 4},
  {user_id: 2, invited_user_id: 6, guild_id: 4},
  {user_id: 2, invited_user_id: 7, guild_id: 4},
  {user_id: 2, invited_user_id: 8, guild_id: 4},
  {user_id: 2, invited_user_id: 9, guild_id: 4},
])

Tournament.create([
  {rule_id: 1, title: "tototototo", start_date: DateTime.new(2021,1,14,8), tournament_time: Time.new},
  {rule_id: 1, title: "xoxoxoxoxo", start_date: DateTime.new(2021,1,14,8), tournament_time: Time.new},
])

TournamentMembership.create([
  {user_id: 1, tournament_id: 1},
  {user_id: 2, tournament_id: 1},
  {user_id: 3, tournament_id: 1},
  {user_id: 4, tournament_id: 1},
])

WarStatus.create([
  {guild_id: 1, war_request_id: 1, position: "challenger"},
  {guild_id: 2, war_request_id: 1, position: "enemy"},
  {guild_id: 1, war_request_id: 2, position: "challenger"},
  {guild_id: 3, war_request_id: 2, position: "enemy"},
  {guild_id: 1, war_request_id: 3, position: "challenger"},
  {guild_id: 4, war_request_id: 3, position: "enemy"},
  {guild_id: 2, war_request_id: 4, position: "challenger"},
  {guild_id: 3, war_request_id: 4, position: "enemy"},
  {guild_id: 2, war_request_id: 5, position: "challenger"},
  {guild_id: 4, war_request_id: 5, position: "enemy"},
  {guild_id: 3, war_request_id: 6, position: "challenger"},
  {guild_id: 1, war_request_id: 6, position: "enemy"},
  {guild_id: 3, war_request_id: 7, position: "challenger"},
  {guild_id: 2, war_request_id: 7, position: "enemy"},
  {guild_id: 3, war_request_id: 8, position: "challenger"},
  {guild_id: 4, war_request_id: 8, position: "enemy"},
  {guild_id: 4, war_request_id: 9, position: "challenger"},
  {guild_id: 1, war_request_id: 9, position: "enemy"},
  {guild_id: 4, war_request_id: 10, position: "challenger"},
  {guild_id: 2, war_request_id: 10, position: "enemy"},
  {guild_id: 4, war_request_id: 11, position: "challenger"},
  {guild_id: 3, war_request_id: 11, position: "enemy"},
  {guild_id: 1, war_request_id: 12, position: "challenger"},
  {guild_id: 3, war_request_id: 12, position: "enemy"},
  {guild_id: 1, war_request_id: 13, position: "challenger"},
  {guild_id: 4, war_request_id: 13, position: "enemy"},
  {guild_id: 2, war_request_id: 14, position: "challenger"},
  {guild_id: 1, war_request_id: 14, position: "enemy"},
  {guild_id: 2, war_request_id: 15, position: "challenger"},
  {guild_id: 3, war_request_id: 15, position: "enemy"},
  {guild_id: 2, war_request_id: 16, position: "challenger"},
  {guild_id: 4, war_request_id: 16, position: "enemy"},
  {guild_id: 2, war_request_id: 17, position: "challenger"},
  {guild_id: 3, war_request_id: 17, position: "enemy"},
  {guild_id: 1, war_request_id: 18, position: "challenger"},
  {guild_id: 3, war_request_id: 18, position: "enemy"},
  {guild_id: 4, war_request_id: 19, position: "challenger"},
  {guild_id: 3, war_request_id: 19, position: "enemy"},
  {guild_id: 4, war_request_id: 20, position: "challenger"},
  {guild_id: 2, war_request_id: 20, position: "enemy"},
  {guild_id: 3, war_request_id: 21, position: "challenger"},
  {guild_id: 2, war_request_id: 21, position: "enemy"},
  {guild_id: 4, war_request_id: 22, position: "challenger"},
  {guild_id: 1, war_request_id: 22, position: "enemy"},
  {guild_id: 2, war_request_id: 23, position: "challenger"},
  {guild_id: 3, war_request_id: 23, position: "enemy"},
  {guild_id: 1, war_request_id: 24, position: "challenger"},
  {guild_id: 2, war_request_id: 24, position: "enemy"},
  {guild_id: 1, war_request_id: 25, position: "challenger"},
  {guild_id: 3, war_request_id: 25, position: "enemy"},
])
