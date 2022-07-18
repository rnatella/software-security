package it.unina;

public class DataFlow2 {

    public void myfunc() {

        String x = this.getSecret();

        if(Debug.isDebugMode()) {

            System.out.println("The secret is: " + x);
        }
    }







    private final String secret = "password";

    private String getSecret() {
        return this.secret;
    }

    
}
