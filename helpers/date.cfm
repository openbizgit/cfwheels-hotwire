<cffunction name="parseDate" output="false">
	<cfargument name="date" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.return = "">
	<cfset loc.a = ListToArray(arguments.date, "/")>
	<cfif ArrayLen(loc.a) eq 3>
		<cfset loc.return = createDate(loc.a[3], loc.a[2], loc.a[1])>
	</cfif>
	<cfreturn loc.return />
</cffunction>

<cffunction name="parseDateString" output="false">
	<cfargument name="date" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.return = "">
	<!--- dd/mm/yyyy --->
	<cfset loc.a = ListToArray(arguments.date, "/")>
	<cfif ArrayLen(loc.a) eq 3>
		<cfset loc.return = CreateDate(loc.a[3], loc.a[2], loc.a[1])>
	</cfif>
	<cfreturn loc.return />
</cffunction>

<cffunction name="parseDateTimeString" output="false">
	<cfargument name="date" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.return = "">
	<!--- dd/mm/yyyy hh:mmtt OR dd/mm/yyyy hh:mm tt --->
	<cfset loc.d = ListToArray(ListFirst(arguments.date," "), "/")>
	<cfset loc.t = ListRest(arguments.date," ")>
	<cfset loc.h = ListFirst(loc.t,":")>
	<cfset loc.m = Left(ListGetAt(loc.t,2,": "), 2)>
	<cfset loc.ampm = Right(loc.t, 2)>
	<cfif loc.ampm is "PM" AND loc.h LT 12>
		<cfset loc.h = loc.h + 12>
	</cfif>
	<cfset loc.return = CreateDateTime(loc.d[3], loc.d[2], loc.d[1], loc.h, loc.m, 0)>
	<cfreturn loc.return />
</cffunction>

<cffunction name="formatDate" access="public" output="false" returntype="string" hint="formats a date for display">
	<cfargument name="date" type="date" required="true">
	<cfargument name="showTime" type="boolean" required="false" default="false">
	<cfset var loc = {} />
	<cfset loc.th = "th">
	<cfset loc.day = Day(arguments.date)>
	<cfif ListFind("1,21,31", loc.day) gt 0>
		<cfset loc.th = "st">
	<cfelseif ListFind("2,22", loc.day) gt 0>
		<cfset loc.th = "nd">
	<cfelseif ListFind("3,23", loc.day) gt 0>
		<cfset loc.th = "rd">
	</cfif>
	<cfset loc.return = DateFormat(arguments.date, "ddd, d") & loc.th & DateFormat(arguments.date, " mmm yyyy")>
	<cfif arguments.showTime>
		<cfset loc.return = ListAppend(loc.return, UCase(TimeFormat(arguments.date, "h:mmtt")), " ")>
	</cfif>
	<cfreturn loc.return>
</cffunction>

<cffunction name="formatTime" access="public" output="false" returntype="string" hint="formats a time for display">
	<cfargument name="date" type="date" required="true">
	<cfreturn UCase(TimeFormat(arguments.date, "h:mmtt"))>
</cffunction>

<cffunction name="formatDateTime" access="public" output="false" returntype="string" hint="formats a date & time for display">
	<cfargument name="date" type="date" required="true">
	<cfreturn formatDate(arguments.date) & " " & formatTime(arguments.date)>
</cffunction>

<cffunction name="humaniseDate" access="package" output="false">
	<cfargument name="string" required="true" type="string" />
	<cfreturn Left(arguments.string,1) IS "{" AND Right(arguments.string,1) IS "}" ? DateFormat(arguments.string,"dd/mm/yyyy") : "">
</cffunction>

<cffunction name="startOfDay" access="public" output="false" returntype="string" hint="returns midnight (morning) for a give date">
	<cfargument name="date" type="date" required="true">
	<cfreturn CreateDateTime(Year(arguments.date), Month(arguments.date), Day(arguments.date), 0, 0, 0)>
</cffunction>

<cffunction name="endOfDay" access="public" output="false" returntype="string" hint="returns midnight (night) for a give date">
	<cfargument name="date" type="date" required="true">
	<cfreturn DateAdd("s", 86399, startOfDay(arguments.date))>
</cffunction>

<cffunction name="UTCToLocal" access="public" output="false" returntype="date" hint="converts server time (UTC) to user's local time">
	<cfargument name="date" type="date" required="true">
	<cfargument name="utcoffset" type="numeric" required="false" default="#currentPerson.utcoffset#">
	<cfreturn DateAdd("n", arguments.utcoffset, arguments.date)>
</cffunction>