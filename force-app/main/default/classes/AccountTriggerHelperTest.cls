@isTest
private class AccountTriggerHelperTest {

    @isTest
    static void createAccountShouldWork() {
        Test.startTest();
        
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName
        );
        Database.insert(acc);
        
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        System.assertNotEquals(0, accounts.size(), 'An Account named ' + accountName + ' should be created');
        System.assertEquals(1, accounts.size(), 'Only 1 Account should be created');
    }

    @isTest
    static void createChildAccountShouldWork() {
        Test.startTest();
        
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName,
            Status__c = 'Cold'
        );
        Database.insert(acc);
        
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        System.assertNotEquals(0, accounts.size(), 'An Account named ' + accountName + ' should be created');
        System.assertEquals(2, accounts.size(), 'Only 2 Accounts should be created');

        List<Account> childAccounts = [SELECT Id, Name, ParentId__c, Status__c FROM Account WHERE ParentId__c != NULL];
        System.assertNotEquals(0, childAccounts.size(), 'An Child Account named ' + accountName + ' should be created');
        System.assertEquals(1, childAccounts.size(), 'Only 1 Child Account should be created');
        System.assertNotEquals(null, childAccounts[0].ParentId__c, 'ParentId__c on Child Account should not be null');
        System.assertEquals('Cold', childAccounts[0].Status__c, 'Status__c on Child Account should be Cold');
    }

    @isTest
    static void shouldNotCreateChildAccount() {
        Test.startTest();
        
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName,
            Status__c = 'Hot'
        );
        Database.insert(acc);
        
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        System.assertNotEquals(0, accounts.size(), 'An Account named ' + accountName + ' should be created');
        System.assertEquals(1, accounts.size(), 'Only 1 Account should be created');

        List<Account> childAccounts = [SELECT Id, Name FROM Account WHERE ParentId__c != NULL];
        System.assertEquals(0, childAccounts.size(), 'Child Account should not be created');
    }

    @isTest
    static void updateAccountShouldWork() {
        
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName
        );
        Database.insert(acc);

        Test.startTest();

        String changedAccountName = 'Account Updated Name Test';
        acc.Name = changedAccountName;
        Database.update(acc);

        Test.stopTest();

        List<Account> updatedAccount = [SELECT Id, Name FROM Account WHERE Name = :changedAccountName];
        System.assertNotEquals(0, updatedAccount.size(), 'An account named ' + changedAccountName + ' should exist');
        System.assertEquals(1, updatedAccount.size(), 'Only 1 Account should be created');
    }

    @isTest
    static void updateParentAccountStatusToColdShouldCreateChildAccount() {
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName
        );
        Database.insert(acc);

        Test.startTest();

        acc.Status__c = 'Cold';
        Database.update(acc);

        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        System.assertNotEquals(0, accounts.size(), 'An Account named ' + accountName + ' should be created');
        System.assertEquals(2, accounts.size(), 'Only 2 Accounts should be created');

        List<Account> childAccounts = [SELECT Id, Name FROM Account WHERE ParentId__c != NULL];
        System.assertNotEquals(0, childAccounts.size(), 'An Child Account named ' + accountName + ' should be created');
        System.assertEquals(1, childAccounts.size(), 'Only 1 Child Account should be created');
    }

    @isTest
    static void updateParentAccountStatusToHotShouldNotCreateChildAccount() {
        String accountName = 'Account Name Test';
        Account acc = new Account(
            Name = accountName
        );
        Database.insert(acc);

        Test.startTest();

        acc.Status__c = 'Hot';
        Database.update(acc);

        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        System.assertNotEquals(0, accounts.size(), 'An Account named ' + accountName + ' should be created');
        System.assertEquals(1, accounts.size(), 'Only 1 Account should be created');

        List<Account> childAccounts = [SELECT Id, Name FROM Account WHERE ParentId__c != NULL];
        System.assertEquals(0, childAccounts.size(), 'Child Account should not be created');
    }

}