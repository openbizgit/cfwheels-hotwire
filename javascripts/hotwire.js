$(window).load(function() {	
	/* enable all select2 dropdowns */
	$("select.select2").select2();
	/* implement an 'btn-add' button class */
	$("a.btn-add").each(function() {
		$(this).addClass("btn-warning").html('<i class="glyphicon glyphicon-plus icon-white"></i> ' + $(this).html());	
	});
	$("button.btn-add").each(function() {
		$(this).addClass("btn-warning").html('<i class="glyphicon glyphicon-plus icon-white"></i> ' + $(this).html());	
	});

	/* to prevent submit button from double clicking (http://greatwebguy.com/programming/dom/prevent-double-submit-with-jquery/)  */
	$('form').submit(function(){
	    $(':submit', this).click(function() {
	        return false;
	    });
	});
});

<!--- used for rounding to 2 decimal points --->
var mathRoundConst = 100;

function formatMoney(money) {
	return parseFloat(Math.round(money*mathRoundConst)/mathRoundConst).toFixed(2);
}