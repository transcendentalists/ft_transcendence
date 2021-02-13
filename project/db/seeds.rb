# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {name: 'sanam1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'simian114@gmail.com', image_url: 'assets/sanam1.png', point: 1, two_factor_auth: false},
  {name: 'yohlee1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'yohan9612@naver.com', image_url: 'assets/yohlee1.png', point: 2, two_factor_auth: false},
  {name: 'eunhkim1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'valhalla.host@gmail.com', image_url: '/assets/eunhkim1.png', point: 3, two_factor_auth: false},
  {name: 'iwoo1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'injun.woo30000@gmail.com', image_url: '/assets/iwoo1.png', point: 4, two_factor_auth: false},
  {name: 'jujeong1', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO", email: 'juhyeonjeong92@gmail.com', image_url: '/assets/jujeong1.png', point: 5, two_factor_auth: false},
  {name: 'iwoo2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'injun.woo30001@gmail.com', image_url: '/assets/iwoo2.png', point: 7, two_factor_auth: false},
  {name: 'yohlee2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'yohan9613@yonsei.ac.kr', image_url: '/assets/yohlee2.png', point: 8},
  {name: 'sanam2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'simian115@gmail.com', image_url: '/assets/sanam2.png', point: 9},
  {name: 'eunhkim2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'valhalla.host2@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 10},
  {name: 'jujeong2', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'juhyeonjeong93@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 10},
  {name: 'test', password: "$2a$12$x9NXHNv4GY/11FVhqjmT/ObkTmund.GigvaOWR8QLCGlFQVTLkeWO",  email: 'juhyeonjeong94@gmail.com', image_url: '/assets/kristy.png', point: 11},
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
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
])

War.create([
  {war_request_id: 1},
  {war_request_id: 2},
])

Match.create([
  {rule_id: 6, status: "completed", match_type: "Dual"},
  {rule_id: 1, status: "completed", match_type: "Dual"},
  {rule_id: 2, status: "completed", match_type: "Ladder"},
  {rule_id: 4, status: "completed", match_type: "Ladder"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 3, status: "completed", eventable_type: "War", eventable_id: 2, match_type: "War"},
  {rule_id: 5, status: "completed", eventable_type: "War", eventable_id: 3, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 4, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "War", eventable_id: 5, match_type: "War"},
  {rule_id: 1, status: "completed", eventable_type: "Tournament", eventable_id: 1, match_type: "Tournament"},
  {rule_id: 1, status: "completed", eventable_type: "Tournament", eventable_id: 1, match_type: "Tournament"},
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
  {owner_id: 1, room_type: "public", title: "public locked owner", channel_code: "XXX-XXX-XX1", password: "123123"},
  {owner_id: 1, room_type: "public", title: "public unlocked owner", channel_code: "XXX-XXX-XX2" },
  {owner_id: 2, room_type: "public", title: "public locked admin", channel_code: "XXX-XXX-XX3", password: "123123"},
  {owner_id: 2, room_type: "public", title: "public unlocked admin", channel_code: "XXX-XXX-XX4" },
  {owner_id: 3, room_type: "public", title: "public locked member", channel_code: "XXX-XXX-XX5", password: "123123"},
  {owner_id: 3, room_type: "public", title: "public unlocked member", channel_code: "XXX-XXX-XX6" },
  
  {owner_id: 1, room_type: "private", title: "private locked owner", channel_code: "XXX-XXX-XX7", password: "123123"},
  {owner_id: 1, room_type: "private", title: "private unlocked owner", channel_code: "XXX-XXX-XX8" },
  {owner_id: 2, room_type: "private", title: "private locked admin", channel_code: "XXX-XXX-XX9", password: "123123"},
  {owner_id: 2, room_type: "private", title: "private unlocked admin", channel_code: "XXX-XXX-X10" },
  {owner_id: 3, room_type: "private", title: "private locked member", channel_code: "XXX-XXX-X11", password: "123123"},
  {owner_id: 3, room_type: "private", title: "private unlocked member", channel_code: "XXX-XXX-X12" },
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
  {},
  {},
])

ChatMessage.create([
  {user_id: 1, room_type: "DirectChatRoom", room_id: 1, message: "Helloooo"},
  {user_id: 2, room_type: "DirectChatRoom", room_id: 1, message: "testtest"},
  {user_id: 3, room_type: "DirectChatRoom", room_id: 2, message: "gooooood"},
  {user_id: 4, room_type: "DirectChatRoom", room_id: 2, message: "11111111"},
  {user_id: 4, room_type: "DirectChatRoom", room_id: 2, message: "22222222"},
  {user_id: 1, room_type: "GroupChatRoom", room_id: 1, message: "1"},
  {user_id: 2, room_type: "GroupChatRoom", room_id: 1, message: "2"},
  {user_id: 3, room_type: "GroupChatRoom", room_id: 1, message: "3"},
  {user_id: 4, room_type: "GroupChatRoom", room_id: 1, message: "4"},
  {user_id: 5, room_type: "GroupChatRoom", room_id: 1, message: "5"},
  {user_id: 6, room_type: "GroupChatRoom", room_id: 1, message: "6"},
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
])


