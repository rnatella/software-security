import java
import semmle.code.java.dataflow.DataFlow::DataFlow


from MethodAccess secret, MethodAccess print
where secret.getMethod().getName() = "getSecret" and
      secret.getMethod().getDeclaringType().hasQualifiedName("it.unina", "DataFlow2") and
      print.getMethod().getName() = "println" and
      print.getMethod().getDeclaringType().hasQualifiedName("java.io","PrintStream") and
      localFlow( exprNode(secret),
                 exprNode(print.getArgument(0).getAChildExpr())
               )
select print, "Leaked secret"
