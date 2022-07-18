package it.unina;

import java.io.IOException;

public class TestException {
    public static void main(String[] args) {
        
        TestException x = new TestException();

        try {

            x.testException();
        
        } catch(AnException e) {
            System.out.println(e.getMessage());
        }

        try {

            x.testUnrelated();
        
        } catch(IOException e) {
            System.out.println(e.getMessage());
        }


        System.out.println("Esecuzione terminata");
    }


    public void testException() throws AnException {

        throw new AnException("ERRORE CRITICO!!");
    }

    public void testUnrelated() throws IOException {

        throw new IOException();
    }
}
