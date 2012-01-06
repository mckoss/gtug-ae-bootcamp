# Event Announcment

We want everyone at Startup Weekend's January 13, 2012 event to hit the ground running. So we're
running a boot camp for all participants on Startup Weekend Eve that will give you the tools you
need to be ready to start working immediately on your project. If you attend, you will:

1. Get your computer configured with all the tools needed to work collaboratively with your future
   team members.
2. Setup and configure a [GitHub] account with a skeleton project including:
   1. [App Engine] - web framework with simple user accounts, database, and hosting.
   2. [Bootstrap] - HTML design toolkit
   3. [Backbone.js] - Rich application HTML5 framework
   4. [jQuery] - client side Javascript framework
   5. [Namespace.js] - Javascript module library
   6. [QUnit] - Unit testing library

Bring your laptop (Windows, Mac, or Linux) with you; we'll have developers able to help you through
any rough patches you have with tool installation. Our goal is to get everyone able to modify,
build, and deploy their own copy of the skeleton app by the end of the evening.

When: Thursday, Jan 12, 2012 from 6pm - 9pm
Where: StartPad, 811 First Ave, Suite 480, Seattle
Phone: (206) 388-3466

  [GitHub]: https://github.com/
  [App Engine]: http://code.google.com/appengine/
  [Bootstrap]: http://twitter.github.com/bootstrap/
  [Backbone.js]: http://documentcloud.github.com/backbone/
  [jQuery]: http://jquery.com/
  [Namespace.js]: https://github.com/mckoss/namespace
  [QUnit]: https://github.com/jquery/qunit

# Setup Instructions

You'll need to install Git ([Git Tutorial]) on your machine to get the latest copy of the source code from [GitHub].

  - Install [Git for Windows](http://help.github.com/mac-set-up-git/)
  - Install [Git for Mac](http://help.github.com/win-set-up-git/)
  - Install [Git for Linux](http://help.github.com/linux-set-up-git/)

Then copy the gtug-ae-bootcamp repository to your machine:

    $ git clone https://github.com/mckoss/gtug-ae-bootcamp
    $ cd gtug-ae-bootcamp

The rest of your development machine configuration can be setup by running this script:

    $ bin/make-gtug-env.sh

This script will install (if you don't them already):

1. [Python 2.5] (yes its old, but it's the official version supported by Google App Engine).
2. [pip] - Python package installer (the *new* easy_install).
3. [virtualenv]: Python environment isolation builder.
4. [PIL]: Python Imaging Library.
5. [Google App Engine]: Google's web application service (for Python).

  [Git Tutorial]: http://gitimmersion.com/index.html
  [Python 2.5]: http://www.python.org/getit/releases/2.5.6/
  [pip]: http://pypi.python.org/pypi/pip
  [virtualenv]: http://pypi.python.org/pypi/virtualenv
  [PIL]: http://www.pythonware.com/products/pil/
  [Google App Engine]: http://code.google.com/appengine/docs/python/overview.html

# Running the Sample App

You should now be able to run the sample application on your machine.  First, *activate* your
App Engine environment:

    $ source activate

Now, run the built-in development web server to run the app:

    $ dev_appserver.py app

Open your browser at http://localhost:8080 to view the application.
