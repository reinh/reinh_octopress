--- 
title:  Hack && Test && Ship
date:   08/28/2008
author: reinh
---

Introducing a small but important improvement to the `hack && ship` workflow.

READMORE

Devoted reader [Kevin Barnes](http://b.logi.cx/) of OGC pointed out in a
comment to [my last
post](http://reinh.com/blog/2008/08/27/hack-and-and-ship.html) that people make
mistakes. This is news to me. In consideration of this, we have decided that it
is important to test between hacking and shipping to ensure that any merging
that goes on doesn't result in a broken build due to other people's mistakes.

When multiple teams are working on a project, two teams can commit mutually
incompatible changes. These changes may be in different areas and may not cause
actual merge conflicts but may still break the build. Git is dumb. It won't fix
these for you. This is why it's important to run your tests after you merge.

I have thus updated the hack and ship protocol to include [*this important new
step*](http://gist.github.com/7640).

<script src="http://gist.github.com/7640.js"></script>

Running one last test before you merge your changes into master will also be a
final catch-all and allow you to fix any problems before merging back to
master. You can even `git commit --amend` them to prevent anyone else from
seeing your own mistakes.

**NOTE:** `hack && ship` won't ship if there are merge conflicts in the hack
step. `hack` returns a non-zero exit code and the `&&` prevents ship from
running. Likewise, `hack && test && ship` won't ship unless `hack` and `test`
are both successful.
{:.note}

Thanks, Kevin.
