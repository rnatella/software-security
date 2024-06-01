import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodAccess a, Argument b
where a.getCallee().getName() = "mySource" and
      b.getCall().getCallee().getName() = "mySink" and
      localFlow(exprNode(a), exprNode(b))
select b, "data flow found"
