$(document).ready(function() {
	$('#productsTab a').click(function (e) {
		e.preventDefault();
		$(this).tab('show');
	});

	$('#productsTab a:first').click();
});