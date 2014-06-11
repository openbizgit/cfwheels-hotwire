component extends="Tests.TestBase" 
{
    
	// setup runs before every test
    public void function setup() 
    {
    	onstartup();
        super.setup();
        // create an instance of our Administrator
        loc.administrator = model("Administrator").new();
        // a struct used to set valid model property values
        loc.validProperties = {
        	
        };
        // a struct used to set invalid model property values
        loc.invalidProperties = {
        	
        };
        loc.ids = {read=1, write=1, delete=1};
    }
    
    // teardown runs after every test
    public void function teardown() 
    {
    	 super.teardown();
    }

    // assert that setup and teardown pass
    public void function test_setup_and_teardown() 
    {
		assert("true");
	}

	// assert that because the properties are set correct and meet validation, the model is valid
    public void function test_administrator_should_be_valid() 
    {
		// set the properties of the model
		loc.administrator.setProperties(loc.validProperties);
		loc.result = loc.administrator.valid();
		assert("loc.result","loc.administrator.allErrors()");
	}

	// assert the model is invalid when no properties are set
	// public void function test_administrator_should_not_be_valid() 
	// {
	// 	loc.administrator.setProperties(loc.invalidProperties);
 	//		assert("! loc.administrator.valid()");
	// }

	// assert the model creates successfully
	public void function test_administrator_should_create_successfully() 
	{
		// set the properties of the model
		loc.administrator.setProperties(loc.validProperties);
		loc.result = loc.administrator.save();
        assert("loc.result", "loc.administrator.allErrors()");
	}

	// assert the model updates successfully
	public void function test_administrator_should_update_successfully() 
	{
		loc.administrator = model("Administrator").findByKey(loc.ids.write);
		loc.administrator.setProperties(loc.validProperties);
		loc.result = loc.administrator.update();
        assert("loc.result", "loc.administrator.allErrors()");
	}

	// assert the model deletes successfully
	public void function test_administrator_should_delete_successfully() 
	{
		loc.administrator = model("Administrator").findByKey(loc.ids.delete);
		loc.result = loc.administrator.delete();
        assert("loc.result");
	}

}
