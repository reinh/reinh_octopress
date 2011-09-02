---
layout: post
title:  Custom Textile Tags For Great Justice
date:   2008-04-09
---

Taking some inspiration (and code) from the quirky but lovable why's original
post on [adding yer custom blocks](http://redhanded.hobix.com/inspect/usingRedcloth3.html) to RedCloth and
the inimitable Geoff Grosenbach's foray into the world of 
[custom textile figure tags](http://nubyonrails.com/articles/about-this-blog-custom-textile),
we're going to implement a customer textile tag for our blog's thumbnail
images.

<!--more-->

RedCloth's textile implementation uses some simple metaprogramming to create
its own tags, which allows you to (more or less) easily create new tags to suit
your own needs. The basic formula is: write a `textile_#{ tag }` method, where
`tag` is the name of the tag you want to create. This method takes four
arguments, tag, atts, cite and content, which are parsed from the textile by
the RedCloth engine.

For our purposes, we're only concerned with content and atts, so I'll leave the
rest as an exercise for the gentle reader. The html we're trying to create
looks like this:

``` ruby
    <div class="img" id="figure-1-1">
      <a class="fig" href="/images/image.jpb">
        <img src="/images/thumbs/image.jpg" alt="Figure 1.1" />
      </a>
      <p>Figure 1.1</p>
    </div>
```

The tag we want to use to create it looks like this:

    fig. 1.1 | image.jpg

That's quite a bit shorter and more elegant. Jumping right in to the good
stuff, the method definition for our new tag looks like this:

``` ruby
    def textile_fig(tag, atts, cite, content)
      span_class = "img "
      if atts =~ /class="([^\"]+)"/
        span_class += $1
      end
      (figure_number, img_url) = content.split("|").map { |w| w.strip }
      figure_name = "Figure #{figure_number}"
      figure_id = "figure-#{figure_number}".tr(".", "-")

      <<-TAG
      <div class="#{span_class}" id="#{figure_id}">
        <a class="fig" href="/images/#{img_url}">
          <img src="/images/thumbs/#{img_url}" alt="#{figure_name}" />
        </a>
        <p>#{figure_name}</p>
      </div>
      TAG
    end
```

Let's break that down.

``` ruby
    span_class = "img "
    if atts =~ /class="([^\"]+)"/
      span_class += $1
    end
```

This adds any classes in atts (in the form of `class="foo"`) to the base class,
img.

``` ruby
    (figure_number, img_url) = content.split("|").map { |w| w.strip }
    figure_name = "Figure #{figure_number}"
    figure_id = "figure-#{figure_number}".tr(".", "-")
```

This breaks `fig 1.1 | image.jpg` down into two parts by splitting on the `|`
and then normalizes them a bit to be used later.

Finally, the relevant parts are jammed into the html prototype and spit back as
the method's return value for insertion into your textile document (and for
great justice, of course).
