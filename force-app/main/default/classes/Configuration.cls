public with sharing class Configuration {
	private static Map<String, Configuration__c> configMap = new Map<String, Configuration__c>();
	static{
		configMap.putAll(Configuration__c.getAll());
	}

	public static String getValue(String paramName){
		Configuration__c config = configMap.get(paramName);
		return config != null ? config.Value__c : '';
	}

	public static void setValue(String paramName, String paramValue){
		Configuration__c config = new Configuration__c(Value__c = paramValue);
		configMap.put(paramName, config);
	}

}