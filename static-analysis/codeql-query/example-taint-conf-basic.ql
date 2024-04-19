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

}

from DataFlow::PathNode source, DataFlow::PathNode sink, MyTaintConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "My taint propagation path"
