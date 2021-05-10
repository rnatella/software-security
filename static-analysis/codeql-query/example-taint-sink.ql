import java

from MethodAccess mb
where mb.getMethod().getName() = "mySource" and
      mb.getMethod().getDeclaringType().getName() = "MyClassA"
select mb,"Sink trovato"