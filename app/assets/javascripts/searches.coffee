# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  politicians = $('#search_politician_id').html()
  $('#search_party_id').change ->
    party = $('#search_party_id :selected').text()
    escaped_party = party.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    if escaped_party
      options = $(politicians).filter("optgroup[label=#{escaped_party}]").html()
      if options
        $('#search_politician_id').html(options)
        $('#search_politician_id').prepend($("<option></option>").attr("value", ''))
      else
        $('#search_politician_id').html(politicians)    
    else
      $('#search_politician_id').html(politicians)
    return

  $('.datepicker-dropdown').fdatetimepicker
    language: 'he'
    'format': 'dd/mm/yyyy'
    'linkFormat': 'dd/mm/yyyy'
    'startView': 2
    'maxView': 2
    'minView': 2
