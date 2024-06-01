import java

from TryStmt trystmt
where trystmt.getACatchClause().getVariable().getType().getName() = "AnException"
select trystmt,"Try-catch block found!"

// Alternative "where" condition:
//   trystmt.getACatchClause().getACaughtType().getName() = "AnException"
