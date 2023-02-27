## Step 6: Relating two variables

In step 4, you wrote a query that finds the **definitions** of functions named `memcpy` in the codebase. Now, we want to find all the **calls** to `memcpy` in the codebase.

One way to do this is to declare two variables: one to represent functions, and one to represent function calls. Then you will have to create a relationship between these variables in the `where` section, so that they are restricted to only functions that are named `memcpy`, and calls to exactly those functions.

### :keyboard: Activity: Find all the calls to `memcpy`

1. Edit the file `6_memcpy_calls.ql`
1. Use the auto-completion feature to find the class that represents function calls, and declare a variable that belongs to this class.
1. Use auto-completion again on your function call variable to guess the predicate that tells us the target function that is being called.
1. Combine this with your logic from step 4 to make sure the target function is named `memcpy`.

**Tip:** You can have a look at the following C++ example. Note that your query will be simpler as you won't need to consider the `declaringType`.

> Finds calls to `std::map<...>::find()`
>
> ```ql
> import cpp
>
> from FunctionCall call, Function fcn
> where
>   call.getTarget() = fcn and
>   fcn.getDeclaringType().getSimpleName() = "map" and
>   fcn.getDeclaringType().getNamespace().getName() = "std" and
>   fcn.hasName("find")
> select call
> ```

**Note:** Once you have good results, you can try to make your query more compact by omitting the intermediate `Function` variable. The 2 queries below are equivalent:

```ql
from Class1 c1, Class2 c2
where
  c1.getClass2() = c2 and
  c2.getProp() = "something"
select c1
```

```ql
from Class1 c1
where c1.getClass2().getProp() = "something"
select c1
```

