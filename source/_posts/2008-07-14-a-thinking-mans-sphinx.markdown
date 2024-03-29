--- 
layout: post
title:  "A Thinking Man's Sphinx"
date:   2008-07-14
---

Today, we'll explore the differences between UltraSphinx and ThinkingSphinx and
why we chose to switch to ThinkingSphinx.

<!--more-->

We've recently switched a number of projects to
[ThinkingSphinx](http://ts.freelancing-gods.com/) here at
[Hashrocket](http://www.hashrocket.com). These projects were originally using
SOLR or [UltraSphinx](http://blog.evanweaver.com/files/doc/fauna/ultrasphinx/files/README.html).
UltraSphinx is written by [Evan Weaver](http://blog.evanweaver.com/).
ThinkingSphinx is written by [Pat Allan](http://freelancing-gods.com/). They
have some similarities: both use Sphinx (obviously); both are based on the
underlying Ruby API for Sphinx, [Riddle](http://riddle.freelancing-gods.com/)
(also by Pat Allan); both have excellent documentation and well-written
tutorials. The similarities pretty much end there, however, and the differences
are far more interesting.

## Basic Sphinx Configuration

Both plugins help you generate a sphinx.conf file for your each of your rails
environments, but they do it in drastically different ways. ThinkingSphinx lets
you use a configuration format you are already used to at the expense of
reduced configuration options. UltraSphinx is more flexible but less Rubyish.

### UltraSphinx

UltraSphinx generates the sphinx.conf file from a base configuration file. This
base file uses the sphinx configuration syntax, passing it through ERB for some
DRYness. A base file can be specified per-environment. It puts all of its
configuration information in `RAILS_ROOT/config/ultrasphinx/`. This provides
fine-grained - if rather tediously verbose - control over the multitude of
Sphinx configuration options.

### ThinkingSphinx

ThinkingSphinx uses a YAML configuration file that it locates at
`RAILS_ROOT/config/sphinx.yml`. It accepts a YAML hash of configuration
settings. These settings allow you to specify most of the basic Sphinx
configuration options with ease but you may be out of luck if the option you
need isn't available.

## Basic Index Configuration

Let's start with a basic example of a sphinx index declaration. Keep in mind
that your indexes will likely be significantly more complex in the real world.

### UltraSphinx

UltraSphinx uses a declarative `is_indexed` statement in the model that feels
vaguely similar in style to an association or named scope declaration. This is
the usage example given in the
[README](http://blog.evanweaver.com/files/doc/fauna/ultrasphinx/files/README.html):

``` ruby
    class Post
      is_indexed :fields => ['created_at', 'title', 'body']
    end
```

This seems simple enough for such a simple case. We'll see how it looks for
less trivial cases.

### ThinkingSphinx

ThinkingSphinx, on the other hand, uses a `define_index` block in the model to
allow the individual index configuration options to be stated declaratively.
The canonical example from UltraSphinx would look like this in ThinkingSphinx:

``` ruby
    class Post
      define_index do
        indexes created_at, title, body
      end
    end
```

The first thing you may notice is that the same index configuration is three
lines in ThinkingSphinx instead of one in UltraSphinx. If you look closely,
you'll also see that the field names are not symbols as you might expect but
method calls. We'll get into why this is in a moment.

## Real World Index Configuration

Your real world applications are likely to require a significantly more complex
index declaration to meet the search needs of your users. Let's look at an
example of such a real world Sphinx index declaration.

### UltraSphinx

Here's an example of a more realistic UltraSphinx index configuration. This is
the type of configuration you're likely to use on any non-trivial project.

``` ruby
    class Post < ActiveRecord::Base
      belongs_to :blog
      belongs_to :category

      is_indexed :conditions => "posts.state = 'published'",
                 :fields     => [{:field => 'title', :sortable => true},
                                 {:field => 'body'},
                                 {:field => 'cached_tag_list'}],
                 :include    => [{:association_name => "blog",
                                  :field            => "title",
                                  :as               => "blog",
                                  :sortable         =>  true},
                                 {:association_name => "blog",
                                  :field            => "description",
                                  :as               => "blog_description"},
                                 {:association_name => "category",
                                  :field            => "title",
                                  :as               => "category",
                                  :sortable         =>  true}]
    end
```

This is about as pretty as it's going to get - and that's not very pretty.
Large, deeply nested hashes of arrays of hashes are not easily scannable and
will become exponentially difficult to maintain as their size and complexity
increases.

### ThinkingSphinx

Let's look at that same example translated to ThinkingSphinx.

``` ruby
    class Post < ActiveRecord::Base
      belongs_to :blog
      belongs_to :category

      define_index do
        indexes title, :sortable => true
        indexes body, cached_tag_list

        indexes blog.description, :as => :blog_description
        indexes blog.title,       :as => :blog,     :sortable => true
        indexes category.title,   :as => :category, :sortable => true

        where "posts.state = 'published'"
      end
    end
```

Not only did the number of lines decrease, the readability is far greater. I
know which one I'd rather write. More importantly, I know which one I'd rather
have to maintain weeks or months downline when it needs to be modified.

Notice that the declarations use methods rather than symbols. ThinkingSphinx
uses some interesting metaprogramming to allow this. Notice also that indexed
fields on associations are specified in the same way you would access that
field. Simple.

## Sphinx Rake Tasks

Both UltraSphinx and ThinkingSphinx provide a number of rake tasks for common
sphinx tasks such as generating the configuration file; generating the index;
and starting, stopping, and restarting the searchd daemon. Both provide
abbreviations for the more common task, such as `ts:in` for
`thinking_sphinx:index` or `us:conf` for `ultrasphinx:configure`.

## Deployment and Configuration Management

Both UltraSphinx and ThinkingSphinx are pretty simple to deploy. You should
symlink your configuration file from a shared location into your app's path
after deployment, just as you probably do for your `database.yml` file. You
will probably want to run the configuration task after you update the code.
Here, for instance, is a Capistrano task to run your ThinkingSphinx
configuration task:

``` ruby
    namespace :sphinx do
      desc "Generate the ThinkingSphinx configuration file"
      task :configure do
        run "cd #{release_path} && rake thinking_sphinx:configure"
      end
    end
```

You'll want to have this task run after each deployment:

``` ruby
    after "deploy:update_code", "sphinx:configure"
```

You can create other tasks relatively easily for reindexing and managing the
searchd daemon. I found a good guide to
[deploying a rails app with ThinkingSphinx](http://www.updrift.com/article/deploying-a-rails-app-with-thinking-sphinx)
linked from Pat Allan's blog. I found a useful set of
[UltraSphinx capistrano tasks](http://github.com/ruberion/ruberion_server_tools/tree/master/recipes/tasks/ultrasphinx.rb)
in Ruberion's server tools plugin on Github. If you chose to host with
[EngineYard](http://www.engineyard.com/), they can manage either configuration
for you with their pre-baked builds and deploy tasks.

## Real World Experience

We ran into a number of issues when setting up UltraSphinx:

* UltraSphinx loads your models without loading the full rails environment. This means that if
  your models depend on any of your lib files or any gems frozen in vendor/gems, you will have to
  require all of these files explicitly in each model. This is a pain.

* The fundamentally sound design and code of UltraSphinx are somewhat undermined by poorly
  implemented exception handling. This means that while most of the time things work swimmingly,
  when they fail you're really sunk! The errors that you receive are often useless in diagnosing
  the actual problem.

* We had bugs in our index that only existed on our staging and production slices. These caused
  page counts to be incorrect and nil records to be returned in certain cases. In certain cases it
  also caused 5xx errors.
  
### Moving To ThinkingSphinx

After another Hashrocket team had success moving their project from SOLR to
ThinkingSphinx, I decided to move our project as well. Moving to ThinkingSphinx
proved to be a relatively painless experience. The process was essentially
five-fold:

* Uninstall UltraSphinx and install ThinkingSphinx.
* Translate your `is_indexed` declaration into a @define_index@ block and change your search actions to use the ThinkingSphinx API.
* Rewrite your deployment tasks to run the ThinkingSphinx rake tasks.
* Stop searchd and then run your new configure, index and startd start tasks.
* PROFIT!
