## Step 10: Data flow and taint tracking analysis

Great! You made it to the final step!

In step 9 we found expressions in the source code that are likely to have integers supplied from remote input, because they are being processed with invocations of `ntoh`, `ntohll`, or `ntohs`. These can be considered **sources** of remote input.

In step 6 we found calls to `memcpy`. These calls can be unsafe when their length arguments are controlled by a remote user. Their length arguments can be considered **sinks**: they should not receive user-controlled values without further validation.

Combining these pieces of information,
we know that code is vulnerable if tainted data **flows** from a network integer source to a sink in the length argument of a `memcpy` call.

However, how do we know whether data from a particular source might reach a particular sink? This is known as **data flow** or **taint tracking** analysis. Given the number of results (hundreds of `memcpy` calls and a large number of macro invocations), it would be quite a lot of work to triage all these cases manually.

To make our triaging job easier, we will have CodeQL do this analysis for us.

You will now write a query to track the flow of tainted data from network-controlled integers to the `memcpy` length argument. As a result you will find 9 real vulnerabilities!

To achieve this, we’ll use the CodeQL [taint tracking](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-cpp/) library. This library allows you to describe **sources** and **sinks**, and its predicate `hasFlowPath` holds true when tainted data from a given source flows to a sink.

### :keyboard: Activity: Write a taint tracking query

1. Edit the file `10_taint_tracking.ql` with the template below. Note the annotation `path-problem` and the pattern used in the `select` section. This pattern allows CodeQL to interpret these results as a "path" through the code, and display the path in your IDE.
1. Copy and paste your definition of the `NetworkByteSwap` class from step 9.
1. Write the `isSource` predicate.  This should recognize an expression in an invocation of `ntohl`, `ntohs` or `ntohll`.
    - You already described these expressions in the `NetworkByteSwap` class from step 9. Here we need to check that the source corresponds to a value that belongs to this class.
    - To check if a value belongs to CodeQL class, use the `<value> instanceof <myclass>` construct.
    - Note that the `source` variable is of type `DataFlow::Node`, while your `NetworkByteSwap` class is a subclass of `Expr`, so we cannot just write `source instanceof NetworkByteSwap`. (Try this and the compiler will give you an error.) Use auto-completion on `source` to discover the predicate that lets us view it as an `Expr`.
1. Write the `isSink` predicate: The sink should be the size argument of calls to `memcpy`.
    - Use auto-completion to find the predicate that returns the `n`th argument of a function call.
    - Use the predicate you discovered when writing `isSource` to view the `sink` as an `Expr`.
1. Run your query. Note that the first run will take a little longer than the previous queries, since data flow analysis is more complex.


**Tip:** For a complete example, read [this article](https://securitylab.github.com/research/cve-2018-4259-macos-nfs-vulnerability).

```ql
/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
  // TODO: copy from previous step
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    // TODO
  }
  override predicate isSink(DataFlow::Node sink) {
    // TODO
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"
```

