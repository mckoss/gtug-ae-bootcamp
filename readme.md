# Event Announcment

We want everyone at Startup Weekend's January 13, 2012 event to hit the ground running. So we're
running a boot camp for all participants on
[Startup Weekend Eve](http://seattleswgtugbootcamp.eventbrite.com/) that will give you the tools you
need to be ready to start working immediately on your project. If you attend, you will:

1. Get your computer configured with all the tools needed to work collaboratively with your future
   team members.
2. Setup and configure a [GitHub] account with a skeleton project including:
    1. [App Engine] - web framework with simple user accounts, database, and hosting.
    2. [Backbone.js] - Rich application HTML5 framework
    3. [jQuery] - client side Javascript framework

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
  [RequireJS]: http://requirejs.org/

# Setup Instructions

You'll need to install Git and create an
account on [GitHub].  If you would like a tutorial on using Git, I recommend
[Git Simple Guide] and [Git Tutorial].

- Install [Git for Windows](http://help.github.com/win-set-up-git/)
- Install [Git for Mac](http://help.github.com/mac-set-up-git/)
- Install [Git for Linux](http://help.github.com/linux-set-up-git/)

You should then create your *own copy* of the repository by forking it on GitHub.

- Go to the [Master Bootcamp Repository](https://github.com/mckoss/gtug-ae-bootcamp).
- Click on the *Fork* button.

Now, you need to check out the files to your own machine.

Go to a directory where you want to install your project files (e.g., ~/src or c:\src).  Then use
the following commands (on Windows, you should run these command from the *Git Bash* shell,
not the windows command prompt):

    $ git clone git@github.com:<your-github-username>/gtug-ae-bootcamp.git
    $ cd gtug-ae-bootcamp
    $ git remote add upstream git://github.com/mckoss/gtug-ae-bootcamp.git

The rest of your development machine configuration can be setup by running this command:

    $ bin/make-gtug-env.sh

This script will install (if you don't them already):

1. [Python 2.5] (yes its old, but it's the official version supported by Google App Engine).
2. [pip] - Python package installer (the *new* easy_install).
3. [virtualenv]: Python environment isolation builder.
4. [Google App Engine]: Google's web application service (for Python).

  [Git Tutorial]: http://gitimmersion.com/index.html
  [Git Simple Guide]: http://rogerdudler.github.com/git-guide/
  [Python 2.5]: http://www.python.org/getit/releases/2.5.6/
  [pip]: http://pypi.python.org/pypi/pip
  [virtualenv]: http://pypi.python.org/pypi/virtualenv
  [PIL]: http://www.pythonware.com/products/pil/
  [Google App Engine]: http://code.google.com/appengine/docs/python/overview.html

*Note: If you want to merge any updates that have been made on the master in your own
repository, use the following commands:*

    $ git fetch upstream
    $ git merge upstream/master

# Running the Todos application

You should now be able to run the sample application on your machine.

## Run Using the App Engine Launcher (Mac and Windows)

1. Run the Launcher App
2. File/Add Existing Application...
   - Select Path to: ~/src/gtug-ae-bootcamp/app
   - Select Port: 8080
   - Click Add
3. Select your app in the list and click the Run button.
4. Open a web browser at address: http://localhost:8080

You should see the Todos application running in your browser!

## Run from command line (Mac and Linux)

First, *activate* your local Python environment:

     $ source activate

Now, run the built-in development web server to run the app:

     $ dev_appserver.py app

Open your browser at http://localhost:8080 to view the application.

# Deploying your application to Google Appengine.

You can run your application at `http://<your-app-name>.appspot.com`.

1. Go to the [App Engine Admin Console]
2. Click the Create button.
   - You may be asked to verify your account via SMS ... do that.
   - Application identifier: `todoapp-<your-name>` (e.g., "todoapp-mckoss").
   - Application Title: "GTUG Bootcamp Sample"
   - Click Create Application
3. Edit the file gtug-ae-bootcamp/app/app.yaml:
   - Change `todoapp-mckoss` to be `todoapp-<your-name>`
4. Deploy your application.
   - Open the App Engine Luancher
   - Select your app.
   - Click the Deploy button.
   - Enter your Google Account credentials.
   - Wait until "Completed update of app:" message.
5. Visit `http://todoapp-<your-name>.appspot.com`

Alternatively, you can deploy via the command line via:

    $ appcfg.py update app

  [App Engine Admin Console]: https://appengine.google.com/

You can view an online version of the app at http://todoapp-mckoss.appspot.com/

To learn more about the application internals, visit the [Application Walkthrough].

  [Application Walkthrough]: gtug-ae-bootcamp/blob/master/docs/todos-walkthrough.md
