---
layout: post
title: "Pry command cheatsheet"
date: 2013-08-26 00:57
comments: true
categories: [ruby, pry, debugger, debugging]
---

I recently watched Rails Conf 2013 talk on Pry (the awesome alternative Ruby REPL) by Conrad Irwin, one of Pry’s current maintainer. I thought it would be great to have a short summary of all the tricks and tips that he mentioned.

```
ls <Object> --  Show all of the available methods that can be called by an object
_           --  Last output
? <Object>  --  Shows more information (doc) about an object, or method
cat <File>  --  Display the content of a file
_file_      --  Represent the last file Pry touched
wtf?        --  Print the stack trace, same as _ex_.backtrace
$           --  Show source, shortcut for show-source
edit <Method> -- Open file in $EDITOR, change file are auto reloaded
<ctrl+r>    --  Search history
_out_       --  Array of all outputs values, also _in_
cd <var>    --  Step into an object, change the value of self
cd ..       --  Take out of a level
binding.pry --  Breakpoint
edit --ex   --  Edit the file where the last exception was thrown
.<Shell>    --  Runs the <Shell> command
whereami    --  Print the context where the debugger is stopped
;           --  Would mute the return output by Ruby
play -l     --  Execute the line in the current debugging context
```

Here is the [link](https://www.youtube.com/watch?v=jDXsEzOHb2M) to the full presentation.