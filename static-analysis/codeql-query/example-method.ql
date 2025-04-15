import java

from   MethodCall secret_call
where  secret_call.getMethod()
                  .getName() = "getSecret"
select secret_call, "Found call to getSecret()"
