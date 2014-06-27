<cfoutput>
<!--- 
TODO: 
	- href URLs 
	- image alt tags
	- app name
	- logo image
	- facebook link
	- twitter link
	- footer text
 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.=
w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=U=TF-8">
	</head>
	<body>
		<table style="background-color:##F3F4F4;" bgcolor="##F3F4F4" width="100%" align="center" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<br>
					<table cellpadding="1" cellspacing="0" style="background-color: ##D9DADB;" align="center" bgcolor="##D9DADB">
						<tr>
							<td>
								<table style="font-family: arial, helvetica, sans-serif; font-size:14px; line-height:20px; background-color: ##ffffff; font-color:black;" align="center" bgcolor="##ffffff" cellspacing="0" cellpadding="0" width="600">
									<tr>
										<td width="30"></td>
										<td style="font-family: arial, helvetica, sans-serif; font-size:14px; line-height:20px;" width="540">
											<br>
											<table cellpadding="0" cellspacing="0" align="center"><tr><td><img src="http://#cgi.server_name#/images/VS_Forms_Logo_Grey.jpg" width="200"></td></tr></table>
											<br>
											#includeContent()#
											<br><br>
										</td>
										<td width="30"></td>
									</tr>
									<tr>
										<td colspan="3">
											<hr width="100%" color="##D9DADB" size="1px">
										</td>
									</tr>
									<!--- <tr>
										<td width="30"></td>
										<td align="right">
											<a href="http://www.facebook.com/"><img src="http://#cgi.server_name#/images/icon_fb.png" alt="Facebook"></a>&nbsp;&nbsp;
											<a href="http://www.twitter.com/"><img src="http://#cgi.server_name#/images/icon_tw.png" alt="Twitter"></a>
										</td>
										<td width="30"></td>
									</tr> --->
									<tr>
										<td width="30"></td>
										<td align="center">
											<p style="font-size:10px; color:##999; line-height:12px; margin-top:0px; text-align:center; font-family:Arial, Helvetica, sans-serif;" align="center">
												<!--- <br />
												We hope you enjoyed this message. If you'd rather not receive future emails from #get("appName")#
												<a style="color: ##787878; text-decoration: none;" href="">unsubscribe here</a>.
												<br />
												 --->
												<br />
												This message produced and distributed by #get("appName")#. #Year(Now())#.</p>
												<br />
										</td>
										<td width="30"></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<br>
				</td>
			</tr>
		</table>
	</body>
</html></cfoutput>