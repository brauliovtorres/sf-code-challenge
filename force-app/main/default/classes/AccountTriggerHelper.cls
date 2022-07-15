public with sharing class AccountTriggerHelper {

    public void createNewChildAccount(List<Account> newAccounts, Map<ID, SObject> oldAccountMap) {

        List<Account> accountsWithColdStatus = new List<Account>();
        for (Account newAccount : newAccounts) {

            if (isParentAccount(newAccount)) {

                if (hasOldAccount(oldAccountMap) && hasChangedStatus(newAccount, (Account) oldAccountMap.get(newAccount.ID)) && isStatusCold(newAccount)) {
                    accountsWithColdStatus.add(newAccount);
                } else if (isStatusCold(newAccount)) {
                    accountsWithColdStatus.add(newAccount);
                }

            }

        }

        if (!accountsWithColdStatus.isEmpty()) {

            List<Account> childAccounts = new List<Account>();
            for (Account acc : accountsWithColdStatus) {

                Account childAccount = new Account(
                    Name = acc.Name,
                    ParentId__c = acc.Id,
                    Status__c = 'Cold'
                );

                childAccounts.add(childAccount);
            }

            Database.insert(childAccounts);
        }
    }

    private Boolean hasOldAccount(Map<ID, SObject> oldAccountMap) {
        return oldAccountMap != null && !oldAccountMap.isEmpty();
    }

    private Boolean hasChangedStatus(Account newAccount, Account oldAccount) {
        return newAccount.Status__c != oldAccount.Status__c;
    }

    private Boolean isStatusCold(Account account) {
        return 'Cold'.equals(account.Status__c);
    }

    private Boolean isParentAccount(Account account) {
        return account.ParentId__c == null;
    }

}
