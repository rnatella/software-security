import java

from TryStmt trystmt, CatchClause catch
where catch = trystmt.getACatchClause() and
      catch.getVariable().getType().getName() = "AnException"
      select catch,"Catch block found!"

// Alternative "where" condition:
//      catch.getACaughtType().getName() = "AnException"
