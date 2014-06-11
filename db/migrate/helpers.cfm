<cffunction name="$$createForeignKey" output="false" access="private">
	<cfargument name="fktable" type="string" required="true">
	<cfargument name="pktable" type="string" required="true">
	<cfargument name="fkcolumn" type="string" required="true">
	<cfset execute("ALTER TABLE #arguments.fktable# ADD CONSTRAINT FK_#arguments.fktable#_#arguments.pktable# FOREIGN KEY (#arguments.fkcolumn#) REFERENCES #arguments.pktable# (id) ON DELETE NO ACTION ON UPDATE NO ACTION, ADD INDEX FK_#arguments.fktable#_#arguments.pktable# (#arguments.fkcolumn# ASC);")>
</cffunction>

<cffunction name="$$dropForeignKey" output="false" access="private">
	<cfargument name="fktable" type="string" required="true">
	<cfargument name="pktable" type="string" required="true">
	<cfset dropForeignKey(table=arguments.fktable, keyName="FK_#arguments.fktable#_#arguments.pktable#")>
	<cfset removeIndex(table=arguments.fktable, indexName="FK_#arguments.fktable#_#arguments.pktable#")>
</cffunction>