# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/   
$ ->
  $('[id^=status_tag_tokens_]').each (index, element) ->
    $(element).tokenInput '/tags.json',
      theme: 'facebook'
      hintText: 'הכנס מילה'
      noResultsText: 'לא נמצאו מילים'
      searchingText: 'מחפש...'
      preventDuplicates: true
      resultsLimit: 20
      propertyToSearch: 'text'
      queryParam: 'q_tokens'
      prePopulate: $(element).data('load')
          
    $('[id^=text_]').each (index, element) ->
      idRegex = /[0-9]+/
      status = idRegex.exec(element.id)
      element.onselect = ->
        startPos = element.selectionStart
        endPos = element.selectionEnd
        selectedText = element.value.substring(startPos, endPos)
        $('#marked_phrase_'+status).val(selectedText)
