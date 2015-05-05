---
---

if $('#datatable').length
  $('#datatable').DataTable
    paging: false
    searching: false
    info: false

class ResponsiveLayout
  constructor: (@$dom)->
    do @eventBinding


  toggleActive: ($element)->
    active_type = $element.data('layout-switch')
    current_active = @$dom.attr('data-active')
    if current_active is active_type
      active_type = ''
    @$dom.attr('data-active', active_type)

  eventBinding: ->
    if @$dom.not('.res-single-column, .res-two-columns').length
      @$dom.on 'click touchend', '[data-layout-switch]', (e)=>
        $el = $(e.currentTarget)
        @toggleActive($el)

    if @$dom.not('.res-single-column').length
      $(document).on 'click touchend', ".res-layout[data-active='navigation'] *:not(.res-navigation)", (e)=>
        e.stopPropagation()
        $el = $(e.currentTarget)
        in_navigation = $el.closest('.res-navigation').length
        if $(e.currentTarget).is('[data-layout-switch]')
          return true
        else if !in_navigation
          @$dom.attr('data-active', '')

if $('.res-layout').length
  new ResponsiveLayout($('.res-layout'))

$('.section-datepicker').find('#datepicker').datepicker
  orientation: "auto"
$('.section-sortable').find('.sortable').sortable()
$('.select2-navigation').select2
  containerCssClass: 'select2-navigation'
  dropdownCssClass: 'select2-navigation'
  minimumResultsForSearch: -1

$('.section-select').find('select.select2-fusion').select2
  containerCssClass: 'select2-fusion'
  dropdownCssClass: 'select2-fusion'
  minimumResultsForSearch: -1

$('.section-select').find('select.select2-dropdown').select2
  containerCssClass: 'select2-dropdown'
  dropdownCssClass: 'select2-dropdown'
  minimumResultsForSearch: -1


$('.section-select').find('select.select2-simple').select2
  containerCssClass: 'select2-simple'
  dropdownCssClass: 'select2-simple'
  minimumResultsForSearch: -1

$('.section-lightbox')
  .on 'click', '.btn-lightbox', (e)->
    $('.section-lightbox').find('.carousel-generic').toggleClass('carousel-active', true)
  .on 'click touchstart', '.carousel-generic', (e)->
    $el = $(e.target)
    unless $el.parents('.carousel-generic').length
      $('.section-lightbox').find('.carousel-generic').toggleClass('carousel-active', false)



class SelectSwitcher
  constructor: ($dom)->
    @$dom = $dom
    @$select = @$dom.find('select')
    @$prev = @$dom.find('.prev')
    @$next = @$dom.find('.next')
    @eventBinding()
    @refreshState()

  refreshState: ->
    current_index = @getCurrentIndex()
    options_length = @getAllValues().length
    @$prev.removeClass('disabled')
    @$next.removeClass('disabled')
    if current_index is 0
      @$prev.addClass('disabled')
    else if (current_index + 1) is options_length
      @$next.addClass('disabled')

  getAllValues: ->
    @$select.find('option').map ->
      $option = $(@)
      $option.val()

  getCurrentIndex: ->
    allValues = @getAllValues()
    current_value = @$select.val()
    $.inArray(current_value, allValues)

  eventBinding: ->
    @$select.on 'change', =>
      @refreshState()

    @$dom.on 'click', '[data-switch]:not(".disabled")', (e)=>
      $el = $(e.currentTarget)
      direction = $el.data 'switch'
      new_index = 0
      allValues = @getAllValues()
      current_index = @getCurrentIndex()
      if (direction is 'prev')
        new_index = current_index - 1
      else if (direction is 'next')
        new_index = current_index + 1
      new_index = 0 if new_index is -1
      @$select.val(allValues[new_index]).trigger('change')
      @refreshState()

new SelectSwitcher($('.section-select').find('.select-switcher'))


# For settings layout
$('#settings-layout').on 'click', '.header-menu', (e)->
  $el = $(e.currentTarget)
  $el.toggleClass('open')
  $target = $($el.data('target'))
  is_open = $el.hasClass('open')
  $target.toggle(is_open)
