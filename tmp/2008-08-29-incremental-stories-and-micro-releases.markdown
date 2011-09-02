--- 
title:  "Incremental Stories and Micro-Releases"
date:   08/29/2008
author: reinh
--- 

The most important idea in Agile is to "deliver something of value every week". *Micro-releases* are here to help us do just that.

[Agile estimating and
planning](http://www.amazon.com/Agile-Estimating-Planning-Robert-Martin/dp/0131479415)
is difficult. One of the practices that we are learning and adopting at
Hashrocket that has truly improved our ability to ship is
[*micro-releases*](http://www.dtsato.com/blog/2008/08/26/agile-2008-estimating-considered-wasteful-introducing-micro-releases/).
The idea, championed by author Joshua Kerievsky, is that constantly planning
and shipping small, feature based incremental releases within the iterative
cycle drives the delivery of tangible business value. In other words, the most
important stuff gets shipped sooner.

Committing to micro-releases ensures that we are constantly working on
delivering the highest priority features that represent real business value in
an agile, incremental way. Complex stories that won't fit into a micro-release
cycle are broken down into stories that deliver core value and supporting
stories that can be deferred to a later iteration.

# A Complex Story

    As A User I Want To View A List Of Projects
    So that I can find a project that interests me

    Acceptance:

    * All projects shown in list
    * List is paginated
    * List sorts by age by default
    * List is sortable by the following criteria
        * Age
        * Owner
    * List is filterable by the following criteria
        * Status
        * Category

    Cost: 4 Points

This is a reasonably good story. It is clear, concise and deliverable. Its
acceptance criteria are testable. It adds real business value. A short time ago
ago I would have been quite happy to write stories just like this. That's not
the case today.

Now that our development process is becoming more geared towards focused
micro-releases, the value of incremental stories is becoming exceedingly clear.
Writing incremental stories allows us to break complex stories apart into a
first increment focused on delivering core value and a set of secondary stories
that can be added as later increments to deliver supplementary value.

# A Simple Primary Story

    As A User I Want To View A List Of Projects
    So that I can find a project that interests me

    #1

    Acceptance:

    * All projects shown in list
    * List is paginated
    * List is sorted by age

    Cost: 1 Point

This story is smaller and simpler but it delivers most of the value of the
original complex story. Users can browse a list and find projects. Additional
value is certainly provided by selecting sort and filtering criteria. But
that's the point: these provide *additional* value. The simple primary story is
an increment that delivers on the core value behind this feature: users want to
discover projects. It's the minimum functionality needed to start using the
feature.

# Some Simple Supplementary Stories

    As A User I Want To Sort The Project List
    So that I can better discover projects based on certain criteria

    #1.1

    Requires:

    * A list of projects (#1)

    Acceptance:

    * List is sortable by the following criteria
        * Age
        * Owner

    Cost: 1 Point
^

    As A User I Want To Filter The Project List
    So that I can browse only projects that match a given criterion

    #1.2

    Requires:

    * A list of projects (#1)

    Acceptance:

    * List is filterable by the following criteria
        * Status
        * Category

    Cost: 2 Points

One interesting and important observation is that the primary story is a one
point story while the secondary stories total to three points. This means that
these secondary stories represent fully three fourths of the original value of
the complex story. In other words, shipping on the core value of the feature
becomes much, much easier once it's broken up into increments.

# Ship Leaner Features, Sooner

Breaking complex stories into simpler incremental stories becomes especially
important in situations where your iterations are extremely time-sensitive.
This is precisely the case in our [3-2-1
Launch](http://www.hashrocket.com/products) projects. Breaking stories into
increments allows us to deliver more of the application's core value sooner. It
also helps clients make real-time decisions about the importance of the primary
and secondary value stories separately. Once they can get their hands on the
core functionality they often re-prioritize the secondary stories more
effectively.

In the case of this particular story, once the basic list and pagination were
out there - and once project search (another core value feature) was
implemented - it became clear that the secondary project listing stories only
duplicated functionality. These secondary stories are cooling off in the icebox
as we speak. Meanwhile, we shipped a feature four times leaner and four times
sooner.
