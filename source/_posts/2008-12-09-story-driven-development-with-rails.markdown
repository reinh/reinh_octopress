--- 
layout: post
title:  "Story Driven Development With&nbsp;Rails"
date:   2008-09-12
--- 

As a follow up on [writing incremental stories](http://reinh.com/blog/2008/08/29/incremental-stories-and-micro-releases.html),
we're going to take the first story and walk through a behavior driven
development process to implement it in a simple Rails application.

We will focus on making small, iterative changes and following a strict
test-first philosophy where we write granular unit tests and implement them
with just enough code to make them pass.

<!--more-->

Let's review our first story:

{% codeblock Story #1 %}
As A User I Want To View A List Of Projects
So that I can find a project that interests me

Acceptance:

* All projects shown in list
* List is paginated
* List is sorted by age

Cost: 1 Point
{% endcodeblock %}

At this point, let's assume that this story is on top of our current iteration.
First, we'll need to review the story for any missing information and
communicate with the client to clear up any questions. Keep in mind that a
story is just a way to capture a conversation about a feature. It is not set in
stone. After talking to the client, we find that we will need to display a
project's author name and title and that the title will need to link to that
project's page. Let's update the story appropriately.

{% codeblock Story #1 %}
As A User I Want To View A List Of Projects
So that I can find a project that interests me

Acceptance:

* All projects shown in list
* Show title for each project
* Show author name for each project
* Project title links to the project's page
* List is paginated
* List is sorted by project age

Cost: 1 Point
{% endcodeblock %}

Now that the story is complete, deliverable and acceptable, we can begin work
on the new feature. A implementation plan should be forming in your head. Now
is the time to divide the work into testable units. In our case we already have
a Project model with the requisite fields (let's say) so our work will focus on
the controller and view.

## Test All The F---ing Time

Client sign-off on well written acceptance tests means that the specifications
you write and the feature that is implemented as a result will be more closely
in line with the client's expectations. This minimizes the kind of impedance
mismatch between expectation and execution that so often plagues a project with
poor client communication and a disorganized process.

Now it's time to take our acceptance tests and use them to drive our iterative,
test-driven development process. Let's take it from the top.

### All Projects Shown in List

Let's start with the controller. A list of projects needs an index action.
Starting at the top, we will need to load all of the projects. Let's write a
test for this:

{% codeblock spec/controllers/projects_controller_spec.rb lang:ruby %}
describe ProjectsController do
  describe "getting a list of products" do
    it "loads all the projects" do
      projects = [mock_model(Project)]
      Project.stub!(:all).and_return(projects)

      get 'index'

      assigns(:projects).should == projects
    end
  end
end
{% endcodeblock %}

*Note:* Stubbing the call to `Project.all` has the immediate benefit of
eliminating the database from our test but is potentially more brittle since we
cannot be sure that this interface point to our Project model will not need to
change in the future.

On a side note, I tend to view controller tests as integration-level tests
rather than unit tests. As such, I usually do write tests that touch the
database since these are often less brittle. If you write tests that touch the
database, ActiveRecord factories such as [Factory Girl](http://giantrobots.thoughtbot.com/2008/6/6/waiting-for-a-factory-girl)
or [object daddy](http://b.logi.cx/2007/11/26/object-daddy) are useful for
populating the database with valid records in known states.

Now we can write the implementation:

{% codeblock app/controllers/projects_controller.rb lang:ruby %}
class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end
end
{% endcodeblock %}

Then we have to display a list of projects. We'll write a view test to cover this:

{% codeblock spec/views/projects/index.html.erb_spec.rb lang:ruby %}
describe "/projects/index" do
  before(:each) do
    @project = mock_model(Project)
    @projects = [@project]
    assigns[:projects] = @projects
    render 'projects/index'
  end
  
  it "should include a list of projects" do
    response.should have_tag('li.project', :count => @projects.size)
  end
end
{% endcodeblock %}

And the implementation:


{% codeblock app/views/projects/index.html.erb lang:rhtml %}
<ul>
  <%% @projects.each do |project| %>
    <li class="project"></li>
  <%% end -%>
</ul>
{% endcodeblock %}

**Note:** View tests can often be brittle. They can be made less brittle by
testing only for semantically appropriate tags, classes and ids whenever
possible. Using semantically rich markup in your views will make it much easier
to write robust view tests -- and is also a great practice for its own sake.
{:.note}

### Show Title for Each Project

{% codeblock spec/views/projects/index.html.erb_spec.rb lang:ruby %}
describe "/projects/index" do
  # SNIP
  
  it "should show the title for each project" do
    response.should have_tag('li.project .title', @project.title)
  end
end
{% endcodeblock %}

{% codeblock app/views/projects/index.html.erb lang:rhtml %}
<ul>
  <%% @projects.each do |project| %>
    <li class="project">
      <h2 class="title"><%%= project.title %></h2>
    </li>
  <%% end -%>
</ul>
{% endcodeblock %}

### Show Author Name for Each Project

{% codeblock spec/views/projects/index.html.erb_spec.rb lang:ruby %}
describe "/projects/index" do
  # SNIP
  
  it "should show the author name for each project" do
    response.should have_tag('li.project .author_name', @project.author_name)
  end
end
{% endcodeblock %}

{% codeblock app/views/projects/index.html.erb lang:rhtml %}
<ul>
  <%% @projects.each do |project| %>
    <li class="project">
      <h2 class="title"><%%= project.title %></h2>
      <p class="author_name"><%%= project.author_name %></p>
    </li>
  <%% end -%>
</ul>
{% endcodeblock %}

**Note:** We are using an accessor on our project model, `Project#author_name`.
There's a good chance that this name will be taken from an associated User or
Author model in any non-trivial Rails application. From an object oriented
standpoint, however, having the author name hang directly from the Project
model improves encapsulation.

The benefits of this were already seen in the test, where we were able to stub
`author_name` directly on the Project mock. Without the accessor, we would be
forced to stub `#author` on the Project mock to return an Author mock that then
stubs `#name` just so that we could properly test the method chain
`project.author.name` that is used in the view. Violating the [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter)
makes testing harder.

### Project Title Links to the Project's Page

{% codeblock spec/views/projects/index.html.erb_spec.rb lang:ruby %}
describe "/projects/index" do
  # SNIP
  
  it "should have project titles that link to the project page" do
    response.should have_tag( 'li.project .title a[href=?]', project_path(@project),   
      :text => @project.title)
  end
end
{% endcodeblock %}

{% codeblock app/views/projects/index.html.erb lang:rhtml %}
<ul>
  <%% @projects.each do |project| %>
    <li class="project">
      <h2 class="title"><%%= link_to project.title, project %></h2>
      <p class="author_name"><%%= project.author_name %></p>
    </li>
  <%% end -%>
</ul>
{% endcodeblock %}

The story is now about half complete. I'll leave pagination and default sort
order as an exercise for the user. In fact, these could also have been broken
out into a secondary story or stories given that what we have done so far is an
incremental unit of work.

I hope this rather contrived example shows how stories with well written
acceptance tests inform a test- or behavior- driven development process and
help bridge the gap between what the client expects and what the developement
team delivers.
