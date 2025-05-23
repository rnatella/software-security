import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodCall a, MethodCall b, VarAccess arg
where a.getCallee().getName() = "mySource" and
      b.getCallee().getName() = "mySink" and
      arg = b.getAnArgument() and
      localFlow(exprNode(a), exprNode(arg))
select arg, "data flow found"