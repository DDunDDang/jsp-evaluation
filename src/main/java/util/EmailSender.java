package util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailSender implements Runnable {
    private String from;
    private String to;
    private String subject;
    private String content;
    private Properties properties;
    private Authenticator authenticator;

    public EmailSender(String from, String to, String subject, String content, Properties properties, Authenticator authenticator) {
        this.from = from;
        this.to = to;
        this.subject = subject;
        this.content = content;
        this.properties = properties;
        this.authenticator = authenticator;
    }

    @Override
    public void run() {
        try {
            Session session = Session.getInstance(properties, authenticator);
            session.setDebug(true);

            MimeMessage message = new MimeMessage(session);
            message.setSubject(subject);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setContent(content, "text/html;charset=UTF-8");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}

