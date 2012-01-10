namespace.module('seagtug.todo', function(exports, require) {

exports.extend({
    'TodoModel': TodoModel,
    'TodosCollection': TodosCollection
});

var TodoModel = Backbone.Model.extend({
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

var TodosCollection = Backbone.Collection.extend({
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




});
