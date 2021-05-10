package it.unina;

import java.util.regex.Pattern;

public final class App2 {
    private App2() {
    }

    public static void main(String[] args) {
        
        MyClassA a = new MyClassA();

        MyClassB b = new MyClassB();

        MyClassC c = new MyClassC();


        String s = a.mySource();

        String r = s + " test";

        c.setVal(r);

        String t = c.getVal();



        boolean match = Pattern.matches("^[a-zA-Z]$", t);

        if(match == false) {

            System.out.println("Taint detected!");
            System.exit(1);
        }


        b.mySink(t);

    }
}
