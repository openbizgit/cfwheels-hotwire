<cffunction name="addressFormat" access="public" output="false" returntype="string" hint="formats a street address for display">
	<cfargument name="struct" type="struct" required="true">
	<cfset var loc = {} />
	<cfset loc.s = arguments.struct>
	<cfset loc.s.streetNumber = Len(loc.s.subNumber) gt 0 ? ListPrepend(loc.s.streetNumber, loc.s.subNumber, "/") : loc.s.streetNumber>
	<cfset loc.return = loc.s.streetName>
	<cfset loc.return = ListPrepend(loc.return, loc.s.streetNumber, " ")>
	<cfif IsDefined("loc.s.suburb")>
		<cfset loc.return = loc.return & ", " & loc.s.suburb.suburbname>		
		<cfset loc.return = ListAppend(loc.return, loc.s.suburb.postcode, " ")>
	<cfelse>
		<cfset loc.return = loc.return & ", " & loc.s.suburbname>		
		<cfset loc.return = ListAppend(loc.return, loc.s.postcode, " ")>		
	</cfif>
	<!--- <cfset loc.return = ListAppend(loc.return, loc.s.state, " ")> --->
	<cfreturn loc.return />
</cffunction>

<cffunction name="shortURL" returntype="string" access="public">
	<cfargument name="string" required="true" type="string">
	<cfset var loc = {}>
	<cfset loc.return = arguments.string>
	<cfset loc.return = ReplaceNoCase(loc.return, "http://", "", "one")>
	<cfset loc.return = ReplaceNoCase(loc.return, "https://", "", "one")>
	<cfreturn loc.return>
</cffunction>

<cffunction name="ifEmpty" access="public" output="false" returntype="string" hint="returns a string if value is empty">
	<cfargument name="string1" type="string" required="true" hint="string to test">
	<cfargument name="string2" type="string" required="false" default="#arguments.string1#" hint="string to display if not empty (defaults to string 1)">
	<cfargument name="string3" type="string" required="false" default="--" hint="string to display if empty">
	<cfreturn arguments.string1 eq "" ? arguments.string3 : arguments.string2>
</cffunction>

<cffunction name="ifZero" access="public" output="false" returntype="string" hint="formats a time for display">
	<cfargument name="value" type="numeric" required="true" hint="number to test">
	<cfargument name="string" type="string" required="false" default="" hint="string to display if value is zero">
	<cfreturn arguments.value eq 0 ? arguments.string : arguments.value>
</cffunction>
	
<!--- should this be in string or date utilities? --->
<cffunction name="showDate" access="public" output="false" returntype="string" hint="combines the formatDate and isEnpty functions">
	<cfargument name="date" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.dateString = arguments.date>
	<cfif arguments.date neq "">
		<cfset loc.dateString = formatDate(arguments.date)>
	</cfif>
	<cfreturn ifEmpty(arguments.date, loc.dateString)>
</cffunction>

<cffunction name="timeAgo" access="public" output="false" returntype="string" hint="replacement for timeAgoInWords that combines it and ifEmpty">
	<cfargument name="date" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.string = arguments.date>
	<cfif arguments.date neq "">
		<cfset loc.string = timeAgoInWords(arguments.date)>
	</cfif>
	<cfreturn ifEmpty(arguments.date, loc.string)>
</cffunction>

<cffunction name="hyphenify" access="public" output="false" returntype="string" hint="hyphenates a string for SES/slug purposes">
	<cfargument name="string" type="string" required="true">
	<cfset var loc = {string=arguments.string} />
	<cfset loc.string = LCase(loc.string)>
	<cfset loc.string = ReReplace(loc.string,"[ /]","-","all")>
	<cfset loc.string = ReReplace(loc.string,"[^a-z0-9-]","","all")>
	<cfreturn loc.string>
</cffunction>

<cffunction name="securify" output="false">
	<cfargument name="value" type="string" required="true" hint="create an encrypted string for securing ids">
	<cfset var loc = {}>
	<cfset loc.enc = Encrypt(arguments.value, constant("securityString"))>
	<cfreturn "#ToBase64(loc.enc)#&#Hash('#ToBase64(loc.enc)#-#constant('securityString')#','SHA-256')#">
</cffunction>

<cffunction name="desecurify" output="false">
	<cfargument name="value" type="string" required="true" hint="deserialise a securified string">
	<cfset var loc = {}>
	<cfset loc.first = ListFirst(arguments.value, "&")>
	<cfset loc.last = ListLast(arguments.value, "&")>
	<cfset loc.id = Decrypt(ToString(ToBinary(loc.first)), constant("securityString"))>
	<cfif arguments.value eq securify(loc.id)>
		<cfreturn loc.id>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

<cffunction name="dts" access="public" output="false" returntype="string" hint="returns a numeric datetime stamp">
	<cfreturn DateFormat(Now(),"yyyymmdd") & TimeFormat(Now(),"hhmmss")>
</cffunction>

<cffunction name="crlf" access="public" output="false" returntype="string" hint="returns a numeric datetime stamp">
	<cfreturn Chr(13) & Chr(10)>
</cffunction>

<cffunction name="type" output="false" hint="allows global changing of an entity type">
	<cfargument name="type" type="string" required="true">
	<cfset var loc = {}>
	<cfset loc.return = $_typeCase(arguments.type, arguments.type)>
	<cfswitch expression="#arguments.type#">
		<cfcase value="foo">
			<cfset loc.return = $_typeCase("bar", arguments.type)>
		</cfcase>
		<cfcase value="foos">
			<cfset loc.return = $_typeCase("bars", arguments.type)>
		</cfcase>
	</cfswitch>
	<cfreturn loc.return>
</cffunction>

<cffunction name="$$typeCase" access="private" output="false" hint="attempts to return string in same case">
	<cfargument name="type" type="string" required="true" hint="the string to change">
	<cfargument name="typeCase" type="string" required="true" hint="the string to base casing on">
	<cfif ReFind("[abcdefghijklmnopqrstuvwxyz]", arguments.typeCase) eq 0>		<!--- no lowercase letters --->
		<cfreturn UCase(arguments.type)>
	<cfelseif ReFind("[ABCDEFGHIJKLMNOPQRSTUVWXYZ]", arguments.typeCase) eq 0>	<!--- no uppercase letters --->
		<cfreturn LCase(arguments.type)>
	<cfelse>
		<cfreturn capitalize(arguments.type)>
	</cfif>
</cffunction>

<cffunction name="titleise" access="public" output="No" displayname="Titleise" description="I capitalise the first letter of each word">
	<cfargument name="input" type="string" required="yes" />
	<cfscript>
	var Words = "";
	var j = 1; var m = 1;
	var doCap = "";
	var thisWord = "";
	var excludeWords = ArrayNew(1);
	var outputString = "";
	var temp = "";
	var initText = LCASE(arguments.input);

	//Words to never capitalize
	excludeWords[1] = "an";
	excludeWords[2] = "the";
	excludeWords[3] = "at";
	excludeWords[4] = "by";
	excludeWords[5] = "for";
	excludeWords[6] = "of";
	excludeWords[7] = "in";
	excludeWords[8] = "up";
	excludeWords[9] = "on";
	excludeWords[10] = "to";
	excludeWords[11] = "and";
	excludeWords[12] = "as";
	excludeWords[13] = "but";
	excludeWords[14] = "if";
	excludeWords[15] = "or";
	excludeWords[16] = "nor";
	excludeWords[17] = "a";

	//Make each word in text an array variable
	Words = ListToArray(initText, " ");

	//Check words against exclude list
	for(j=1; j LTE (ArrayLen(Words)); j = j+1){
		doCap = true;

		//Word must be less that four characters to be in the list of excluded words
		if(LEN(Words[j]) LT 4 ){
			if(ListFind(ArrayToList(excludeWords,","),Words[j])){
				doCap = false;
			}
		}

		//Capitalize hyphenated words
		if(ListLen(Words[j],"-") GT 1){
			for(m=2; m LTE ListLen(Words[j], "-"); m=m+1){
				thisWord = ListGetAt(Words[j], m, "-");
				thisWord = UCase(Mid(thisWord,1, 1)) & Mid(thisWord,2, LEN(thisWord)-1);
				Words[j] = ListSetAt(Words[j], m, thisWord, "-");
			}
		}

		//Automatically capitalize first and last words
		if(j eq 1 or j eq ArrayLen(Words)){
			doCap = true;
		}

		//perform specific capitalisations (O'Grady)
		if (compareNoCase(left(Words[j],2),"o'") eq 0 AND len(Words[j]) gt 2) {
			Words[j] = UCase(left(Words[j],3)) & Mid(Words[j],4, LEN(Words[j])-3);
			doCap = false;
		}

		//perform specific capitalisations (McDonald)
		if (compareNoCase(left(Words[j],2),"mc") eq 0 AND len(Words[j]) gt 2) {
			Words[j] = UCase(left(Words[j],1)) & lCase(Mid(Words[j],2,1)) & UCase(Mid(Words[j],3,1)) & Mid(Words[j],4, LEN(Words[j])-3);
			doCap = false;
		}
		
		//perform specific capitalisations ('Text' or "Text")
		if (listFindNoCase("'," & '"',left(Words[j],1)) AND len(Words[j]) gt 2) {
			Words[j] = UCase(left(Words[j],2)) & Mid(Words[j],3, LEN(Words[j])-2);
			doCap = false;
		}
		
		//Capitalize qualifying words
		if(doCap){
			Words[j] = UCase(Mid(Words[j],1, 1)) & Mid(Words[j],2, LEN(Words[j])-1);
		}
	}

	outputString = ArrayToList(Words, " ");
	</cfscript>

	<cfreturn outputString />
</cffunction>

<cffunction name="htmlify" access="public" returntype="string" output="No" hint="replaces crlf to html br tags">
	<cfargument name="string" type="string" required="Yes" />
	<cfargument name="br" type="string" required="No" default="<br/>" />
	<cfset var ret = arguments.string />
	<cfset ret = Replace(ret, chr(10), arguments.br, "all") /><!--- LINE FEED --->
	<cfset ret = Replace(ret, chr(13), "", "all") /><!--- CARRIAGE RETURN --->
	<cfset ret = Replace(ret, chr(09), "", "all") /><!--- HORIZONTAL TAB --->
	<cfreturn ret />
</cffunction>

<cffunction name="parseStreetAddress" access="public" hint="Returns a street address in pieces according to localities table">
	<cfargument name="string" type="string" required="true">
	<!--- 
		** Address formats parsed **
		----------------------------
		546 Collins Street
		301/546 Collins Street
		301-546 Collins Street
		Suite 301, 546 Collins Street
		Suite 301 546 Collins Street
		1 St Kilda Road
		Suite 301, 1 St Kilda Road
	--->
	<cfset var loc = {}>
	<cfset loc.return = {subnumber=""}>
	<cfset loc.string = arguments.string>
	<cfset loc.streetNumberDelims = "/\, ">
	<!--- check the string length --->
	<cfset loc.parts = ListToArray(loc.string, " ")>
	<cfset loc.len = ArrayLen(loc.parts)>

	<!--- build a reversed list --->
	<cfset loc.posList = "">
	<cfloop from="1" to="#loc.len#" index="loc.i">
		<cfset loc.posList = ListPrepend(loc.posList, loc.i)>
	</cfloop>
	
	<!--- start from the end, once i hit a string containing a number, the street name has finished --->
	<cfset loc.return.streetname = "">
	<cfset loc.notStreetName = "">
	<cfloop list="#loc.posList#" index="loc.i">
		<cfif ReFind("[0-9]", loc.parts[loc.i]) eq 0>
			<cfset loc.return.streetname = ListPrepend(loc.return.streetname, loc.parts[loc.i], " ")>
			<cfset loc.lastPart = loc.i>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<!--- loop thru the remaining parts --->
	<cfloop list="#loc.posList#" index="loc.i">
		<cfif loc.i lt loc.lastPart>
			<cfset loc.notStreetName = ListPrepend(loc.notStreetName, loc.parts[loc.i], " ")>
		</cfif>
	</cfloop>

	<!--- see if there's a subnumber in here --->
	<cfset loc.subArray = ListToArray(loc.notStreetName, loc.streetNumberDelims)>
	<cfset loc.return.streetnumber = arrayLast(loc.subArray)>
	<cfif ArrayLen(loc.subArray) gt 1>
		<cfset loc.removeLast = ListDeleteAt(loc.notStreetName, ListLen(loc.notStreetName, loc.streetNumberDelims), loc.streetNumberDelims)>
		<cfset loc.return.subnumber = loc.removeLast>
	</cfif>
	<cfreturn loc.return>
</cffunction>

<cffunction name="randomString" returntype="string" output="false">
	<cfargument name="type" type="string" required="false" default="alphanumeric" hint="[numeric|alpha|alphanumeric|secure|urlsafe]" />
	<cfargument name="length" type="numeric" required="false" default="32">
	<cfargument name="mixedCase" type="boolean" required="false" default="false">
	<cfset var loc = {}>
	<cfset loc.return = "">
	<!--- define the characters available --->
	<cfset loc.numbers = "0,1,2,3,4,5,6,7,8,9">
	<cfset loc.letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
	<cfif arguments.mixedCase>
		<cfset loc.letters = ListAppend(loc.letters, UCase(loc.letters))>
	</cfif>
	<cfset loc.symbols = "!,@,$,%,*,-,_,=,+,?,~">

	<!--- build a list of available characters --->
	<cfif arguments.type eq "numeric">
		<cfset loc.source = loc.numbers>
	<cfelseif arguments.type eq "alpha">
		<cfset loc.source = loc.letters>
	<cfelseif arguments.type eq "alphanumeric">
		<cfset loc.source = "#loc.letters#,#loc.numbers#">
	<cfelseif arguments.type eq "secure">
		<cfset loc.source = "#loc.letters#,#loc.numbers#,#loc.symbols#">
	<cfelseif arguments.type eq "urlsafe">
		<cfset loc.source = "#loc.letters#,#loc.numbers#,_,-">
	<cfelse>
		<cfthrow message="invalid type argument (#arguments.type#)">
	</cfif>
	<cfset loc.source = ListToArray(loc.source)>

	<!--- build the string to the required length --->
	<cfloop from="1" to="#arguments.length#" index="loc.i">
		<cfset loc.return = loc.return & loc.source[RandRange(1, loc.source.Len())]>
	</cfloop>
	<cfreturn loc.return>
</cffunction>

<cfscript>
/**
 * Replaces a huge amount of unnecessary whitespace from your HTML code.
 * 
 * @param sInput 	 HTML you wish to compress. (Required)
 * @return Returns a string. 
 * @author Jordan Clark (&#74;&#111;&#114;&#100;&#97;&#110;&#67;&#108;&#97;&#114;&#107;&#64;&#84;&#101;&#108;&#117;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, November 19, 2002 
 */
function HtmlCompressFormat(sInput)
{
   var level = 2;
   if( arrayLen( arguments ) GTE 2 AND isNumeric(arguments[2]))
   {
      level = arguments[2];
   }
   // just take off the useless stuff
   sInput = trim(sInput);
   switch(level)
   {
      case "3":
      {
         //   extra compression can screw up a few little pieces of HTML, doh         
         sInput = reReplace( sInput, "[[:space:]]{2,}", " ", "all" );
         sInput = replace( sInput, "> <", "><", "all" );
         sInput = reReplace( sInput, "<!--[^>]+>", "", "all" );
         break;
      }
      case "2":
      {
         sInput = reReplace( sInput, "[[:space:]]{2,}", chr( 13 ), "all" );
         break;
      }
      case "1":
      {
         // only compresses after a line break
         sInput = reReplace( sInput, "(" & chr( 10 ) & "|" & chr( 13 ) & ")+[[:space:]]{2,}", chr( 13 ), "all" );
         break;
      }
   }
   return sInput;
}
</cfscript>
