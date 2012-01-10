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

The ToDos app is composed of this parts:

- [main.py] - This is the entire App Engine backend!  It is a pure [REST-ful] interface
  for dealing with ToDo items and the Todo collection (list).
  - The main index.html page (this should probably be static).
  - ToDoListHandler - Used to retrieve the list of all tasks and create new ToDo items (CR)
  - ToDoItemHandler - Used to update and delete individual ToDo's (UD)
- [index.html] - A (static) page that loads a [style sheet][todo.css] and require.js - which
  in turn loads [main.js].
- [main.js] - A simple list of dependencies - all the javascript files that need to be loaded
  (by RequireJS).

  [REST-ful]: http://en.wikipedia.org/wiki/Representational_state_transfer

  [main.py]: ../app/main.py
  [index.html]: ../app/index.html
  [main.js]: ../app/js/main.js
