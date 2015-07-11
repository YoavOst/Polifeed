# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    $('#cliques').change ->
      $("#notice").empty()
      $('#notice').removeClass("alert-box success");
      selected_clique = $('#cliques :selected').val()
      $('#clique_id').val(selected_clique)
      $('#temp_id').submit()
      
