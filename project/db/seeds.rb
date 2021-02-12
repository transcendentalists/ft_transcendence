# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {name: 'sanam1', password: '123123', email: 'simian114@gmail.com', image_url: 'assets/sanam1.png', point: 1, two_factor_auth: false},
  {name: 'yohlee1', password: '123123', email: 'yohan9612@naver.com', image_url: 'assets/yohlee1.png', point: 2, two_factor_auth: false},
  {name: 'eunhkim1', password: '123123', email: 'valhalla.host@gmail.com', image_url: '/assets/eunhkim1.png', point: 3, two_factor_auth: false},
  {name: 'iwoo1', password: '123123', email: 'injun.woo30000@gmail.com', image_url: '/assets/iwoo1.png', point: 4, two_factor_auth: false},
  {name: 'jujeong', password: '123123', email: 'juhyeonjeong92@gmail.com', image_url: '/assets/jujeong1.png', point: 5, two_factor_auth: false},
  {name: 'iwoo2', password: '123123',  email: 'injun.woo30000@gmail.com', image_url: '/assets/iwoo2.png', point: 7, two_factor_auth: false},
  {name: 'yohlee2', password: '123123',  email: 'yohan9612@yonsei.ac.kr', image_url: '/assets/yohlee2.png', point: 8},
  {name: 'sanam2', password: '123123',  email: 'simian114@gmail.com', image_url: '/assets/sanam2.png', point: 9},
  {name: 'eunhkim2', password: '123123',  email: 'valhalla.host@gmail.com', image_url: '/assets/eunhkim2.jpg', point: 10},
  {name: 'test', password: '123123',  email: 'juhyeonjeong92@gmail.com', image_url: '/assets/kristy.png', point: 11},
])

Friendship.create([
  {user_id: 1, friend_id: 2},
  {user_id: 1, friend_id: 3},
  {user_id: 1, friend_id: 4},
  {user_id: 1, friend_id: 10},
  {user_id: 2, friend_id: 3},
  {user_id: 2, friend_id: 4},
  {user_id: 4, friend_id: 6},
  {user_id: 4, friend_id: 1},
  {user_id: 6, friend_id: 1},
  {user_id: 10, friend_id: 1},
  {user_id: 10, friend_id: 2},
  {user_id: 10, friend_id: 3},
  {user_id: 10, friend_id: 4},
  {user_id: 10, friend_id: 5},
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
  {owner_id: 1, name: "guild", anagram: "GUILD", },
  {owner_id: 2, name: "sososo", anagram: "SOSOS", },
  {owner_id: 3, name: "xoxoxo", anagram: "XOXOX", },
])

WarRequest.create([
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
  {rule_id: 1, bet_point: 10, start_date: DateTime.new(2021,1,14,8), end_date: DateTime.new(2021,1,24,8), war_time: Time.new, max_no_reply_count: 10, include_ladder: true, include_tournament: true, target_match_score: 10, status: "pending"},
])

War.create([
  {war_request_id: 1},
  {war_request_id: 2},
])

Match.create([
  {rule_id: 1, eventable_type: "War", eventable_id: 1, match_type: "War"},
  {rule_id: 1, eventable_type: "War", eventable_id: 1, match_type: "War"},
])

GroupChatRoom.create([
  {owner_id: 1, room_type: "public", title: "Welcome", channel_code: "XXX-XXX-XXX" },
  {owner_id: 2, room_type: "protected", title: "Welcome", channel_code: "ABC-XXX-XXX", password: "123123" }
])

DirectChatRoom.create([
  t.bigint "user_id", null: false
  t.bigint "direct_chat_room_id", null: false
])

DirectChatMembership.create([
  {user_id: 1, room_id: "public", title: "Welcome", channel_code: "XXX-XXX-XXX" },
  {user_id: 1, room_id: "public", title: "Welcome", channel_code: "XXX-XXX-XXX" },
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

GroupChatMembership.create([
  {user_id: 1, group_chat_room_id: 1, position: "owner"},
  {user_id: 2, group_chat_room_id: 1},
  {user_id: 3, group_chat_room_id: 1},
  {user_id: 4, group_chat_room_id: 1},
  {user_id: 5, group_chat_room_id: 1},
  {user_id: 6, group_chat_room_id: 1},
])

GuildMembership.create([
  {user_id: 1, guild_id: 1, position: "owner"},
  {user_id: 2, guild_id: 2, position: "owner"},
  {user_id: 3, guild_id: 3, position: "owner"},
])

Scorecard.create([
  {user_id: 1, match_id: 1, side: "left"},
  {user_id: 2, match_id: 1, side: "right"},
  {user_id: 3, match_id: 2, side: "left"},
  {user_id: 4, match_id: 2, side: "right"},
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


