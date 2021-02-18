# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {name: 'sanam1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'simian114@gmail.com', image_url: 'assets/sanam1.png', point: 123, two_factor_auth: false},
  {name: 'yohlee1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'yohan9612@naver.com', image_url: 'assets/yohlee1.png', point: 225, two_factor_auth: false},
  {name: 'eunhkim1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'valhalla.host@gmail.com', image_url: '/assets/eunhkim1.png', point: 3, two_factor_auth: false},
  {name: 'iwoo1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'injun.woo30000@gmail.com', image_url: '/assets/iwoo1.png', point: 4, two_factor_auth: false},
  {name: 'jujeong1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'juhyeonjeong92@gmail.com', image_url: '/assets/jujeong1.png', point: 523, two_factor_auth: false},
  {name: 'iwoo2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'injun.woo30001@gmail.com', image_url: '/assets/iwoo2.png', point: 7, two_factor_auth: false},
  {name: 'yohlee2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'yohan9613@yonsei.ac.kr', image_url: '/assets/yohlee2.png', point: 8},
  {name: 'sanam2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'simian115@gmail.com', image_url: '/assets/sanam2.png', point: 9},
  {name: 'eunhkim2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'valhalla.host2@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 10},
  {name: 'jujeong2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 10},
  {name: 'test', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tes@gmail.com', image_url: '/assets/kristy.png', point: 11},
  {name: 'test1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1@gmail.com', image_url: '/assets/kristy.png', point: 11},
  {name: 'test2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test2@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test3', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test3@gmail.com', image_url: '/assets/kristy.png', point: 13},
  {name: 'test4', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test4@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test5', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test5@gmail.com', image_url: '/assets/kristy.png', point: 15},
  {name: 'test6', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test6@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test7', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7@gmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test8', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test8@gmail.com', image_url: '/assets/kristy.png', point: 18},
  {name: 'test9', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test9@gmail.com', image_url: '/assets/kristy.png', point: 19},
  {name: 'test11', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test10@gmail.com', image_url: '/assets/kristy.png', point: 11},
  {name: 'test21', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test11@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test31', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test12@gmail.com', image_url: '/assets/kristy.png', point: 13},
  {name: 'test41', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test13@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test51', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test14@gmail.com', image_url: '/assets/kristy.png', point: 15},
  {name: 'test61', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test15@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test71', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test16@gmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test81', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test17@gmail.com', image_url: '/assets/kristy.png', point: 18},
  {name: 'test91', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test18@gmail.com', image_url: '/assets/kristy.png', point: 19},
  {name: 'test12', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test19@gmail.com', image_url: '/assets/kristy.png', point: 11},
  {name: 'test22', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test20@gmail.com', image_url: '/assets/kristy.png', point: 12},
  {name: 'test32', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test21@gmail.com', image_url: '/assets/kristy.png', point: 13},
  {name: 'test42', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tessdfjt4@gmail.com', image_url: '/assets/kristy.png', point: 14},
  {name: 'test52', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'tsdes1t5@gmail.com', image_url: '/assets/kristy.png', point: 15},
  {name: 'test62', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test126@gmail.com', image_url: '/assets/kristy.png', point: 16},
  {name: 'test72', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test7zzzh@sdfgmail.com', image_url: '/assets/kristy.png', point: 17},
  {name: 'test82', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1238@gmail.com', image_url: '/assets/kristy.png', point: 18},
  {name: 'test92', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'test1239@gmail.com', image_url: '/assets/kristy.png', point: 19},
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
])

WarRequest.create([
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "completed"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "completed"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "completed"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "completed"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "completed"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
])

War.create([
  {war_request_id: 1},
  {war_request_id: 2},
  {war_request_id: 3},
  {war_request_id: 4},
  {war_request_id: 5},
])

Match.create([
  {rule_id: 6, status: "completed", match_type: "Dual"},
  {rule_id: 1, status: "completed", match_type: "Dual"},
  {rule_id: 2, status: "completed", match_type: "Ladder"},
  {rule_id: 4, status: "completed", match_type: "Ladder"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 3, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 5, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 3, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 5, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "Tournament", eventable_id: 11, match_type: "Tournament"},
  {rule_id: 1, status: "completed", eventable_type: "Tournament", eventable_id: 12, match_type: "Tournament"},
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
  {user_id: 1, score: 4, result: "win", match_id: 15, side: "left"},
  {user_id: 1, score: 0, result: "win", match_id: 16, side: "left"},
  {user_id: 10, score: 0, result: "lose", match_id: 12, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 13, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 14, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 15, side: "right"},
  {user_id: 10, score: 0, result: "lose", match_id: 16, side: "right"},
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

  {user_id: 11, guild_id: 1, position: "member"},
  {user_id: 12, guild_id: 1, position: "member"},
  {user_id: 13, guild_id: 1, position: "member"},
  {user_id: 14, guild_id: 1, position: "member"},
  {user_id: 15, guild_id: 1, position: "member"},
  {user_id: 16, guild_id: 1, position: "member"},
  {user_id: 17, guild_id: 1, position: "member"},
  {user_id: 18, guild_id: 1, position: "member"},
  {user_id: 19, guild_id: 1, position: "member"},
  {user_id: 20, guild_id: 1, position: "member"},
  {user_id: 21, guild_id: 1, position: "member"},
  {user_id: 22, guild_id: 1, position: "member"},
  {user_id: 23, guild_id: 1, position: "member"},
  {user_id: 24, guild_id: 1, position: "member"},
  {user_id: 25, guild_id: 1, position: "member"},
  {user_id: 26, guild_id: 1, position: "member"},
  {user_id: 27, guild_id: 1, position: "member"},
  {user_id: 28, guild_id: 1, position: "member"},
  {user_id: 29, guild_id: 1, position: "member"},
  {user_id: 30, guild_id: 1, position: "member"},
  {user_id: 31, guild_id: 1, position: "member"},
  {user_id: 32, guild_id: 1, position: "member"},
  {user_id: 33, guild_id: 1, position: "member"},
  {user_id: 34, guild_id: 1, position: "member"},
  {user_id: 35, guild_id: 1, position: "member"},
  {user_id: 36, guild_id: 1, position: "member"},
  {user_id: 37, guild_id: 1, position: "member"},
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
  {guild_id: 2, war_request_id: 1, position: "challenger", point: 10},
  {guild_id: 1, war_request_id: 1, position: "enemy", point: 11},
  {guild_id: 3, war_request_id: 2, position: "challenger", point: 10},
  {guild_id: 1, war_request_id: 2, position: "enemy", point: 12},
  {guild_id: 4, war_request_id: 3, position: "challenger", point: 10},
  {guild_id: 1, war_request_id: 3, position: "enemy", point: 13},
  {guild_id: 1, war_request_id: 4, position: "challenger", point: 5},
  {guild_id: 2, war_request_id: 4, position: "enemy", point: 10},
  {guild_id: 1, war_request_id: 5, position: "challenger", point: 8},
  {guild_id: 3, war_request_id: 5, position: "enemy", point: 10},
  {guild_id: 4, war_request_id: 6, position: "challenger", point: 11},
  {guild_id: 2, war_request_id: 6, position: "enemy", point: 10},
  {guild_id: 4, war_request_id: 7, position: "challenger", point: 17},
  {guild_id: 3, war_request_id: 7, position: "enemy", point: 18},
  {guild_id: 2, war_request_id: 8, position: "challenger", point: 19},
  {guild_id: 3, war_request_id: 8, position: "enemy", point: 20},
])


