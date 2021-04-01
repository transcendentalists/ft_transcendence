export let AdminSelectView = Backbone.View.extend({
  template: _.template($("#admin-select-view-template").html()),
  default_option: "<option value='default'>----------</option>",

  initialize: function (options) {
    this.parent = options.parent;
    this.db = null;
    this.type = options.type;
    this.field = this.parent.$(`.${this.type}.field`);
    this.select = this.parent.$(`select[name=${this.type}]`);
    this.resource = null;
    this.select.on("change", () => this.trigger("change", this.select.val()));
  },

  render: function (resource) {
    this.resource = resource;
    if (this.disabled()) return this.setDisable();

    let query = { type: this.type, resource: this.resource };
    if (this.type == "membership")
      query.resource_id = this.parent.child_selects.resource.val();
    let relation = this.db.where(query);
    this.renderOptions(relation);

    return this;
  },

  disabled: function () {
    switch (this.type) {
      case "action":
      case "resource":
        return false;
      case "membership":
        return !["group_chat_memberships", "guild_memberships"].includes(
          this.resource
        );
      case "position":
        return this.parent.requestMethod() != "PATCH";
    }
  },

  setDisable: function () {
    this.clear();
    this.select.append(this.default_option);
    this.field.addClass("disabled");
  },

  renderOptions: function (relation) {
    if (!relation || relation.length == 0) return this.setDisable();
    this.clear();
    relation.forEach(this.addOption, this);
  },

  clear: function () {
    this.select.empty();
    this.field.removeClass("disabled");
  },

  addOption: function (record) {
    this.select.append(this.template(record));
  },

  setDB: function (db) {
    this.db = db;
  },

  val: function () {
    return this.select.val();
  },

  close: function () {
    this.select.off("change");
    this.remove();
  },
});
