import java
import semmle.code.java.dataflow.DataFlow::DataFlow
import semmle.code.java.dataflow.TaintTracking

from MethodCall a, MethodCall b, VarAccess arg
where a.getCallee().getName() = "mySource" and
      b.getCallee().getName() = "mySink" and
      arg = b.getAnArgument() and
      TaintTracking::localTaint(exprNode(a), exprNode(arg))
select arg, "data flow found"