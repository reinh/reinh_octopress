---
layout: post
title:  "Git Push: Just The Tip"
date:   2008-03-02
categories: [git]
---

Today we delve into the world of `git push`, one of the most often used git
tools. `git push` is typically used to update a remote ref and associated
objects based on a local ref -- in other words, to push your local changes to an
upstream repository -- but you can also use it to create or delete remote
branches and ~~much, much more!~~ actually, that's about it.

<!--more-->

## Just The Tip

The most common use of `git push` is to push your local changes to your public
upstream repository. Assuming that the upstream is a remote named "origin" (the
default remote name if your repository is a clone) and the branch to be updated
to/from is named "master" (the default branch name), this is done with:

    git push origin master

Get used to this. You'll be doing it a lot.

## A Bit Deeper

Git uses the term "refspec" when describing the usage of some of its commands.
A refspec is essentially a name that git can resolve to a commit object. This
can be the name of a branch or an arbitrary "SHA1 expression" such as
`master~4`, among
[others](http://www.kernel.org/pub/software/scm/git/docs/git-rev-parse.html).
Git gives you a lot of ways to refer to a commit but for most purposes you'll
just use the name of a branch with `git push`.

The [kernel.org manpage for git pull](http://www.kernel.org/pub/software/scm/git/docs/git-pull.html)
will rather cryptically tell you that "The canonical format of a
&lt;refspec&gt; parameter is `+?<src>:<dst>`". Most of the time this translates
to `<branch to push from>:<branch to push to>`. The branch to push from and the
colon are optional. If left out, git will push from the local branch to the
remote branch of the same name. If no refspec is used at all, git will push all
"heads" (f.e. branches) on the local to matching heads that exist on the
remote.

In practice, this means that:

* `git push origin` will push changes from all local branches to matching branches the origin remote.
* `git push origin master` will push changes from the local master branch to the remote master branch.
* `git push origin master:staging` will push changes from the local master branch to the remote staging branch _if it exists_.

## Tips and Tricks

### Create a Remote Branch

`git push origin master:refs/heads/staging` will create the branch `staging` in
the origin by copying the local @master@ branch

### Delete a Remote Branch

`git push origin :staging` will delete the branch `staging` from the origin repository.

### Set Up A Branch's Default Remote

You can use git config to assign a default remote to a given branch. This
default remote will be used to push that branch unless otherwise specified.
    
This is already done for you when you use `git clone`, allowing you to use `git
push` without any arguments to push the local master branch to update the
origin repository's master branch.
    
`git config branch.<name>.remote <remote>` can be used to specify this manually.
