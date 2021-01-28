# zig-usdt
User Statically-Defined Tracing, for zig

# usage: 
1. download tracing.zig
2. import tracing.zig
```
const Tracing = @import("tracing.zig");
```

3. use   
```  
  Tracing.SDT("provider", "name", .{arg1, arg2, ...});
 ```  
 or
 
 ```
  Tracing.SDT_DEFINE_SEMAPHORE("provider", "name");
  if(Tracing.SDT_ENABLED("provider", "name")){
       Tracing.SDT_WITH_SEMAPHORE("provi", "a1", .{arg1, arg2, ...});
  
  }
  
 
 ```
 


