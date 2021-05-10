/**
 * @name Empty IF block
 * @kind problem
 * @problem.severity warning
 * @id java/example/empty-if-block
 */

import java

from IfStmt ifstmt, Block block
where
  block = ifstmt.getThen() and
  block.getNumStmt() = 0
select ifstmt, "This if-statement is redundant."
