/**
 *  @name              Empty blocks
 *  @description       Questa query rileva blocchi senza istruzioni
 *  @id                java/empty-blocks
 *  @kind              problem
 *  @precision         medium
 *  @problem.severity  warning
 *  @security-severity 3.0
 *  @tags              maintainability
**/


import java

from BlockStmt block
where block.getNumStmt() = 0
select block, "This block-statement is redundant."
