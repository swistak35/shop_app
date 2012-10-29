$(document).ready ()->
	$('#productsTab a').click (e)->
		e.preventDefault()
		$(this).tab 'show'
	
	$('#productsTab a:first').click()