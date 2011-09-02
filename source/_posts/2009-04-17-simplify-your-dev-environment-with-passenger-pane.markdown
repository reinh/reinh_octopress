--- 
layout: post
title:  Simplify Your Dev Environment With Passenger&nbsp;Pane
date:   2009/04/17
--- 

On OS X? Develop web applications with Ruby? Want drag-and-drop and
point-and-click development server management? Then you need Passenger Pane.
We'll walk you through the installation process and show you how to get a
simple Rack application up and running. Thanks to
[Jason Noble](http://jasonnoble.org) for his help getting everything working.

<!--more-->

Passenger Pane is an OS X preference pane designed to work in concert with
Phusion Passenger and your OS X Leopard's default Apache2 installation (the
same one that serves your Web Sharing). Setup is pretty simple and will
probably take about 10 minutes.

Here's what we're going to do:

1. Install Phusion Passenger
2. Install Passenger Pane
3. Serve a "Hello World!" Rack endpoint
4. Profit!

## Install Phusion Passenger

[Phusion Passenger](http://www.modrails.com) is the (not so) new hotness in the
Rails deployment world. Phusion is great for serving Rails applications via
Apache in production (especially in concert with Rails Enterprise Edition,
which provides a 33% memory savings over standard MRI Ruby), but it's also
great for simplifying your development environment.

The Phusion team have done a great job on the passenger install. Here are the
[official installation instructions](http://www.modrails.com/install.html).
We'll repeat them here for the sake of convenience.

1.  Open a Terminal window.

2.  Install the passenger gem:
  
        sudo gem install passenger

3.  Install the passenger apache2 module:

        sudo passenger-install-apache2-module

4.  Include the module and some supporting configuration settings into an apache conf file. The code will be provided by the passenger install script.

5.  Finally, add a `Directory` directive to your apache2 config that
    allows access to the directory where your app source codes are located. You
    can put this at the bottom of your `passenger.conf` file
    (replace my source directory with yours):

        <Directory /Users/reinh/code/>
          Order Allow,Deny
          Allow from all
        </Directory>

**Note**: We put the passenger apache configuration in
`/etc/apach2/other/passenger.conf` (a file we created). The default apache2
`httpd.conf` imports all `.conf` files in `/etc/apache2/other`.


## Install Passenger Pane

[Passenger Pane](http://www.fngtps.com/2008/06/putting-the-pane-back-into-deployment)
gives you a Preference Pane that lets you add, remove and manage apps deployed
on Phusion Passenger. Drag-and-drop to serve a new app and restart with a
single click &mdash; it even provides host entries for each app so you don't
have to mess with virtual hosts or your hosts file. This is great for serving
multiple applications simultaneously or just generally being awesome.

Installation is simple. Download the preference pane from
[their homepage](http://www.fngtps.com/2008/06/putting-the-pane-back-into-deployment)
and double-click to install. If you installed Passenger correctly (as above),
this should just work. If not, look for errors in Console.app or a helpful
notice in the preference pane and ask for help on the
[Passenger forums](http://groups.google.com/group/phusion-passenger) or in the
`#passenger` channel on `irc.freenode.net`.

After installing Passenger Pane, you will need to restart Apache. The simplest
way to do this on OS X is to open the Sharing preference pane and uncheck and
recheck Web Sharing.

## Serve A "Hello World!" Rack Endpoint

Let's test that everything is working by creating a simple
[Rack](http://rack.rubyforge.org/) "Hello World!" endpoint.

1.  Install `rack`:

        sudo gem install rack

2.  Create a new directory called `rack-hello-world`.

3.  Add a file inside it called `config.ru` with these contents:

    ``` ruby
        run lambda{|env| [200, {"Content-Type" => "text/plain"}, ["Hello World!"]]}
    ```

4.  Create a `public` directory inside `rack-hello-world` (you'll see why later).

5.  Drag the `rack-hello-world` folder into your Passenger Pane panel (if
    you're using TextMate, you can drag it from the project panel). You will
    probably need to click the lock first to allow modifications.

6.  Browse to <http://rack-hello-world.local> and behold the awesome!

7.  Profit!!!

If you've done this correctly, your Passenger Pane should look similar to this:

<img class="none" src="http://reinh.com/images/passenger_pane.png">

Your browser should be showing you your glorious "Hello World!" homepage.

Now you can drag in the app folders of any Rails, Merb, Sinatra or Ramaze
applications and have them instantly served by Passenger. In fact, any Ruby web
application that can run on Rack can be run in Passenger Pane. How's that for a
painless local development environment?

**Note:** Why (I hear you asking) did we create a public directory? The answer is
that Apache expects to serve a public directory and will fail if one is not
found under the root of the app you're serving. If you had not created the
directory, you would have to look at your apache error log, which is usually located at
`/var/log/apache2/error_log`, to find out what went wrong.
