package it.unina;
public class DataFlow {
    int func(int tainted) {
        int x = tainted;
        if (x>0) {
          int y = x;
          callFoo(y);
        } else {
          return x;
        }
        return -1;
      }

    void callFoo(int y) {
        return;
    }
}
