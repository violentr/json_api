# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$(document).ready ->
  new List('clientsList',
    valueNames: ['name, lastName, primaryPhone, addressId, addressType'],
    page: 7,
    pagination: true)
