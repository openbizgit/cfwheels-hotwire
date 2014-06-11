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
			<!-- Le fav and touch icons -->
			<link rel="shortcut icon" href="images/favicon.html">
			<link rel="apple-touch-icon" href="images/apple-touch-icon.html">
			<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.html">
			<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.html">
		</head>
		<body>
			<div class="container">
				<div class="row">
					#includeContent()#
				</div>
			</div>
			<hr>
			<footer><p align="center">&copy; #get("appName")# #Year(Now())#</p></footer>
			<script src="/assets/bootstrap/js/bootstrap.min.js"></script>
		</body>
	</html>
</cfoutput>