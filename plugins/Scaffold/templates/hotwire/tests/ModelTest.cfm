component extends="Tests.TestBase" 
{
    
	// setup runs before every test
    public void function setup() 
    {
    	onstartup();
        super.setup();
        // create an instance of our [NameSingularUppercase]
        loc.[NameSingularLowercase] = model("[NameSingularUppercase]").new();
        // a struct used to set valid model property values
        loc.validProperties = {
        	[validModelProperties]
        };
        // a struct used to set invalid model property values
        loc.invalidProperties = {
        	[invalidModelProperties]
        };
        loc.ids = {read=1, write=2, delete=3};
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
    public void function test_[NameSingularLowercase]_should_be_valid() 
    {
		// set the properties of the model
		loc.[NameSingularLowercase].setProperties(loc.validProperties);
		loc.result = loc.[NameSingularLowercase].valid();
		assert("loc.result","loc.[NameSingularLowercase].allErrors()");
	}

	// assert the model is invalid when no properties are set
	public void function test_[NameSingularLowercase]_should_not_be_valid() 
	{
		loc.[NameSingularLowercase].setProperties(loc.invalidProperties);
        assert("! loc.[NameSingularLowercase].valid()");
	}

	// assert the model creates successfully
	public void function test_[NameSingularLowercase]_should_create_successfully() 
	{
		// set the properties of the model
		loc.[NameSingularLowercase].setProperties(loc.validProperties);
		loc.result = loc.[NameSingularLowercase].save();
        assert("loc.result", "loc.[NameSingularLowercase].allErrors()");
	}

	// assert the model updates successfully
	public void function test_[NameSingularLowercase]_should_update_successfully() 
	{
		loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findByKey(loc.ids.write);
		loc.[NameSingularLowercase].setProperties(loc.validProperties);
		loc.result = loc.[NameSingularLowercase].update();
        assert("loc.result", "loc.[NameSingularLowercase].allErrors()");
	}

	// assert the model deletes successfully
	public void function test_[NameSingularLowercase]_should_delete_successfully() 
	{
		loc.[NameSingularLowercase] = model("[NameSingularUppercase]").findByKey(loc.ids.delete);
		loc.result = loc.[NameSingularLowercase].delete();
        assert("loc.result");
	}

}