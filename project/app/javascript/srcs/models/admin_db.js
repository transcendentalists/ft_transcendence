import { App, Helper } from "srcs/internal";

export let AdminDB = Backbone.Model.extend({
  url: "/api/admin/db",

  where: function (query_hash) {
    switch (query_hash.type) {
      case "action":
        return this.action(query_hash);
      case "resource":
        return this.resource(query_hash);
      case "membership":
        return this.membership(query_hash);
      case "position":
        return this.position(query_hash);
    }
  },

  destroy: function (query_hash) {
    let resource = this.get(query_hash.resource);
    let index = resource.findIndex(
      (record) => record.id == query_hash.resource_id
    );
    if (index != -1) resource.splice(index, 1);
  },

  action: function (query_hash) {
    let data = {
      users: [
        ["PATCH", "유저 권한 변경하기"],
        ["DELETE", "유저 접속 금지하기"],
      ],
      group_chat_rooms: [
        ["GET", "그룹 챗 대화내역 보기"],
        ["DELETE", "그룹 챗 채널 삭제하기"],
      ],
      group_chat_memberships: [
        ["PATCH", "그룹 챗 멤버십 변경하기"],
        ["DELETE", "그룹 챗 멤버 제명하기"],
      ],
      guild_memberships: [
        ["PATCH", "길드 멤버십 변경하기"],
        ["DELETE", "길드 멤버 제명하기"],
      ],
    };

    data = data[query_hash.resource] || [];

    return data.map(function (action) {
      return { value: action[0], text: action[1] };
    });
  },

  resourceText: function (resource) {
    if (resource.hasOwnProperty("title"))
      return `${resource.title}(${resource.channel_code})`;
    else return resource.name;
  },

  resource: function (query_hash) {
    const resource_name_hash = {
      users: "users",
      group_chat_rooms: "group_chat_rooms",
      group_chat_memberships: "group_chat_rooms",
      guild_memberships: "guilds",
    };

    let resource_name = resource_name_hash[query_hash.resource];
    let data = this.get(resource_name) || [];

    return data.map(function (resource) {
      return { value: resource.id, text: this.resourceText(resource) };
    }, this);
  },

  membership: function (query_hash) {
    let data = this.get(query_hash.resource) || [];
    let resource_id = query_hash.resource_id;
    if (isNaN(resource_id)) return [];

    if (query_hash.resource == "guild_memberships")
      data = _.filter(data, (membership) => resource_id == membership.guild_id);
    else if (query_hash.resource == "group_chat_memberships")
      data = _.filter(
        data,
        (membership) => resource_id == membership.group_chat_room_id
      );
    return data.map(function (membership) {
      return { value: membership.id, text: membership.name };
    });
  },

  position: function (query_hash) {
    let data = [];
    if (query_hash.resource == "guild_memberships")
      data = this.get("guild_positions") || [];
    else if (query_hash.resource == "group_chat_memberships")
      data = this.get("group_chat_positions") || [];

    return data.map(function (position) {
      return { value: position, text: position };
    });
  },
});
