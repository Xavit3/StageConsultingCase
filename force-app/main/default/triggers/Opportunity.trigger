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
        else if (Opportunity.StageName.equals('Negotiation/Review')) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();{
            mail.setToAddresses(Opportunity.StageName); //procurrar erro
            mail.setSubject('Envio de Proposta');
            mail.setPlainTextBody('hola, estou enviando a proposta adjunta');
          }
            Attachment[] attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opportunity.Id AND Name = 'proposta'];
            if (attachments.size() > 0) {
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{new Messaging.EmailFileAttachment(
                    fileName = attachments[0].Name,
                    body = attachments[0].Body
                )});
            }
            emails.add(mail);
        }
    }
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
      }
  }

  