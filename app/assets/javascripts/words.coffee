# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ -> 
  $('#words_select').change ->
    selected_word = $('#words_select :selected').val()
    $('#word_id').val(selected_word)
    $('form').submit()
    $('#index_tab').addClass('active')
    $('#index_display').addClass('active')
    $('#context_tab').removeClass('active')
    $('#context_display').removeClass('active')

