--- 
layout: post
title:  "A Git Workflow for Agile Teams"
date:   2009-03-02
categories: [git, Agile]
--- 

An efficient workflow for developers in Agile teams that handles features and
bugs while keeping a clean and sane history.

At [Hashrocket](http://hashrocket.com) we use git both internally and in our
Agile mentoring and training. Git gives us the flexibility to design a version
control workflow that meets the needs of either a fully Agile team or a team
that is transitioning towards an Agile process.

<!--more-->

There are many usable git workflows. Indeed, git is really "a tool for
designing VCS workflows" rather than a Version Control System itself. Or, as
Linus would say, git is just a stupid content tracker.

This is by no means a normative document or my attempt to define The One True
Workflow. I have found this workflow to be productive and relatively painless,
especially for teams that are still learning and transitioning towards a more
Agile process. I invite you to comment below and describe the git workflow that
works best for you.

Credits
-------

Anyone interested in using git in an Agile environment should read Josh
Susser's <cite>Agile Git and the Story Branch Pattern</cite>. This workflow
is based largely on his.

The process of squashing commits into more atomic and incremental units has
been described by Justin Reagor in <cite>A "Squash" WorkFlow in Git</cite>.
Justin's post also references a `git rebase -i` walkthrough by MadCoder
that provides a good explanation the interactive rebase process.

Thanks also to [Rick Bradley](http://www.rickbradley.com/) of [OG Consulting](http://www.ogtastic.com/)
and [Josh Susser](http://blog.hasmanythrough.com/) of [Pivotal Labs](http://pivotallabs.com)
for many fruitful and often hilarious discussions about git, Agile and ponies.

Feature Development
-------------------

Our git feature development workflow consists of these steps:

1. Pull to update your local master
2. Check out a feature branch
3. Do work in your feature branch, committing early and often
4. Rebase frequently to incorporate upstream changes
5. Interactive rebase (squash) your commits
6. Merge your changes with master
7. Push your changes to the upstream

First, and while in your master branch (`git checkout master`), pull in the
most recent changes:

    git pull origin master

This should never create a merge commit because we are never working directly
in master.

*NB:* Whenever you perform a pull, merge or rebase, make sure that you
run tests directly afterwards. Git may not show any conflicts but that doesn't
mean that two changes are compatible. Also run tests before you commit (of
course).

We begin with the topmost available story in [Pivotal Tracker](http://pivotaltracker.com).
Let's say that it's _#3275: User Can Add A
Comment To a Post_. First, check out a feature branch named with the story id
and a short, descriptive title:

    git checkout -b 3275-add-commenting

The id allows us to easily track this branch back to the story that spawned it.
The title is there to give us humans a little hint as to what's in it. Do some
work on this branch, committing early and often (for instance, whenever your
tests pass). Rebase against the upstream frequently to prevent your branch from
diverging significantly:

    git fetch origin master
    git rebase origin/master


*NB:* This is often done by checking master out and pulling, but this method
requires extra steps:

    git checkout master
    git pull
    git checkout 3275-add-commenting
    git rebase master

Once work on the feature is complete, you will have a branch with a lot of
small commits like "adding a model and a migration", "adding a controller and
some views", "oh crap - adding tests" and so on. This is useful while
developing but larger, incremental commits are more easier to maintain. We will
use an interactive rebase to squash them together. Also, squashing
these commits together will allow us to pretend that we wrote the tests
first&hellip;

We want the rebase to affect only the commits we've made to this branch, not
the commits that exist on the upstream. To ensure that we only deal with the
"local" commits, use:

    git rebase -i origin/master

Git will display an editor window with a list of the commits to be modified,
something like:

    pick 3dcd585 Adding Comment model, migrations, spec
    pick 9f5c362 Adding Comment controller, helper, spec
    pick dcd4813 Adding Comment relationship with Post
    pick 977a754 Comment belongs to a User
    pick 9ea48e3 Comment form on Post show page

Now we tell git what we to do. Change these lines to:

    pick 3dcd585 Adding Comment model, migrations, spec
    squash 9f5c362 Adding Comment controller, helper, spec
    squash dcd4813 Adding Comment relationship with Post
    squash 977a754 Comment belongs to a User
    squash 9ea48e3 Comment form on Post show page

Save and close the file. This will squash these commits together into one
commit and present us with a new editor window where we can give the new commit
a message. We'll use the story id and title for the subject and list the
original commit messages in the body:

    [#3275] User Can Add A Comment To a Post

    * Adding Comment model, migrations, spec
    * Adding Comment controller, helper, spec
    * Adding Comment relationship with Post
    * Comment belongs to a User
    * Comment form on Post show page

This also follows Tim Pope's [git commit message best
practices](http://www.tpope.net/node/106). Now, save and close your editor.
This commit is now ready to be merged back into master. First rebase against
any recent changes in the upstream. Then merge your changes back into master:

    git checkout master
    git merge 3275-add-commenting

And finally, push your changes to the upstream:

    git push origin master

Bug Fixes
---------

Bugfixes will use the same workflow as feature work. Name your bugfix branch
after the bug id and give it a descriptive name. Prefix the branch name with
"bug" to help you keep track of them, for instance:
`bug-3845-empty-comments-allowed`.

Do work in your bugfix branch, committing early and often. Rebase frequently
against the upstream and again when you are finished. Then, use an interactive
rebase to squash *all* the commits together. Use the bug id and title for the
subject of the new commit. Include "BUG" or "BUGFIX" to make these commits
easier to identify. For instance:

    [#3278] BUGFIX: Empty Comments Should Not Be Allowed

*NB:* With a bugfix, squash the commits down into one and exactly one commit
that completely represents that bugfix. Half of a bugfix is useless.

QA Branch Management
--------------------

In a truly Agile process, as Josh Susser explained to me, you simply deploy
directly from your latest "green" build. While this may seem impossible, there
are real world examples of the viability of Continuous Deployment.

For most of the teams we train, this sort of extreme agility is a goal rather
than a way of life. They are transitioning towards a fully Agile process from a
more rigorous one and often have a significant investment in Quality Assurance.
For these teams, I recommend a compromise solution: Use a remote QA branch that
is fast-forward merged from the latest "green" (all CI tests pass) master build
for QA deployments.

If you don't already have a QA branch, create one from the current master
(assuming it's green) and then push it to your git host:

    git checkout -b qa
    git push origin qa:refs/heads/qa

To update an existing QA branch with the latest changes from master, do this:

    git checkout qa
    git merge master
    git push origin qa

Ensure that the master branch is green when you merge. Also ensure that this
merge is always a Fast Forward merge. If it is not, it means that commits have
been made in the QA branch that are not in the master branch. QA should be
merged into from master only, never worked on directly.

Production Tagging
------------------

While an Agile team will be deploying continuously, most teams will require a
more rigorous vetting process before a build is deployed to production. Tags
provide a simple way for QA to vet a particular build.

Once QA has signed off on a build as ready for production, a tag should be made
and deployed. In git, a tag can be created with `git tag <name>`. It is
important that tag naming is consistent and it is useful if they sort in a
meaningful way (latest last, for instance). Two good options are a timestamp or
product version. Use whichever is more meaningful to your team.

The process of creating a timestamped production tag can be automated with a
simple script or a git alias like this one:

    git config alias.datetag '!git tag `date "+%Y%m%d%H%M"`'

With this alias, `git datetag` will create a new tag from `HEAD` with the
current timestamp. You will want to be in the QA branch. If the QA branch has
moved beyond the last commit vetted by your QA team, be sure to checkout that
commit first.
