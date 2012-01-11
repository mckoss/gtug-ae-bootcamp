# ToDos application walk-through

The GTUG App Engine Bootcamp tutorial is based on Jérôme Gravel-Niquet's [localtodos]
with Ron Reiter's [App Engine backend][webapp-boilerplate].

*Note: I've remove the RequireJS component of Ron's boilterplate app as I found it fragile and
difficult to debug when module dependencies were not processed properly.*

There is an excellent [annotated listing][localtodos-source] of the original todos.js application.

  [localtodos]: http://localtodos.com/
  [localtodos-source]: http://documentcloud.github.com/backbone/docs/todos.html
  [webapp-boilerplate]: https://github.com/ronreiter/webapp-boilerplate

## Why Use Backbone?

When creating a rich JavaScript client application, Backbone can seem like a lot of overhead.
But Backbone can help organize your application components into simple self contained
units, that allow you to separate concerns about your *data* vs. code for your *user interface*.

Backbone structures your application into three types of objects:

- **Views** - A view is associated with some on-page HTML that renders your presentation,
  but also includes simple mechanisms to bind events (mouse and keyboard) to call functions
  in your view.
- **Models** - A model contains the data for your application.  Backbone is particularly nice
  because all Models can trigger events when their properties change.  This way, your
  Views can register to receive notification when a model changes, and update their display
  in real time.  Note also that multiple Views can edit and render the same underlying data -
  the event mechansim allows both Views to stay in sync.
- **Collections** - A collection is wrapper around a list of Model items.  This is handy
  as Collections manage typical CRUD operations and creating new items of a given type,
  and can return filtered lists of the underlying Models.

Backbone also works well with a [REST-ful] (aka ajax) backend storage service.  It will
send requests to a web server to Create (POST), Retrieve (GET), Update (PUT), and
Delete (DELETE) the objects in your system.

## Application Components

The ToDos app is composed of server-side and client-side components.

File structure:

    app
    ├── README.md
    ├── app.yaml
    ├── css
    │   ├── destroy.png
    │   └── todos.css
    ├── index.html
    ├── index.yaml
    ├── js
    │   ├── libs
    │   │   ├── backbone-min.js
    │   │   ├── backbone.js
    │   │   ├── jquery-min.js
    │   │   ├── jquery.js
    │   │   ├── json2.js
    │   │   ├── namespace-plus.js
    │   │   ├── namespace-plus.min.js
    │   │   ├── underscore-min.js
    │   │   └── underscore.js
    │   └── main.js
    └── main.py

### Server-side Components

- [main.py] - This is the entire App Engine backend!  It is a pure [REST-ful] interface
  for dealing with ToDo items and the Todo collection (list).
  - **ToDoListHandler** - Used to retrieve the list of all tasks and create new ToDo items
  (**CR**UD)
  - **ToDoItemHandler** - Used to update and delete individual ToDo's (CR**UD**)

### Client-side Components

- [index.html] - A (static) page that loads a [style sheet][todo.css] and require.js - which
  in turn loads [main.js].  Note the special `<script>` tags used to store [Underscore Templates]
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
