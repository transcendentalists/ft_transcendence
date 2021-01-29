// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import * as semantic from "./semantic-min";
import "channels";
import { app } from "./app";

Rails.start();
ActiveStorage.start();

console.log("HELLO");
console.log(app);
console.log("sadad");

def helper