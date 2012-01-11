from datetime import date, datetime
import time
import logging
import simplejson as json

from google.appengine.ext import db


JSON_MIMETYPE = 'application/json'
JSON_MIMETYPE_CS = JSON_MIMETYPE + '; charset=utf-8'

SIMPLE_TYPES = (int, long, float, bool, dict, basestring, list)

class JSONModel(db.Model):
    """ Convert an App Engine Model to a dictionary """
    def to_dict(self):
        result = {'id': self.key().id_or_name()}

        for key in self.properties().iterkeys():
            value = getattr(self, key)

            if value is None or isinstance(value, SIMPLE_TYPES):
                result[key] = value
            elif isinstance(value, date):
                # Convert date/datetime to ms-since-epoch ("new Date()").
                ms = time.mktime(value.utctimetuple()) * 1000
                ms += getattr(value, 'microseconds', 0) / 1000
                result[key] = int(ms)
            elif isinstance(value, db.GeoPt):
                result[key] = {'lat': value.lat, 'lon': value.lon}
            elif isinstance(value, db.Model):
                result[key] = to_dict(value)
            else:
                raise ValueError('cannot encode ' + repr(prop))

        return result

class ModelEncoder(json.JSONEncoder):
    """
    Encode some common datastore property types to JSON.
    """
    def default(self, obj):
        if isinstance(obj, datetime):
            # Convert date/datetime to ms-since-epoch ("new Date()").
            ms = time.mktime(value.utctimetuple()) * 1000
            ms += getattr(value, 'microseconds', 0) / 1000
            return int(ms)
        return json.JSONEncoder.default(self, obj)


def pretty_json(json_dict):
    return json.dumps(json_dict, sort_keys=True, indent=2,
                      separators=(',', ': '), cls=ModelEncoder)


def json_response(response, json_dict):
    response.headers['Content-Type'] = JSON_MIMETYPE_CS
    response.out.write(pretty_json(json_dict))
