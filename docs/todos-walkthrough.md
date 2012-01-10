# ToDos application walk-through

The GTUG App Engine Bootcamp tutorial is based on Ron Reiter's [webapp-boilerplate]
which was a derivative of Thomas Davis's [Backbone Tutorials] and Jérôme Gravel-Niquet's
[localtodos].

Ron wrote a walkthrough of his application [here][webapp-boilerplate-walkthrough].

  [webapp-boilerplate]: https://github.com/ronreiter/webapp-boilerplate
  [Backbone Tutorials]: http://backbonetutorials.com/
  [localtodos]: http://localtodos.com/
  [webapp-boilerplate-walkthrough]: http://www.slideshare.net/ronreiter/writing-html5-web-apps-using-backbonejs-and-gae

## Application Components

The ToDos app is composed of these parts (click on the links to browse the source code):

- [main.py] - This is the entire App Engine backend!  It is a pure [REST-ful] interface
  for dealing with ToDo items and the Todo collection (list).
  - **ToDoListHandler** - Used to retrieve the list of all tasks and create new ToDo items
  (the **CR**UD in CRUD)
  - **ToDoItemHandler** - Used to update and delete individual ToDo's
  (the CR**UD** in CRUD)
- [index.html] - A (static) page that loads a [style sheet][todo.css] and require.js - which
  in turn loads [main.js].
- [main.js] - A simple list of dependencies - all the javascript files that need to be loaded
  (by RequireJS).
- [views/app.js]: When all dependencies are loaded, this file is called and a new **AppView**
  is created.  The AppView loads all the ToDo items from the server, and sets up keyboard
  and mouse event bindings for the application.
- [collections/todos.js]: A collection object that holds a bunch of ToDo model items in a list.
- [views/todos.js]: Defines the **ToDoView** - defines the rendering (i.e., the HTML used
  to display it), of a ToDo item.


  [REST-ful]: http://en.wikipedia.org/wiki/Representational_state_transfer

  [main.py]: ../app/main.py
  [index.html]: ../app/index.html
  [main.js]: ../app/js/main.js
  [views/app.js]: ../app/js/views/app.js
  [collections/todos.js]: ../app/js/collections/todos.js
  [views/todos.js]: ../app/js/views/todos.js

