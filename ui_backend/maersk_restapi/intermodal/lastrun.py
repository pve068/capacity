from flask import  request, jsonify
from flask.views import MethodView
from database import persistence


class LastRun(MethodView):
    def get(self, criteria):
        if(criteria == 'date'):
            return self._get_last_rundate()

    def _get_last_rundate(self):
        return persistence.load_last_rundate()