/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "babel-polyfill"
import "nodelist-foreach-polyfill"

import 'comments'
import 'file_select'
import 'make_sortable'
import 'polls'
import 'sign_up'

$(document).on('turbolinks:load', function() {
  addElement('hello from es6');
  Array.from(['hello', 'world', 'hello from 2015']).forEach(el =>addElement(el));
   });

function addElement (text) {
  // create a new div element
  // and give it some content
  var newDiv = document.createElement("div");
  var newContent = document.createTextNode(text);
  newDiv.appendChild(newContent); //add the text node to the newly created div.

  // add the newly created element and its content into the DOM
  //var currentDiv = document.getElementById("div1");
  document.body.appendChild(newDiv);
}