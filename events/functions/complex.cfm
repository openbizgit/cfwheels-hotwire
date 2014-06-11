<cffunction name="queryRowToStruct" returntype="struct" output="false" hint="I take a query and a row number and convert it to a struct">
    <cfargument name="query" type="query" required="true">
    <cfargument name="row" type="numeric" default="1">
    <cfset var loc = {}>
    <cfset loc.i = 0>
    <cfset loc.struct = {}>
    <cfloop list="#arguments.query.columnList#" index="i">
        <cfset loc.struct[i] = arguments.query[i][arguments.row]>
    </cfloop>
    <cfreturn loc.struct>
</cffunction>

<cffunction name="arrayOfStructFindKeyValue" access="public" output="No" returntype="numeric" hint="I return the position of the matching key/value pair found in an array of structures">
    <cfargument name="array" required="Yes" type="array" />
    <cfargument name="key" required="Yes" type="string" />
    <cfargument name="value" required="Yes" type="string" />
    <cfset var loc = {} />
    <cfset loc.return = 0 />
    <cfloop from="1" to="#arrayLen(arguments.array)#" index="loc.i">
        <cfif structKeyExists(arguments.array[loc.i],arguments.key) AND compareNoCase(arguments.array[loc.i][arguments.key],arguments.value) eq 0>
            <cfset loc.return = loc.i />
            <cfbreak />
        </cfif>
    </cfloop>
    <cfreturn loc.return />
</cffunction>

<cffunction name="queryOfQueries" output="false">
    <cfargument name="query" type="any" hint="can be passed in as the query name OR the query object itself">
    <cfargument name="where" type="string" default="">
    <cfargument name="select" type="string" default="*">
    <cfargument name="order" type="string" default="">
    
	<cfset var loc = {}>

    <cfif IsQuery(arguments.query)>
        <cfset var qry = arguments.query>
        <cfset var qryName = "query">
    <cfelse>
        <cfset var qry = arguments.query>
        <cfset var qryName = arguments.query>
    </cfif>

    <cfquery dbtype="query" name="loc.return">
        SELECT #arguments.select# FROM #qryName#
		<cfif len(arguments.where)>WHERE #PreserveSingleQuotes(Replace(arguments.where,'"',"'","ALL"))#</cfif>
		<cfif len(arguments.order)>ORDER BY #arguments.order#</cfif>
    </cfquery>
    
    <cfreturn loc.return>
</cffunction>

<cffunction name="mergeObjectProperties" output="false">
    <!--- any number of objects can be passed in as arguments --->
    <cfset var loc = {}>
    <cfset loc.args = arguments>
    <cfset loc.ret = {}>
    <cfset loc.reversed = arrayReverse(loc.args)>

    <!--- look backwards through array of objects to keep overwriting consistent --->
    <cfloop array="#loc.reversed#" index="loc.i">
        <cfloop collection="#loc.i.properties()#" index="loc.k">
            <cfif IsSimpleValue(loc.i[loc.k])>
                <cfset loc.ret[loc.k] = loc.i[loc.k]>
            </cfif>
        </cfloop>
    </cfloop>

    <cfreturn loc.ret>
</cffunction>

<cffunction name="queryConcat" returntype="query" output="false">
    <cfargument name="q1" type="query" required="true">
    <cfargument name="q2" type="query" required="true">
    <cfscript>
        var row = "";
        var col = "";

        if(arguments.q1.columnList NEQ arguments.q2.columnList) {
            return arguments.q1;
        }

        for(row=1; row LTE arguments.q2.recordCount; row=row+1) {
         queryAddRow(arguments.q1);
         for(col=1; col LTE listLen(arguments.q1.columnList); col=col+1)
            querySetCell(arguments.q1,ListGetAt(arguments.q1.columnList,col), arguments.q2[ListGetAt(arguments.q1.columnList,col)][row]);
        }
        return arguments.q1;        
    </cfscript>    
</cffunction>
