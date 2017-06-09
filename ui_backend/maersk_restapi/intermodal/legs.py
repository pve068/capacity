from flask import  request, jsonify
from flask.views import MethodView
from database import persistence


class Legs(MethodView):
    def get(self, service_direction, week, vessel_voyage, leg_seqid, criteria):
        if(criteria == 'comparison'):
            return self._get_comparision(service_direction, week, vessel_voyage, leg_seqid)
        if (criteria == 'history'):
            return self._get_history(service_direction, week, vessel_voyage, leg_seqid)
        if (criteria == 'uboat'):
            return self._get_uboat(service_direction, week, vessel_voyage, leg_seqid)
        if (criteria == 'freesale'):
            return self._get_freesale(service_direction, week, vessel_voyage, leg_seqid)
        if (criteria == 'commitment'):
            return self._get_commitment(service_direction, week, vessel_voyage, leg_seqid)

    def _get_comparision(self, service_direction, week, vessel_voyage, leg_seqid):
        return persistence.load_leg_comparison(service_direction, week, vessel_voyage, leg_seqid)

    def _get_history(self, service_direction, week, vessel_voyage, leg_seqid):
        return persistence.load_leg_history(service_direction, week, vessel_voyage, leg_seqid)

    def _get_uboat(self, service_direction, week, vessel_voyage, leg_seqid):
        return persistence.load_leg_uboat(service_direction, week, vessel_voyage, leg_seqid)

    def _get_freesale(self, service_direction, week, vessel_voyage, leg_seqid):
        return persistence.load_leg_freesale(service_direction, week, vessel_voyage, leg_seqid)

    def _get_commitment(self, service_direction, week, vessel_voyage, leg_seqid):
        return persistence.load_leg_commitment(service_direction, week, vessel_voyage, leg_seqid)