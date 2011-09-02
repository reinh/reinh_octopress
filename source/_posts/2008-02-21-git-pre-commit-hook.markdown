---
layout: post
title:  "Simple Git Continuous Integration"
date:   2008-02-12
---

The easiest way to prevent a broken build is to run your tests before you
commit. This can be done with a simple git hook. Preventing your developers
(and yourself) from breaking the build is as simple as putting this in your
.git/hooks/pre-commit and making it executable: `chmod +x
.git/hooks/pre-commit`.

<!--more-->

``` sh
    #!/bin/sh
    rake spec 2> /dev/null
```

This will stop the commit if the specs don’t pass.

This isn’t a replacement for a more robust CI system but it does make it a lot
harder to do something stupid. Redirecting `STDERR` to `/dev/null` is optional but
recommended since the `STDERR` output of failing specs isn’t useful. It you use
Test::Unit instead of RSpec (for shame), use rake test instead. Likewise,
anything that returns proper error codes (0 for success, > 0 for failure) can
be used.

This is mainly useful if your specs take under a minute to run, otherwise it
becomes tedious. If you have long-running specs, I suggest using a special task
that runs an abridged set of core specs instead.
