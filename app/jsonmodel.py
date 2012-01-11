from datetime import datetime
import time
import logging
import simplejson as json

from google.appengine.ext import db


JSON_MIMETYPE = 'application/json'
JSON_MIMETYPE_CS = JSON_MIMETYPE + '; charset=utf-8'

SIMPLE_TYPES = (int, long, float, bool, dict, basestring, list)


class JSONModel(db.Model):
    """ Conversion of model to and from JSON """
    def get_dict(self):
        result = {'id': self.key().id_or_name()}

        for key in self.properties().iterkeys():
            value = getattr(self, key)

            if value is None or isinstance(value, SIMPLE_TYPES):
                result[key] = value
            elif isinstance(value, datetime):
                ms = time.mktime(value.utctimetuple()) * 1000
                ms += getattr(value, 'microseconds', 0) / 1000
                result[key] = int(ms)
            elif isinstance(value, db.GeoPt):
                result[key] = {'lat': value.lat, 'lon': value.lon}
            elif isinstance(value, db.Model):
                # BUG: Should just be a key - not the external model in place
                result[key] = value.get_dict()
            else:
                raise ValueError('cannot encode ' + repr(prop))

        return result

    def set_dict(self, json_dict):
        for key, prop in self.properties().iteritems():
            if key not in json_dict:
                continue

            value = json_dict[key]

            if value is None or prop.data_type in SIMPLE_TYPES:
                pass
            elif prop.date_type == datetime:
                value = datetime.utcfromtimestamp(value / 1000)
                value.microseconds = (value % 1000) * 1000
            elif prop.date_type == db.GeoPt:
                value = db.GeoPt(value.lat, value.lon)
            elif isinstance(value, db.Model):
                raise ValueError('NYI: reading model keys: %s' % value.kind())
            else:
                raise ValueError('cannot decode: %r ', value)

            setattr(self, key, value)

    def from_json(self, json_string):
        self.set_dict(json.loads(json_string))


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
