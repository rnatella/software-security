package it.unina;

public class EmptyBlock {

    int write(int[] buf, int size, int loc, int val) {

        if (loc >= size) {
           // return -1;
        }
    
        buf[loc] = val;
    
        return 0;
    }
    
}
