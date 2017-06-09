#from database.preferences import Preferences, PreferencesSchema
from database.freesale_uboat import FreesaleUboat, ServiceSchema
from schemas.allservicedirections import AllServiceDirectionSchema


#serversettings.py
def load_allocated_services():
    from database import db
    from database.service_settings import ServiceSettings, ServiceSettingsSchema
    schema = ServiceSettingsSchema()
    output = db.session.query(ServiceSettings.service ,ServiceSettings.service_name, ServiceSettings.direction, ServiceSettings.under_capacity, ServiceSettings.over_capacity).filter(ServiceSettings.user_id == 'sumanth')
    return schema.dump(output, many=True).data

def load_allocated_legs():
    return "to be implemented"


#services.py
def load_change(service_direction):
    return "to be implemented"

def load_limiting_leg(service_direction):
    return "to be implemented"

def load_vessel_voyages(service_direction, week):
    return "to be implemented"

def load_vessel_voyage(service_direction, week, vessel_voyage):
    return "to be implemented"


#legs.py
def load_leg_comparison(service_direction, week, vessel_voyage, leg_seqid):
    return "to be implemented"

def load_leg_history(service_direction, week, vessel_voyage, leg_seqid):
    return "to be implemented"

def load_leg_uboat(service_direction, week, vessel_voyage, leg_seqid):
    return "to be implemented"

def load_leg_freesale(service_direction, week, vessel_voyage, leg_seqid):
    return "to be implemented"

def load_leg_commitment(service_direction, week, vessel_voyage, leg_seqid):
    return "to be implemented"


#lastrun.py
def load_last_rundate():
    from database import db
    return "to be implemented"