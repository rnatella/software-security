package it.unina;

import java.util.regex.Pattern;

/**
 * Hello world!
 */
public final class App {
    private App() {
    }

    public static void main(String[] args) {

        MyClassA a = new MyClassA();

        MyClassB b = new MyClassB();


        String s = a.mySource();

        String r = s;



        boolean match = Pattern.matches("^[a-zA-Z]$", r);

        if(match == false) {

            System.out.println("Taint detected!");
            System.exit(1);
        }


        b.mySink(r);

    }

}
