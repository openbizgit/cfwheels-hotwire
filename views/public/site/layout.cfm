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
			#styleSheetLinkTag("hotwire")#
			#javascriptIncludeTag("hotwire")#
			<cfif StructKeyExists(variables, "HTMLHead")>#HTMLHead#</cfif>
			<!-- Le fav and touch icons -->
			<link rel="shortcut icon" href="images/favicon.html">
			<link rel="apple-touch-icon" href="images/apple-touch-icon.html">
			<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.html">
			<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.html">
		</head>
		<body>
			<div align="center">
				#imageTag(source="logo.png")#
				<h1>#get('appName')#</h1>
				<h3 class="text-muted">A baseplate for Coldfusion on Wheels applications</h3>
			</div>
			<div class="container">
				<div class="row">
					<div class="col-lg-3 col-lg-offset-2">
						#includeContent()#
					</div>
					<div class="col-lg-5">
						#includePartial("/partials/appinfo")#
					</div>
				</div>
			</div>
			<hr>
			<footer><p align="center">&copy; #get("appName")# #Year(Now())#</p></footer>
			<script src="/assets/bootstrap/js/bootstrap.min.js"></script>
		</body>
	</html>
</cfoutput>