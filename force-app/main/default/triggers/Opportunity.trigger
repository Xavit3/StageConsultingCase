trigger Opportunity on Opportunity (before insert, before update, after update) {

  if (trigger.isInsert){
    if(trigger.isBefore){
      for (Opportunity Opp1 : trigger.new){
        Opp1.CloseDate = date.today() + 40;
      }
    }
  }
  if (trigger.isUpdate) {
      
    if (trigger.isBefore) {
      for (Opportunity Opp2 : trigger.new){
        if (string.isBlank(Opp2.Email__c) && 
          Opp2.StageName !='Qualification' && Opp2.StageName !='Closed Lost'){
            Opp2.Email__c.addError('Precisa Preencher o email');  
          }  
        else if (trigger.oldMap.get(Opp2.Id).StageName == 'Closed Won' &&
          Opp2.Stagename != 'Closed Won'){
           Opp2.addError ('A fase CLOSED WON não pode ser alterada.');
          } 
          else if ((trigger.oldMap.get(Opp2.Id).StageName == 'Value Proposition' &&
          Opp2.Stagename != 'Value Proposition') && Opp2.StageName !='Closed Lost'  &&
            Opp2.envioProposta__c == false){
               Opp2.addError ('Para mudar a fase precisa anexar arquivo de proposta ');
          }
          
               else if ((trigger.oldMap.get(Opp2.Id).StageName == 'Negotiation/Review' &&
          Opp2.Stagename != 'Negotiation/Review') && Opp2.StageName != 'Closed Lost' &&
          (Opp2.TempoProjeto__c == null || Opp2.ValorProposta__c == null || Opp2.Amount == null ||
          Opp2.envioDocForm__c == false || Opp2.envioProposta__c == false)){
               Opp2.addError('Para mudar a fase, é necessário preencher todos os campos obrigatórios e enviar a proposta.');
}
          /*
  else if (trigger.isAfter) {
     List<Messaging.SingleEmailMessage>   enviarEmail = new List<Messaging.SingleEmailMessage>();
    for(Opportunity Opp : Trigger.new) {
        if ((trigger.oldMap.get(Opp.Id).StageName == 'Value Proposition' &&
          Opp.Stagename == 'Negotiation/Review') && Opp.envioProposta__c == true) {
            //List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opp.Id AND Name like '%proposta%'];
            //if(!attachments.isEmpty()) {  
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {Opp.Email__c}); 
                email.setSubject('Envio de proposta:' + Opp.Name );
                email.setPlainTextBody('Prezado/a ' + Opp.AccountId + ';' +
                '\n\n' + 'Estamos enviando este email com a proposta referente à sua solicitação. O arquivo' +
    ' segue em anexo para posterior análise. Qualquer dúvida, ficamos à disposição.' +
    '\n\n' + 'Solicitamos que, caso a proposta esteja de acordo com seu interesse, realize a assinatura do ' +
    'arquivo para prosseguirmos com o processo de formalização.' +
    '\n\n' + 'Atenciosamente, ' + Opp.Name);)

  
               //Adiciona 
               // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                //attachment.setFileName('proposta'); 
               // attachment.setBody(attachments[0].Body);
                //email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
  
                  enviarEmail.add(email);
            }
            else if ((trigger.oldMap.get(Opp.Id).StageName == 'Negotiation/Review' &&
          Opp.Stagename == 'Formalization') && Opp.envioProposta__c == true && Opp.envioDocForm__c == true) {
            //List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opp.Id AND Name like '%proposta%'];
            //if(!attachments.isEmpty()) {  
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {Opp.Email__c}); 
                email.setSubject('Contrato e NDA: ' + Opp.Name );
                email.setPlainTextBody('Prezado/a ' + Opp.AccountId + ';' +
                '\n\n' + 'Estamos enviando os documentos referentes ao contrato da proposta e o NDA' +
    ' (ACORDO DE NÃO DIVULGAÇÃO ) para a realização da leitura e posterior assinatura.' +
    '\n\n' + 'Caso surja alguma dúvida, pode entrar em contato ou pode estar realizando a assinatura do ' +
    'arquivos para concluir o processo de formalização.' +
    '\n\n' + 'Atenciosamente, ' + Opp.Name);

  
               //Adiciona 
               // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                //attachment.setFileName('proposta'); 
               // attachment.setBody(attachments[0].Body);
                //email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
  
                  enviarEmail.add(email);
            }
            else if ((trigger.oldMap.get(Opp.Id).StageName == 'Formalization' &&
          Opp.Stagename == 'Closed Won') && Opp.envioProposta__c == true && Opp.envioDocForm__c == true) {
            //List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opp.Id AND Name like '%proposta%'];
            //if(!attachments.isEmpty()) {  
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {Opp.Email__c}); 
                email.setSubject('Proposta deferida ' + Opp.Name );
                email.setPlainTextBody('Prezado/a ' + Opp.AccountId + ';' +
                '\n\n' + 'É com muito entusiasmo que informamos que a sua proposta foi finalizada e aprovada.' +
    'Solicitamos que entre em contato para orientar os próximos passos. ' +
    '\n\n' + 'Agradecemos a confiança depositada em nossa empresa. '+
    'À dispociação.' +
    '\n\n' + 'Atenciosamente, ' + Opp.Name);

  
               //Adiciona 
               // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                //attachment.setFileName('proposta'); 
               // attachment.setBody(attachments[0].Body);
                //email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
  
                  enviarEmail.add(email);
            }
            else if (Opp.StageName.equals('Closed Lost')) {
              //List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :Opp.Id AND Name like '%proposta%'];
              //if(!attachments.isEmpty()) {  
                  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                  email.setToAddresses(new String[] {Opp.Email__c}); 
                  email.setSubject('Proposta Indeferida ' + Opp.Name );
                  email.setPlainTextBody('Prezado/a ' + Opp.AccountId + ';' +
                  '\n\n' + 'Viemos pelo seguinte email informar que não foi possivel dar continuidade na' +
      'na proposta solicitada. Caso seja de seu interesse, entre em contato para realizar os ajustes necessários' +
      '\n\n' + 'Agradecemos a confiança depositada em nossa empresa. '+
      'À dispociação.' +
      '\n\n' + 'Atenciosamente, ' + Opp.Name);
  
    
                 //Adiciona 
                 // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                  //attachment.setFileName('proposta'); 
                 // attachment.setBody(attachments[0].Body);
                  //email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
    
                    enviarEmail.add(email);
              }
        }
//    }
   if(!  enviarEmail.isEmpty()) {
     Messaging.sendEmail(  enviarEmail);
   }
  } */
 }
}
}
}