# ToDos application walk-through

The GTUG App Engine Bootcamp tutorial is based on Jérôme Gravel-Niquet's [localtodos]
with Ron Reiter's [App Engine backend][webapp-boilerplate].

*Note: I've remove the RequireJS component of Ron's boilterplate app as I found it fragile and
difficult to debug when module dependencies were not processed properly.*

There is an excellent [annotated listing][localtodos-source] of the original todos.js application.

  [localtodos]: http://localtodos.com/
  [localtodos-source]: http://documentcloud.github.com/backbone/docs/todos.html
  [webapp-boilerplate]: https://github.com/ronreiter/webapp-boilerplate

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
  in turn loads [main.js].  Note the special `<script>` tags used to store [Underscrore Templates]
  used to render todo items and the status bar.
- [todos.css]: The style sheets used ToDo app beautiful (it looks
  like this was a generated file - using [compass] and [sass]).
- [main.js] - All the client application code is here:
- **AppView** - loads all the ToDo items from the server, and sets up keyboard
  and mouse event bindings for the application.
- **TodoList** and **Todos** - a collection object that holds a bunch of ToDo model items in a list
  with methods determining how they are sorted (ordered) and various filtered collections.
- **TodoView** - defines the rendering (i.e., the HTML used
  to display it), of a ToDo item as well as handling user-interface events for a single
  ToDo item.
- **Todo** - An trivial extension of Backbone's standard model class.

  [REST-ful]: http://en.wikipedia.org/wiki/Representational_state_transfer
  [Underscore Templates]: http://documentcloud.github.com/underscore/#template
  [less]: http://lesscss.org/
  [compass]: http://compass-style.org/
  [sass]: http://sass-lang.com/

  [main.py]: ../app/main.py
  [index.html]: ../app/index.html
  [todos.css]: ../app/css/todos.css
  [main.js]: ../app/js/main.js
