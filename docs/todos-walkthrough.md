# ToDos application walk-through

The GTUG App Engine Bootcamp tutorial is based on Ron Reiter's [webapp-boilerplate]
which was a derivative of Thomas Davis's [Backbone Tutorials] and Jérôme Gravel-Niquet's
[localtodos].

Also see the nice [walkthrough slide-presentation][boilerplate-walkthrough] from Ron.

  [webapp-boilerplate]: https://github.com/ronreiter/webapp-boilerplate
  [Backbone Tutorials]: http://backbonetutorials.com/
  [localtodos]: http://localtodos.com/
  [boilerplate-walkthrough]: http://www.slideshare.net/ronreiter/writing-html5-web-apps-using-backbonejs-and-gae

## Application Components

The ToDos app is composed of server-side and client-side components:

### Server-side Components

- [main.py] - This is the entire App Engine backend!  It is a pure [REST-ful] interface
  for dealing with ToDo items and the Todo collection (list).
  - **ToDoListHandler** - Used to retrieve the list of all tasks and create new ToDo items
  (**CR**UD)
  - **ToDoItemHandler** - Used to update and delete individual ToDo's (CR**UD**)

### Client-side Components

- [index.html] - A (static) page that loads a [style sheet][todo.css] and require.js - which
  in turn loads [main.js].
- [main.js] - A simple list of dependencies - all the javascript files that need to be loaded
  (by RequireJS).
- [views/app.js]: When all dependencies are loaded, this file is called and a new **AppView**
  is created.  The AppView loads all the ToDo items from the server, and sets up keyboard
  and mouse event bindings for the application.
- [collections/todos.js]: A collection object that holds a bunch of ToDo model items in a list
  with methods determining how they are sorted (ordered) and various filtered collections.
- [views/todos.js]: Defines the **TodoView** - defines the rendering (i.e., the HTML used
  to display it), of a ToDo item as well as handling user-interface events for a single
  ToDo item.
- [models/todo.js]: An trivial extension of Backbone's standard model class.
- [css/todos.css]: And finally, the style sheets used ToDo app beautiful (it looks
  like this was a generated file - using [compass] and [sass]).

### Client-side Templates

The HTML definition of a [Todo item](../app/js/templates/todos.html) and of the
[statistics line](../app/js/templates/stats.html) are stored as [Underscore Templates].

  [REST-ful]: http://en.wikipedia.org/wiki/Representational_state_transfer
  [Underscore Templates]: http://documentcloud.github.com/underscore/#template
  [less]: http://lesscss.org/
  [compass]: http://compass-style.org/
  [sass]: http://sass-lang.com/

  [main.py]: ../app/main.py
  [index.html]: ../app/index.html
  [main.js]: ../app/js/main.js
  [views/app.js]: ../app/js/views/app.js
  [collections/todos.js]: ../app/js/collections/todos.js
  [views/todos.js]: ../app/js/views/todos.js
  [models/todo.js]: ../app/js/models/todo.js
  [css/todos.css]: ../app/css/todos.css

