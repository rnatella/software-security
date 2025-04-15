import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from Parameter tainted, VarAccess callFooArg, 
     MethodCall callFoo
where tainted.getCallable().getName() = "func" and
      callFoo.getMethod().getName() = "callFoo" and
      callFoo.getArgument(0) = callFooArg and
      localFlow( parameterNode(tainted),
                 exprNode(callFooArg) )
select tainted, "Data-flow to callFoo()"
