public with sharing class AccountTriggerHandler implements TriggerHandler {

    private Boolean triggerIsExecuting;
    private Integer triggerSize;
    public AccountTriggerHelper helper;

    public AccountTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new AccountTriggerHelper();
    }

    public void beforeInsert(List<Account> newAccounts) { }

    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) { }

    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) { }

    public void afterInsert(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
        System.debug('### AccountTriggerHandler | afterInsert');
        helper.createNewChildAccount(newAccounts, null);
    }

    public void afterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        System.debug('### AccountTriggerHandler | afterUpdate');
        helper.createNewChildAccount(newAccounts, oldAccountMap);
    }

    public void afterDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) { }

    public void afterUndelete(List<Account> newAccounts, Map<ID, SObject> newAccountMap) { }

}