<!--- javascript for search/autocomplete this has been moved to _htmlOpen (ch_head issue) --->
<cfoutput>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <cfif isPresent()>
        	#linkTo(route="jointDetourDashboard", class="navbar-brand", style="padding: 0px; margin-right:20px;", text='<img src="/images/logo.png" height="50">')#
	        <div class="collapse navbar-collapse">
	         	<ul class="nav navbar-nav navbar-right">
	         		<cfif get("stage") eq "development">
				    	<li class="dropdown">
							<a href="##" class="dropdown-toggle" data-toggle="dropdown">Dev Tools <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li>#linkTo(href="/index.cfm?controller=wheels&action=wheels&view=packages&type=app", text="App Tests", noroute=true)#</li>
								<li>#linkTo(href="/index.cfm?controller=wheels&action=wheels&view=plugins&name=dbmigrate", text="DB Migrate Plugin", noroute=true)#</li>
								<li>#linkTo(params="debug=#get("showDebugInformation") ? 'false' : 'true'#&reload=true", text="Turn Debug #get("showDebugInformation") ? 'Off' : 'On'#", noroute=true)#</li>
								<li class="divider"></li>
								<li class="disabled"><a tabindex="-1" href="##"><strong>Data Scripts</strong></a></li>
								<li>#linkTo(route="seedSeedIndex", type="developer", text="Developer Data Script", confirm="Are you sure?", params="RequestTimeout=240")#</li>
								<li>#linkTo(route="seedSeedIndex", type="ci", text="CI Data Script", confirm="Are you sure?", params="RequestTimeout=240")#</li>
							</ul>
						</li>
				    </cfif>
	         		<li><p class="navbar-text">Hi #currentPerson.firstName#</p></li>
					<li class="dropdown">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-cog"></span></a>
						<ul class="dropdown-menu">
							<li>#linkTo(route="jointMeRoot", key=currentPerson.key(), text="Security")#</li>
							<cfif Len(currentPerson.userid) gt 0>
								
							<cfelseif Len(currentPerson.administratorid) gt 0>
								
							<cfelseif Len(currentPerson.rootid) gt 0>
								
							</cfif>
							<li>#linkTo(route="signout", text="Log out", params="clear=true")#</li>
						</ul>
					</li>
	        	</ul>
	         	<!--- ONLY shown to root users --->
	         	<cfif Len(currentPerson.rootid) gt 0>
			    	<form class="navbar-form">
			        	<div class="form-group">
			          		<input type="text" placeholder="Search" class="form-control" id="search">
			        	</div>
			        </form>         		
			    </cfif>
	        </div><!--/.nav-collapse -->
	    <cfelse>
	       	<a class="navbar-brand" href="/signin">#get('Appname')#</a>
	    </cfif>
      </div>
    </div>

</cfoutput>