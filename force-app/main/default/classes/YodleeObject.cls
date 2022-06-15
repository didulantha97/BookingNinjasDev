public with sharing class YodleeObject {
	public class Transaction2 {
		public Decimal amount;
		public String curency;
		public String baseType;
		public Date transactionDate;
		public String descriptionOriginal;
		public String descriptionConsumer;
		public String descriptionSimple;
		public String accountId;
		public String categoryType;
		public String category;
		public String id;
	}

	public class Account{
		public String id;
		public String providerName{get;set;}
		public String accountName{get;set;}
		
	}
}