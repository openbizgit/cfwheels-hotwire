<cfoutput><!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<title>#get("appName")# : Data</title>
			<link rel="stylesheet" href="/assets/bootstrap/css/bootstrap.min.css">
		</head>
		<body>
			<div class="container">
				#pageTitle("Pimp my Data")#
				#errorMessageTag()#
				<div class="row">
					<div class="span12">
						#linkTo(text="Home", controller="router", noroute=true, class="btn btn-default", style="margin-bottom:10px;")#<br/>
						#linkTo(text="Developer Data", action="developer", noroute=true, style="margin-bottom:10px;", class="btn btn-default")#<br/>
						#linkTo(text="Jenkins Data", action="jenkins", noroute=true, style="margin-bottom:10px;", class="btn btn-default")#<br/>
					</div>
				</div>
			</div>
			<script src="/assets/bootstrap/js/bootstrap.min.js"></script>
		</body>
	</html>
</cfoutput>