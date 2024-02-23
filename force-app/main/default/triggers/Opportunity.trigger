trigger Opportunity on Opportunity (after update, before update) {

  if (trigger.isUpdate) {
    if (trigger.isBefore) {
      for (Opportunity Opportunity : trigger.new){
        if (string.isBlank(Opportunity.Email__c) && 
          Opportunity.StageName !='Qualification' && Opportunity.StageName !='Closed Lost'){
            Opportunity.Email__c.addError('Precisa Preencher o email');  
        }  
        else if (trigger.oldMap.get(Opportunity.Id).StageName == 'Closed Won' &&
          Opportunity.Stagename != 'Closed Won'){
           Opportunity.addError ('A fase CLOSED WON não pode ser alterada.');
       } 
       }
    }  
  }
}