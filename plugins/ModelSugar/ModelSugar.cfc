<cfcomponent mixin="model">

	<cffunction name="init">
		<cfset this.version = "1.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
		<cfargument name="missingMethodName" type="string" required="true">
		<cfargument name="missingMethodArguments" type="struct" required="true">
		<cfscript>
			if (Left(arguments.missingMethodName, 17) == "findOneOrCreateBy")
				return $findOneOrCreateBy(argumentCollection=arguments);
			else
				return core.onMissingMethod(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<cffunction name="$findOneOrCreateBy" returntype="any" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.property = ReplaceNoCase(arguments.missingMethodName, "findOneOrCreateBy", "");
			if (StructKeyExists(arguments.missingMethodArguments, "1"))
			{
				arguments.missingMethodArguments[loc.property] = arguments.missingMethodArguments[1];
				StructDelete(arguments.missingMethodArguments, "1");
			}
			loc.value = arguments.missingMethodArguments[loc.property];
			StructDelete(arguments, "missingMethodName");
			StructDelete(arguments.missingMethodArguments, loc.property);
			StructAppend(arguments, arguments.missingMethodArguments);
			StructDelete(arguments, "missingMethodArguments");
			arguments[loc.property] = loc.value;
			loc.object = findOne(where=$keyWhereString(loc.property, loc.value));
			if (IsObject(loc.object))
				return loc.object;
			else
				return create(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<cffunction name="findFirst" returntype="any" access="public" output="false">
		<cfargument name="property" type="string" required="false" default="#primaryKey()#">
		<cfargument name="$sort" type="string" required="false" default="ASC">
		<cfscript>
			arguments.order = arguments.property & " " & arguments.$sort;
			StructDelete(arguments, "property");
			StructDelete(arguments, "$sort");
			return findOne(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<cffunction name="findLast" returntype="any" access="public" output="false">
		<cfscript>
			arguments.$sort = "DESC";
			return findFirst(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<cffunction name="findAllKeys" returntype="string" access="public" output="false">
		<cfargument name="quoted" type="boolean" required="false" default="false">
		<cfargument name="delimiter" type="string" required="false" default=",">
		<cfscript>
			var loc = {};
			loc.quoted = arguments.quoted;
			StructDelete(arguments, "quoted");
			loc.delimiter = arguments.delimiter;
			StructDelete(arguments, "delimiter");
			arguments.select = primaryKey();
			loc.query = findAll(argumentCollection=arguments);
			if (loc.quoted)
				loc.functionName = "QuotedValueList";
			else
				loc.functionName = "ValueList";
			return Evaluate("#loc.functionName#(loc.query.#arguments.select#, '#loc.delimiter#')");
		</cfscript>
	</cffunction>
		
</cfcomponent>