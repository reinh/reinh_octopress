--- 
layout: post
title:  'Ruby Patterns: Query Method'
date:   2008-07-17
categories: [Patterns, Ruby]
--- 

Today, we will learn how the Query Method pattern handles a set of tensions we often
face while designed object oriented systems.

<!--more-->

What are patterns? Patterns are learnable and reusable answers to common
programming questions. They are decisions made in response to a number of
different concerns (or tensions). A well written pattern resolves each of the
tensions harmoniously and provides a set of repeatable steps for its
reapplication.

Let's look at a situation where various tensions pull us towards the need to
make a harmonious design decision and attempt to derive a pattern for future
use. As we do so, we will try to keep in mind the tensions at play and come up
with steps that can be used to reapply the pattern in the future.

The Query Method pattern answers a particularly common question, "How can I ask
an object for information about itself?" The tensions at play include a desire
to maintain proper encapsulation, a desire to keep code DRY(Don't Repeat
Yourself) and a desire to maintain or improve the readability of the resulting
solution. 

If you don't really care about the discovery process and you want to skip
straight to the pattern itself, it's [at the bottom](#bottom).

## Discovering A Pattern

In a recent blog post on
[the value of learning encapsulation before learning rails](http://www.stephenchu.com/2008/06/learning-encapsulation-should-come.html),
Stephen Chu gives an excellent example of a fragment of ruby code that could be
improved by application of the Query Method pattern. I'll use a slightly
different example:

``` ruby
    puts "#{@post.title} is recent." if @post.published_at < 2.days.ago
```

Let's look at this code in light of some of the different tensions:

### Encapsulation

In his post, Stephen points out that this code breaks encapsulation by yanking
state information out of the object for comparison. The comparison is being
made on post information but it is being made outside the context of the post.
We can change the code a bit to make this more clear:

``` ruby
    class Blog
      def recent_post_list
        @posts.each do |post|
          puts "#{post.title} is recent." if post.published_at < 2.days.ago
        end
      end
    end
```

The blog that is creating this recent post list shouldn't and needn't know how
to determine if a post is recent. This is the post's responsibility. The blog
should simply ask the post if it is recent and let the post make the
calculation. This desire for encapsulation is the first tension.

### Don't Repeat Yourself

This code seems simple enough. It does one thing and appears to do it
efficiently. There is no violation of DRY yet, but it isn't to difficult to
imagine other situations where we might need to know if a post is recent.

Let's say we are generating an HTML page and we want to apply a special class
to recent posts. We will need to duplicate this logic inside that method as
well. What if we later decide that we want posts in the last three days instead
of two? Now we have to find each instance of this code fragment so that we can
change it appropriately. 

What a pain! Clearly this code is not DRY and its maintainability is
compromised as a result. This is the second tension.

### Readability

This code looks pretty readable. `published_at` and `2.days.ago` reveal their
intention quite clearly. If any improvement is to be made, you may think, it
will be incremental and relatively small. Nevertheless, improved readability
means improved maintainability, so it is always worth consideration. This is
the third tension.

## Composing A Pattern

This list of tensions isn't exhaustive but it should be sufficient for us to
begin considering a solution. How can we improve this code in a way that most
effectively addresses all of them?

This is a case where the tensions are not in direct opposition. It should be
pretty easy to come up with a solution. Let's try to formulate such a pattern,
including the steps necessary to reapply it again in the future.

### Encapsulation and DRY

First, we'll start by encapsulating the comparison inside the post object:

``` ruby
    class Post
      def is_published_at_less_than_two_days_ago?
        published_at < 2.days.ago
      end
    end

    puts "#{@post.title} is recent." if @post.is_published_at_less_than_two_days_ago?
```

This resolves the encapsulation tension. By factoring the behavior to a single
location it also resolves the DRY tension. It doesn't do much for our
readability tension, though. Let's see what we can do about that.

### Readability

Patterns can often be improved by the inclusion of smaller, more granular
patterns. In this case, the readability can be improved by providing the method
with an Intention Revealing Selector. An intention revealing selector is, as
the name suggests, one that informs to the user of the intention of the method
rather than its implementation.

Our current selector - and the code it is based on - informs the user of the
method's implementation. It answers the "how" question. An Intention Revealing
Selector answers the more useful "why" question, as in: why does this method
exist, why would I want to use it?

So: why does this method exist? It exists so that the post can be asked if it
is recent or not. An intention revealing name for this selector would use the
word "recent" to answer the "why" question.

The Ruby idiom for a method that is intended to return a boolean value is to
end it with a "?". Let's apply the Intention Revealing Selector pattern by
giving the method an intention revealing name and ending it with a
"?".

``` ruby
    class Post
      def recent?
        published_at < 2.days.ago
      end
    end

    puts "#{post.title} is recent." if post.recent?
```

I think you'll agree that this new method resolves all of the tensions
harmoniously. The behavior is properly encapsulated, it is DRY because it is
defined Once And Only Once, and it is significantly more readable than the
original because it reveals its intention rather than its implementation.

Thus, we can formulate the Query Method Pattern as such:

## Formulating The Query Method Pattern

When you want to query an object about itself in a way that is properly
encapsulated, DRY and more readable, follow these steps:

1. Write a method that performs the query.
2. Put it inside the object that holds the information being queried.
3. Give it an Intention Revealing Selector.

The next time you're faced with this design question, you can apply the Query
Method pattern.

Hopefully this process will help you begin to identify patterns of your own. If
you're interested in learning more about patterns (and you should be), I highly
recommend 
[Smalltalk Best Practice Patterns](http://www.amazon.com/Smalltalk-Best-Practice-Patterns-Kent/dp/013476904X)
by Kent Beck (non-affiliate link). It's worth learning Smalltalk just to be
able to understand the code examples.
