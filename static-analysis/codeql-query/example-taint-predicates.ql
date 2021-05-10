import java
import semmle.code.java.dataflow.internal.TaintTrackingUtil
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow

from MethodAccess ma, MethodAccess mb, Expr arg
where ma.getCallee().getName() = "mySource" and
      ma.getCallee().getDeclaringType().hasQualifiedName("it.unina", "MyClassA") and
      mb.getCallee().getName() = "mySink" and
      mb.getCallee().getDeclaringType().getName() = "MyClassB" and
      mb.getAnArgument() = arg and
      localTaint(DataFlow::exprNode(ma), DataFlow::exprNode(arg))
select ma, "Sink mySink(...)"



/*
class MyTaintStep extends AdditionalTaintStep {

  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
      exists(MethodAccess mc, Expr arg | 
        mc.getCallee().getDeclaringType().getName() = "MyClassC" and
        mc.getCallee().getName() = "setVal" and
        mc.getAnArgument() = arg and
        node1.asExpr() = arg and
        node2.asExpr() = mc.getQualifier()
      ) or
      exists(MethodAccess mc | 
        mc.getCallee().getDeclaringType().getName() = "MyClassC" and
        mc.getCallee().getName() = "getVal" and
        node1.asExpr() = mc.getQualifier() and
        node2.asExpr() = mc.getParent()
      )
  }
}
*/

/*
from MethodAccess mc, Expr arg
where   mc.getCallee().getDeclaringType().getName() = "MyClassC" and
        mc.getCallee().getName() = "setVal" and
        mc.getAnArgument() = arg 
select  mc.getQualifier(),arg
*/

/*
from MethodAccess mc 
where  mc.getCallee().getDeclaringType().getName() = "MyClassC" and
        mc.getCallee().getName() = "getVal"
select mc.getQualifier(),mc.getParent()
*/