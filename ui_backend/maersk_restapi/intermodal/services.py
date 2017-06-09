from flask import  request, jsonify
from flask.views import MethodView
from database import persistence


class Services(MethodView):
    def get(self, service_direction, criteria = None, week= None, vessel_voyage=None):
        if(criteria == 'delta'):
            return self._get_change(service_direction)
        elif(criteria == 'limitingleg'):
            return self._get_limiting_leg(service_direction)
        elif(week is not None and vessel_voyage is not None):
            return self._get_vessel_voyage(service_direction, week, vessel_voyage)
        elif(week is not None):
            return self._get_vessel_voyages(service_direction, week)

    def _get_change(self, service_direction):
        return persistence.load_change(service_direction)

    def _get_limiting_leg(self, service_direction):
        return persistence.load_limiting_leg(service_direction)

    def _get_vessel_voyages(self,service_direction, week):
        return persistence.load_vessel_voyages(service_direction, week)

    def _get_vessel_voyage(self, service_direction, week, vessel_voyage):
        return persistence.load_vessel_voyage(service_direction, week, vessel_voyage)


