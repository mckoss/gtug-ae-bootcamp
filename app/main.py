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


class ListHandler(UserHandler):
    def get_model(self, model_name):
        if model_name not in handle_models:
            self.error(404)
            self.response.out.write("Model '%s' not in %r" % (model_name, handle_models))
            return None
        return handle_models[model_name]

    # get all list of items
    def get(self, model_name):
        model = self.get_model(model_name)
        if model is None:
            return
        query = model.all().filter('user_id =', self.user_id)
        items = [item.get_dict() for item in query.fetch(1000)]
        json_response(self.response, items)

    # create an item
    def post(self, model_name):
        model = self.get_model(model_name)
        if model is None:
            return
        data = json.loads(self.request.body)
        item = model(user_id=self.user_id)
        item.set_dict(data)
        item.put()
        json_response(self.response, item.get_dict())


# The Todo model handler - used to handle requests with
# a specific ID.
class ItemHandler(UserHandler):
    def get_item(self, model_name, id):
        if model_name not in handle_models:
            self.error(404)
            return None
        model = handle_models[model_name]
        item = model.get_by_id(int(id))
        if item is None:
            self.error(404)
            return None
        return item

    def put(self, model_name, id):
        item = self.get_item(model_name, id)
        if not item:
            return

        data = json.loads(self.request.body)
        if item.user_id != self.user_id:
            self.error(403)
            self.response.out.write(json.dumps({
                'status': "Write permission failure."
                }))
            return

        item.set_dict(data)
        item.put()
        json_response(self.response, item.to_dict())

    def delete(self, model_name, id):
        item = self.get_item(model_name, id)
        if item:
            item.delete()


handle_models = {'todo': Todo}


def main():
    application = webapp.WSGIApplication([
        ('/', MainHandler),

        # REST API requires two handlers - one with an ID and one without.
        ('/data/(\w+)', ListHandler),
        ('/data/(\w+)/(\d+)', ItemHandler),
    ], debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
