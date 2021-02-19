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


