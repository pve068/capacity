from flask import  request, jsonify
from flask.views import MethodView
from database import persistence


class UserSettings(MethodView):
    def get(self, criteria= None, **kwargs):
        if(criteria is None):
            return self._get_allocated_services()
        elif(criteria == 'legs'):
            return self._get_legs()

    def put(self, criteria, service, **kwargs):
        json = request.get_json()
        print(json)

    def _get_allocated_services(self):
        return persistence.load_allocated_services()

    def _get_legs(self):
        return persistence.load_allocated_legs()

    def _add_Service(self):
        a = "to be implemented"

    def _update_legs(self):
        a = "to be implemented"