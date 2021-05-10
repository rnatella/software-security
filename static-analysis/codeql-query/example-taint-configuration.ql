/** @kind path-problem */
import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph


class MyTaintConfig extends TaintTracking::Configuration {

  MyTaintConfig() { this = "MyTaintConfig" }

  override predicate isSource(DataFlow::Node source) {
	exists(MethodAccess ma | 
		ma.getCallee().getName() = "mySource" and
		ma.getCallee().getDeclaringType().hasQualifiedName("it.unina", "MyClassA") and
		source.asExpr() = ma
	)
  }

  override predicate isSink(DataFlow::Node sink) {
	exists(MethodAccess mb, Expr arg |
		mb.getCallee().getName() = "mySink" and
		mb.getCallee().getDeclaringType().getName() = "MyClassB" and
      		mb.getAnArgument() = arg and
		sink.asExpr() = arg
	)
  }


  override predicate isSanitizer(DataFlow::Node node) {
	exists(MethodAccess mb, Expr arg |
		mb.getCallee().getName() = "matches" and
		mb.getCallee().getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
        mb.getAnArgument() = arg and
		node.asExpr() = arg
	)
  }


  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
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

from DataFlow::PathNode source, DataFlow::PathNode sink, MyTaintConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "My taint propagation path"
