import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodAccess m, Method f
where f.getName() = "func" and
      m.getCaller().getName() = "func" and
      m.getMethod().getName() = "callFoo" and
      localFlow( exprNode(f.getAParameter().getAnAccess()),
                 exprNode(m.getArgument(0))
               )
select m, "Sink callFoo()"
