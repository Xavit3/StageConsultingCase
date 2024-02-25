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
          else if ((trigger.oldMap.get(Opportunity.Id).StageName == 'Value Proposition' &&
          Opportunity.Stagename != 'Value Proposition') && Opportunity.envioProposta__c == false){
               Opportunity.addError ('Para mudar a fase precisa anexar arquivo.');
          }
       } 
    }
  else if (trigger.isAfter) {
     List<Messaging.SingleEmailMessage>   enviarEmail = new List<Messaging.SingleEmailMessage>();
    for(Opportunity Opp : Trigger.new) {
        if (Opp.StageName.equals('Negotiation/Review') && Opp.envioProposta__c == true) {
            //List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opp.Id AND Name like '%proposta%'];
            //if(!attachments.isEmpty()) {  
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {Opp.Email__c}); // Define o endereço de e-mail do destinatário
                email.setSubject('Envio de proposta');
                email.setPlainTextBody('Seu Corpo de E-mail Aqui');
  
               //Adiciona o anexo ao e-mail
               // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                //attachment.setFileName('proposta.txt'); // Pode usar 'proposta' ou o nome original do anexo
               // attachment.setBody(attachments[0].Body);
                //email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
  
                  enviarEmail.add(email);
            }
        }
//    }
   if(!  enviarEmail.isEmpty()) {
     Messaging.sendEmail(  enviarEmail);
   }
  }
 }
}