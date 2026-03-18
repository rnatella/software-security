/** 
 * @kind path-problem
 * @id java/my-taint-propagation-with-barrier
 * @precision medium
 * @security-severity 9.9
 * @problem.severity error
**/

import java
import semmle.code.java.dataflow.TaintTracking

module MyTaintConfig implements DataFlow::ConfigSig {

	predicate isSource(DataFlow::Node source) {
		exists(MethodCall ma | 
			source.asExpr() = ma and
			ma.getMethod().getName() = "mySource" and
			ma.getMethod().getDeclaringType().getName() = "MyClassA"
		)
	}

	predicate isSink(DataFlow::Node sink) {
		exists(VarAccess arg, MethodCall mb |
			sink.asExpr() = arg and
			arg = mb.getAnArgument() and
			mb.getMethod().getName() = "mySink" and
			mb.getMethod().getDeclaringType().getName() = "MyClassB"
		)
	}

	predicate isBarrier(DataFlow::Node node) {
		exists(VarAccess arg, MethodCall mb |
			node.asExpr() = arg and
			arg = mb.getAnArgument() and
			mb.getMethod().getName() = "matches" and
			mb.getMethod().getDeclaringType().hasQualifiedName("java.util.regex", "Pattern")
		)
	}

}

module MyTaint = TaintTracking::Global<MyTaintConfig>;

import MyTaint::PathGraph

from MyTaint::PathNode source, MyTaint::PathNode sink
where MyTaint::flowPath(source, sink) 
select sink.getNode(), source, sink, "Taint propagation found"
