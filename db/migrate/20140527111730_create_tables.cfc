<cfcomponent extends="plugins.dbmigrate.Migration" hint="create tables">

  <cfinclude template="helpers.cfm">

  <cffunction name="up">
    <cfscript>
      // a top level administrator
      t = createTable(name="roots", force=true);
      // any root centric columns here
      t.timestamps();
      t.create();

      // an administrator of users
      t = createTable(name="administrators", force=true);
      // any administrator centric columns here
      t.timestamps();
      t.create();

      // a public consumer
      t = createTable(name="users", force=true);
      // any user centric columns here
      t.timestamps();
      t.create();

      t = createTable(name="people", force=true);
      t.integer(columnNames="rootid,administratorid,userid", null=true);
      t.string(columnNames="firstname", null=false, limit="32");
      t.string(columnNames="lastname", null=false, limit="32"); 
      t.string(columnNames="position", null=true, limit="64");
      t.string(columnNames="mobile,homephone,workphone", null=true, limit="16");
      t.string(columnNames="email", null=false, limit="128");
      t.string(columnNames="password", null=false, limit="250");
      t.string(columnNames="salt", null=false, limit="36");
      t.string(columnNames="resettoken", null=true, limit="64");
      t.datetime(columnNames="tokencreatedat,tokenexpiresat,lastsigninat,lastsigninattemptat,confirmedat", null=true);
      t.string(columnNames="lastsigninattemptipaddress", null=true, limit="32");
      t.decimal(columnNames="utcoffset", null=false, precision="10", scale="2");
      t.text(columnNames="sessiondata", null=true);
      t.timestamps();
      t.create();

      // foreign keys (MYSQL)
      $$createForeignKey("people", "roots", "rootid");
      $$createForeignKey("people", "administrators", "administratorid");
      $$createForeignKey("people", "users", "userid");

      // errors table
      t = createTable(name='errors', force=true);
      t.integer(columnNames='personid', null=true);
      t.string(columnNames='server', null=true, limit='32');
      t.string(columnNames='domain,remoteip', null=true, limit='64');
      t.string(columnNames='filepath', null=true, limit='256');
      t.string(columnNames='controller,action', null=true, limit='32');
      t.string(columnNames='scriptname', null=true, limit='1024');
      t.string(columnNames='querystring,diagnostics,rawtrace', null=true, limit='1024');
      t.string(columnNames='browser', null=true, limit='512');
      t.string(columnNames='referrer', null=true, limit='512');
      t.string(columnNames='post', null=true);
      t.text(columnNames='json', null=true);
      t.datetime(columnNames='createdat', null=false);
      t.datetime(columnNames='deletedat', null=true);
      t.create();

      // a table for CRUD examples
      t = createTable(name="examples", force=true);
      t.string(columnNames='name', limit='64');
      t.integer(columnNames="number");
      t.datetime(columnNames='sampledat', null=false);
      t.timestamps();
      t.create();


    </cfscript>
  </cffunction>

  <cffunction name="down">
    <cfscript>
      $$dropForeignKey("people", "roots");
      $$dropForeignKey("people", "administrators");
      $$dropForeignKey("people", "users");

      dropTable("examples");
      dropTable("people");
      dropTable("roots");
      dropTable("users");
      dropTable("administrators");
      dropTable("errors");
    </cfscript>
  </cffunction>

</cfcomponent>