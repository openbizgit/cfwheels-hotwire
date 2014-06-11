<cfoutput><!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<title>#get("appName")# : #includeContent("pageTitle")#</title>
			<meta name="description" content="">
			<meta name="author" content="">
			<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
			<!--[if lt IE 9]>
				<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
				<![endif]-->
			<!-- Le styles -->
			<link rel="stylesheet" href="/assets/font-awesome/css/font-awesome.min.css">
			<link rel="stylesheet" href="/assets/jquery/jquery-ui-1.10.4/themes/base/jquery-ui.css">
			<link rel="stylesheet" href="/assets/jquery/plugins/select2/select2.css" type="text/css" media="screen" />
			#styleSheetLinkTag("hotwire")#

			<script src="/assets/jquery/jquery-2.1.0.min.js"></script>
			<script src="/assets/jquery/jquery-ui-1.10.4/ui/jquery-ui.js"></script>
			<script src="/assets/jquery/plugins/select2/select2.min.js"></script>
			<script src="/assets/jquery/plugins/selectboxes/jquery.selectboxes.pack.js"></script>
			<script src="/assets/jquery/plugins/cfjs/jquery.cfjs.min.js"></script>
			#javascriptIncludeTag("hotwire")#
			#javascriptIncludeTag("rails")#

			<cfif StructKeyExists(variables, "HTMLHead")>#HTMLHead#</cfif>
			<script>
				$(window).load(function() {	
					<!--- hide success messages --->
					var hideSuccess = function() {
						$("##flash-message.alert-success").fadeOut();
					}
					setTimeout(hideSuccess,5000);
				});
			</script>
			<!--- javascript for smart search --->
			<cfif isPresent()>
				<script>
					$.widget( "custom.catcomplete", $.ui.autocomplete, {
						_renderMenu: function( ul, items ) {
							var self = this,
								currentCategory = "";
							$.each( items, function( index, item ) {
								if ( item.category != currentCategory ) {
									ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
									currentCategory = item.category;
								}
								self._renderItemData( ul, item );
							});
						}
					});
					
					$(function() {
						
						<!--- hide popovers on blur (actually onclick of body) --->
						$('body').on('click', function (e) {
						    $('[data-toggle="popover"]').each(function () {
						       <!--- the 'is' for buttons that trigger popups, the 'has' for icons within a button that triggers a popup --->
						        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
						            $(this).popover('hide');
						        }
						    });
						});

			         	<!--- ONLY shown to root users --->
			         	<!---
			         	<cfif Len(currentPerson.rootid) gt 0>						
							var data = "#urlFor(route='jointAjaxSmartSearch', params='format=json&r=#CreateUUID()#')#";
							
							var whenSelected = function(event, ui) {
								var controller = ui.item.category.toLowerCase() + 's';
								var action = 'show';
								var params = 'key=' + ui.item.id;
								if (ui.item.category == "Applications") {
									controller = 'agent.submissions';
								} else if (ui.item.category == "Maintenance Requests") {
									controller = 'agent.repairs';
								} else if (ui.item.category == "Listings") {
									controller = 'agent.listings';
								}
								self.location='#cgi.script_name#?controller=' + controller + '&action=' + action + '&' + params;
							}
							
							var whenClosed = function(event, ui) {
								$( "##search" ).val("");
							}
							
							$( "##search" ).catcomplete({
								delay: 1
								,source: data
								,select: whenSelected
								,close: whenClosed
							});
						</cfif>
						--->
					});
				</script>
			</cfif>			
			<!-- Le fav and touch icons -->
			<link rel="shortcut icon" href="images/favicon.html">
			<link rel="apple-touch-icon" href="images/apple-touch-icon.html">
			<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.html">
			<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.html">
			<cfif isPresent()><!-- [present:true] --></cfif>
		</head>
		<body>
			<!--- this is a partial as we may need different menus per namespace --->
			#includePartial("/partials/topbar")#
			#flashMessageTag()#
			<div class="container">
				<div class="row">
					#includeContent()#
				</div>
			</div>
			<hr>
			<footer><p align="center">&copy; #get("appName")# #Year(Now())#</p></footer>
			<script src="/assets/bootstrap/js/bootstrap.min.js"></script>
			#includePartial("/partials/appinfo")#
		</body>
	</html>
</cfoutput>