class FirstSpa
	constructor: ->
		main_div = $("div#main")
		name = prompt("What's your name?")
		source = $("#template-main").html()
		template = Handlebars.compile(source)
		data = {
			name: name
		}
		main_div.html(template(data))

$(document).ready ()->
	new FirstSpa()