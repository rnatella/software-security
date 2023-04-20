import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodAccess a, MethodAccess b
where a.getCallee().getName() = "mySource" and
      b.getCallee().getName() = "mySink" and
      localFlow(exprNode(a), exprNode(b.getAnArgument()))
select b, "data flow found"
