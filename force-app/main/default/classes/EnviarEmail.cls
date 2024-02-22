public class EnviarEmail {

    public static void EnviarEmail 
        (String Endereco , String Assunto, String Corpo, Blob anexo, String nomeAnexo){
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
            email.setToAddresses (new String[]{Endereco});
            email.setSubject(Assunto);
            email.setPlainTextBody(Corpo);
            
        Messaging.EmailFileAttachment anexoEmail = new Messaging.EmailFileAttachment();
        anexoEmail.setFileName(nomeAnexo);
        anexoEmail.setBody(anexo);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{anexoEmail});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}
