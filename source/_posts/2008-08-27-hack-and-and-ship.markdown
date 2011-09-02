--- 
layout: post
title:  Hack && Ship
date:   2008-08-27
--- 

When the [OG Consulting](http://ogtastic.com/) [guys](http://b.logi.cx/) were
down at [Hashrocket](http://hashrocket.com/) working on our latest 3-2-1, they
introduced us to a pair of bash scripts called *hack* and *ship* that they use
to streamline their everyday git workflow. They're so useful that we adopted
them immediately and we've been using them religiously ever since. I estimate
that these little scripts save me about an hour a day and, what's more, they
make it easy to follow the *commit early, commit often* mindset that's so
useful to the agile process.

<!--more-->

## Simple Software Process

Here's our typical workflow (before hack and ship):

1. Start a feature in "Pivotal Tracker":https://www.pivotaltracker.com
2. Checkout a working branch for this feature
3. Write a test
4. Write an implementation to make the test pass
5. Repeat 3 and 4 until the feature is complete
5. Commit changes to git with a "useful commit message":http://www.tpope.net/node/106
5. Checkout the master branch
5. Update the master branch
6. Checkout the working branch
7. Rebase the master branch into the working branch
8. Checkout the master branch
9. Merge the working branch into the master branch
10. Push the changes to the origin repository (usually on "github":https://github.com/)
11. Repeat.

This is pretty simple (if a bit longwinded). We each probably do this dozens of times a day. Could it be simpler? You bet!


## Simplified Software Process

I'd like to introduce you to the Simplified Software Process. While it may not
be a very good process, it does have one thing going for it: it's *simple*. We
like simple. So when we saw Rick Bradley's super simple bash scripts for
automating these common git tasks, we jumped on them. These scripts are
designed to work with the basic git workflow we outlined above. And they have
awesome names.

Here's [*hack*](gist.github.com/7641).

{% gist 7641 %}

And [*ship*](http://gist.github.com/7642).

{% gist 7642 %}

Now our process looks like this:

1. Start a feature in Pivotal Tracker
2. Checkout a working branch for this feature
3. Write a test
4. Write an implementation to make the test pass
5. Repeat 3 and 4 until the feature is complete
6. Commit changes to git with a useful commit message
7. <code>hack</code>
8. <code>ship</code>
9. Repeat.

We even wrote ourselves [*a little alias*](http://gist.github.com/7640) to make this even easier:

{% gist 7640 %}

Which brings the workflow down to three easy steps:

1. Test
2. Implement
3. <code>ssp</code>

Combine this with a Continuous Integration build like
[cruisecontrol.rb](http://cruisecontrolrb.thoughtworks.com/) and a deployment
to a staging server that takes less than a minute - we love
[EngineYard](http://engineyard.com/) - and you have the perfect recipe for
agile, iterative, test-driven, micro-release oriented development. I've never
been happier with my development process.
