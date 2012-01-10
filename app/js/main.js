namespace.module('seagtug.todo', function(exports, require) {

exports.extend({
    'init': init
});

function init() {
    // Load templates after document is ready
    AppView.statsTemplate = _.template($('#stats-template').html());
    TodoView.template =  _.template($('#todo-template').html());

    // Start the app
    new AppView();
}

$(document).ready(init);

var Todo = Backbone.Model.extend({

    url: "/todos",
    // Default attributes for the todo.
    defaults: {
      content: "empty todo...",
      done: false,
      order: 0
    },

    // Ensure that each todo created has `content`.
    initialize: function() {
      if (!this.get("content")) {
        this.set({"content": this.defaults.content});
      }
    }
});

var TodoList = Backbone.Collection.extend({

    // Reference to this collection's model.
    model: Todo,
    url: '/todos',
    // Filter down the list of all todo items that are finished.
    done: function() {
      return this.filter(function(todo){ return todo.get('done'); });
    },

    // Filter down the list to only todo items that are still not finished.
    remaining: function() {
      return this.without.apply(this, this.done());
    },

    // We keep the Todos in sequential order, despite being saved by unordered
    // GUID in the database. This generates the next order number for new items.
    nextOrder: function() {
      if (!this.length) return 1;
      return this.last().get('order') + 1;
    },

    // Todos are sorted by their original insertion order.
    comparator: function(todo) {
      return todo.get('order');
    }
});

// TODO: Should be 'todos' - not a constructor function
var Todos = new TodoList();

var AppView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton of
    // the App already present in the HTML.
    el: $("#todoapp"),

    // Delegated events for creating new items, and clearing completed ones.
    events: {
      "keypress #new-todo":  "createOnEnter",
      "keyup #new-todo":     "showTooltip",
      "click .todo-clear a": "clearCompleted"
    },

    // At initialization we bind to the relevant events on the `Todos`
    // collection, when items are added or changed. Kick things off by
    // loading any preexisting todos from the server.
    initialize: function() {
      _.bindAll(this, 'addOne', 'addAll', 'render');

      this.input = $("#new-todo");

      Todos.bind('add', this.addOne);
      Todos.bind('reset', this.addAll);
      Todos.bind('all', this.render);

      Todos.fetch();
    },

    // Re-rendering the App just means refreshing the statistics -- the rest
    // of the app doesn't change.
    render: function() {
      var done = Todos.done().length;
      $('#todo-stats').html(AppView.statsTemplate({
        total:      Todos.length,
        done:       Todos.done().length,
        remaining:  Todos.remaining().length
      }));
    },

    // Add a single todo item to the list by creating a view for it, and
    // appending its element to the `<ul>`.
    addOne: function(todo) {
      var view = new TodoView({model: todo});
      $("#todo-list").append(view.render().el);
    },

    // Add all items in the **Todos** collection at once.
    addAll: function() {
      Todos.each(this.addOne);
    },

    // Generate the attributes for a new Todo item.
    newAttributes: function() {
      return {
        content: this.input.val(),
        order:   Todos.nextOrder(),
        done:    false
      };
    },

    // If you hit return in the main input field, create new **Todo** model,
    // persisting it to the server (will generate a POST request)
    createOnEnter: function(e) {
      if (e.keyCode != 13) return;
      Todos.create(this.newAttributes());
      this.input.val('');
    },

    // Clear all done todo items, destroying their models.
    // This will cause the views to delete as well by sending an event,
    // and will generate a DELETE request to the server)
    clearCompleted: function() {
      _.each(Todos.done(), function(todo){ todo.destroy(); });
      return false;
    },

    // Lazily show the tooltip that tells you to press `enter` to save
    // a new todo item, after one second.
    showTooltip: function(e) {
      var tooltip = $(".ui-tooltip-top");
      var val = this.input.val();
      tooltip.fadeOut();
      if (this.tooltipTimeout) clearTimeout(this.tooltipTimeout);
      if (val == '' || val == this.input.attr('placeholder')) return;
      var show = function(){ tooltip.show().fadeIn(); };
      this.tooltipTimeout = _.delay(show, 1000);
    }

});

var TodoView = Backbone.View.extend({
    model: Todo,
    //... is a list tag.
    tagName:  "li",

    // The DOM events specific to an item.
    events: {
      "click .check"              : "toggleDone",
      "dblclick div.todo-content" : "edit",
      "click span.todo-destroy"   : "clear",
      "keypress .todo-input"      : "updateOnEnter"
    },

    initialize: function() {
      _.bindAll(this, 'render');

      this.model.bind('change', this.render);
      this.model.bind('destroy', this.remove);
    },

    render: function() {
      $(this.el).html(TodoView.template(this.model.toJSON()));

      // save a reference to the DOM element to avoid extra lookups
      this.input = $('.todo-input');
      return this;
    },

    // Toggle the `"done"` state of the model.
    toggleDone: function() {
      this.model.save({done : !this.model.get("done")});
    },

    // Switch this view into `"editing"` mode, displaying the input field.
    edit: function() {
      $(this.el).addClass("editing");
      this.input.focus();
    },

    // Close the `"editing"` mode, saving changes to the todo.
    close: function() {
      this.model.save({content: this.input.val()});
      $(this.el).removeClass("editing");
    },

    // If you hit `enter`, we're through editing the item.
    updateOnEnter: function(e) {
      if (e.keyCode == 13) this.close();
    },

    // Remove this view from the DOM.
    remove: function() {
      $(this.el).remove();
    },

    // Remove the item, destroy the model.
    clear: function() {
      this.model.destroy();
      this.remove();
    }

});

}); // seagtug.todos
