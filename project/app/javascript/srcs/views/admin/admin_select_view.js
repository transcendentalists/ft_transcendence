import { App } from "srcs/internal";

export let AdminSelectView = Backbone.View.extend({
  template: _.template($("#admin-select-view-template").html()),
  default_option: "<option value='default'>----------</option>",
  // ban, user
  // ban-release, user

  // destroy, chat-channel
  // show, chat-channel

  // give, chat-channel, membership, position
  // remove, chat-channel, membership, position

  // give, guild, membership, position
  // remove, guild, membership, position

  // create, tournament

  initialize: function (options) {
    this.parent = options.parent;
    this.db = null;
    this.type = options.type;
    this.field = this.parent.$(`.${this.type}.field`);
    this.select = this.parent.$(`select[name=${this.type}]`);
    this.resource = null;
    this.select.on("change", () => this.trigger("change", this.select.val()));
  },

  clear: function () {
    this.select.empty();
    this.field.removeClass("disabled");
  },

  disabled: function () {
    if (["group_chat_memberships", "guild_memberships"].includes(this.resource))
      return false;
    return !["action", "resource"].includes(this.type);
  },

  setDisable: function () {
    this.clear();
    this.select.append(this.default_option);
    this.field.addClass("disabled");
  },

  addOption: function (record) {
    this.select.append(this.template(record));
    if (this.type == "membership")
      console.log("🚀 ~ file: admin_select_view.js ~ line 48 ~ record", record);
  },

  renderOptions: function (relation) {
    if (!relation || relation.length == 0) return this.setDisable();
    this.clear();
    relation.forEach(this.addOption, this);
  },

  queryAndRenderOptions: function (resource_id) {
    if (this.disabled()) return this.setDisable();
    if (this.type == "membership" && !resource_id) return this.setDisable();

    let query = { type: this.type, resource: this.resource };
    if (this.type == "membership") query.resource_id = resource_id;
    let relation = this.db.where(query);
    this.renderOptions(relation);
  },

  render: function (resource) {
    if (!this.db) this.db = this.parent.db;
    this.resource = resource;
    this.queryAndRenderOptions();
    return this;
  },

  close: function () {
    this.select.off("change");
    this.remove();
  },
});
