#!/usr/bin/env python
import simplejson as json
import logging
import os

from google.appengine.ext import db
from google.appengine.ext import webapp
from google.appengine.api import users
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp import util

from jsonmodel import JSONModel, json_response


class Todo(JSONModel):
    user_id = db.StringProperty()
    text = db.StringProperty()
    done = db.BooleanProperty()
    order = db.IntegerProperty()


class UserHandler(webapp.RequestHandler):
    """ This subclass of RequestHandler sets user and user_id
    variables to be used in processing the request. """
    def __init__(self, *args, **kwargs):
        super(UserHandler, self).__init__(*args, **kwargs)
        self.user = users.get_current_user()
        self.user_id = self.user and self.user.user_id() or 'anonymous'


class MainHandler(UserHandler):
    def get(self):
        username = self.user and self.user.nickname()
        self.response.out.write(template.render("index.html",
            {"sign_in": users.create_login_url('/'),
             "sign_out": users.create_logout_url('/'),
             "username": username,
             }))


# the Todos collection handler - used to handle requests
# on the Todos collection.
class TodoListHandler(UserHandler):
    # get all todos
    def get(self):
        # serialize all Todos, include the ID in the response
        query = Todo.all().filter('user_id =', self.user_id)
        todos = [todo.to_dict() for todo in query.fetch(1000)]
        json_response(self.response, todos)

    # create a todo
    def post(self):
        # load the JSON data of the new object
        data = json.loads(self.request.body)

        # create the todo item
        todo = Todo(
            user_id=self.user_id,
            text=data["text"],
            done=data["done"],
            order=data["order"],
        )
        todo.put()

        # send it back, and include the new ID.
        json_response(self.response, todo.to_dict())


# The Todo model handler - used to handle requests with
# a specific ID.
class TodoItemHandler(UserHandler):
    def put(self, id):
        # load the updated model
        data = json.loads(self.request.body)

        # get it model using the ID from the request path
        todo = Todo.get_by_id(int(id))

        if todo.user_id != self.user_id:
            self.error(403)
            self.response.out.write(json.dumps({
                'status': "Write permission failure."
                }))
            return

        # update all fields and save to the DB
        todo.text = data["text"]
        todo.done = data["done"]
        todo.order = data["order"]
        todo.put()

        # send it back using the updated values
        json_response(self.response, todo.to_dict())

    def delete(self, id):
        # find the requested model and delete it.
        todo = Todo.get_by_id(int(id))
        todo.delete()


def main():
    application = webapp.WSGIApplication([
        ('/', MainHandler),

        # REST API requires two handlers - one with an ID and one without.
        ('/todos', TodoListHandler),
        ('/todos/(\d+)', TodoItemHandler),
    ], debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
