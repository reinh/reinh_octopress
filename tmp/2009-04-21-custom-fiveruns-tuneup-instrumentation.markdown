--- 
title:  Custom FiveRuns TuneUp Instrumentation
date:   04/21/2009
author: reinh
--- 

Implement custom FiveRuns TuneUp instrumentation for your non-ActiveRecord
backend systems.

READMORE

[TuneUp](http://www.fiveruns.com/products/tuneup) is a development performance
monitoring tool from [FiveRuns](http://www.fiveruns.com). It can help you catch
poorly performing actions and queries early and is a great tool to add to your
performance monitoring toolbelt.

TuneUp also makes it very simple to add custom instrumentation to your Rails
app, which came in handy when we needed to report on web service queries made
by our Endeca client.

A brief chat with [Bruce Williams](http://codefluency.com) helped point the way to TuneUp's `FiveRuns::TuneUp.step`, the jumping-off point for its instrumentation of your model, view and controller activity. We were able to write a simple plugin that adds instrumentation to calls made by the [Primedia Endeca gem](http://github.com/primedia/endeca) (a gem used to consume Endeca's RESTful JSON bridge API).

The plugin takes advantage of `alias_method_chain` to add instrumentation to the Endeca query methods. This solution is very clean and is idiomatic to Rails itself as Rails uses `alias_method_chain` to "embellish" many parts of the request response cycle for things like benchmarking and caching, as [David mentions](http://www.loudthinking.com/posts/33-myth-4-rails-is-a-monolith) in a blog post from his Rails Myths series

If you want to look at the code, you can find the plugin at its [github repo](http://github.com/primedia/endeca_tuneup). All the code is in the [`init.rb`](http://github.com/primedia/endeca_tuneup/blob/0e59b0c1f2bdac7f09bb07649b6aab5541aebd7d/init.rb) but I'll reprint it here for convenience. Note that we could have refactored these similar method definitions using metaprogramming techniques but chose not to do so for reasons of simplicity and clarity.

    if defined? FiveRuns && defined? Endeca && defined? Endeca::Document
      # Tuneup instrumentation
      class << Endeca::Document
        def all_with_tuneup(*args)
          Fiveruns::Tuneup.step "#{name}.all", :model do
            all_without_tuneup(*args)
          end
        end
        alias_method_chain :all, :tuneup

        def first_with_tuneup(*args)
          Fiveruns::Tuneup.step "#{name}.first", :model do
            first_without_tuneup(*args)
          end
        end
        alias_method_chain :first, :tuneup

        def by_id_with_tuneup(*args)
          Fiveruns::Tuneup.step "#{name}.by_id", :model do
            by_id_without_tuneup(*args)
          end
        end
        alias_method_chain :by_id, :tuneup
      end
    end
{:lang='ruby'}
