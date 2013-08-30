# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  credit_card.setupForm()

credit_card = 
  setupForm: ->
    $('#new_credit_card').on 'click', ->
        card_form = $('#add_credit_card')
        $('input[type=submit]').attr('disabled', true)
        Stripe.createToken(card_form, credit_card.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    alert response.id
    $('#add_credit_card').append("<input type='hidden' name='stripe_token' value='" + response.id + "'/>")
    $('input[type=submit]').attr('disabled', false)
    # TODO: this form submit needs to create a credit card, but asynchronously
    # What is the best way to pull this off? 
    $('#add_credit_card')[0].submit()


