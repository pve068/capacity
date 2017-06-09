from database import db
from marshmallow import Schema, fields, post_dump, post_load

class FreesaleUboat(db.Model):
    __tablename__ = 'FreesaleUboat'
    pkey_row = db.Column('id', db.Integer, primary_key=True)
    run_id = db.Column('runid', db.Integer)
    #run_date = db.Column('rundate', db.DateTime)
    vessel = db.Column('Vessel', db.String(50))
    voyage = db.Column('voyage', db.String(50))
    service = db.Column('Service', db.String(50))
    service_code_direction = db.Column('Service Code Direction', db.String(50))
    departure_portcall = db.Column('Departure PortCall', db.String(50))
    arrival_portcall = db.Column('Arrival PortCall', db.String(50))
    departure = db.Column('Departure', db.DateTime)
    arrival = db.Column('Arrival', db.DateTime)
    msk_allocation_teu = db.Column('MSK allocation TEU', db.Integer)
    msk_allocation_mts = db.Column('MSK allocation MTS', db.Integer)
    msk_allocation_plugs = db.Column('MSK allocation plugs',db.Integer)
    empty_allocation_teu = db.Column('Empty allocation TEU', db.Integer)
    empty_allocation_mts = db.Column('Empty allocation MTS', db.Integer)
    commitment_allocation_teu = db.Column('Commitment allocation TEU', db.Integer)
    commitment_allocation_mts = db.Column('Commitment allocation MTS', db.Integer)
    commitment_allocation_plugs = db.Column('Commitment allocation plugs', db.Integer)
    commitment_consumption_teu = db.Column('Commitment consumption TEU', db.Integer)
    commitment_consumption_mts = db.Column('Commitment consumption MTS', db.Integer)
    commitment_consumption_plugs = db.Column('Commitment consumption plugs', db.Integer)
    freesale_available_teu_before_overbooking = db.Column('Freesale available TEU - before overbooking ', db.Integer)
    freesale_available_mts_before_overbooking = db.Column('Freesale available MTS - before overbooking ', db.Integer)
    freesale_available_plugs_before_overbooking = db.Column('Freesale available plugs - before overbooking ', db.Integer)
    freesale_available_teu_incl_overbooking = db.Column('Freesale available TEU - incl   overbooking ',db.Integer)
    freesale_available_mts_incl_overbooking = db.Column('Freesale available mts - incl   overbooking ',db.Integer)
    freesale_available_plugs_incl_overbooking = db.Column('Freesale available plugs - incl   overbooking ',db.Integer)
    freesale_consumption_teu = db.Column('Freesale consumption TEU', db.Integer)
    oog_displacement_teu = db.Column('OOG Displacement TEU', db.Integer)
    freesale_consumption_displacement_teu = db.Column('Freesale consumption and displacement TEU total', db.Integer)
    freesale_consumption_mts = db.Column('Freesale consumption MTS', db.Integer)
    freesale_consumption_plugs = db.Column('Freesale consumption plugs', db.Integer)
    remaining_capacity_before_oog_displacement_teu = db.Column('Remaining capacity TEU - before OOG displacement', db.Integer)
    remaining_capacity_incl_oog_displacement_teu = db.Column('Remaining capacity TEU - incl  OOG displacement', db.Integer)
    remaining_Capacity_mts = db.Column('Remaining capacity MTS', db.Integer)
    remaining_Capacity_plugs = db.Column('Remaining capacity plugs', db.Integer)
    isc_indicator = db.Column('ISC indicator (Lead trade   ISC1)', db.String(30))
    service_name = db.Column('ServiceName', db.String(50))

class ServiceSchema(Schema):
    run_id = fields.Integer(allow_none=True)
    vessel = fields.String(allow_none=True)
    voyage = fields.String(allow_none=True)
    service = fields.String(allow_none=True)
    service_code_direction = fields.String(allow_none=True)
    departure_portcall = fields.String(allow_none=True)
    arrival_portcall = fields.String(allow_none=True)
    departure = fields.DateTime(allow_none=True)
    arrival = fields.DateTime(allow_none=True)
    msk_allocation_teu = fields.Integer(allow_none=True)
    msk_allocation_mts = fields.Integer(allow_none=True)
    msk_allocation_plugs = fields.Integer(allow_none=True)
    empty_allocation_teu = fields.Integer(allow_none=True)
    empty_allocation_mts = fields.Integer(allow_none=True)
    commitment_allocation_teu = fields.Integer(allow_none=True)
    commitment_allocation_mts = fields.Integer(allow_none=True)
    commitment_allocation_plugs = fields.Integer(allow_none=True)
    commitment_consumption_teu = fields.Integer(allow_none=True)
    commitment_consumption_mts = fields.Integer(allow_none=True)
    commitment_consumption_plugs = fields.Integer(allow_none=True)
    freesale_available_teu_before_overbooking = fields.Integer(allow_none=True)
    freesale_available_mts_before_overbooking = fields.Integer(allow_none=True)
    freesale_available_plugs_before_overbooking = fields.Integer(allow_none=True)
    freesale_available_teu_incl_overbooking = fields.Integer(allow_none=True)
    freesale_available_mts_incl_overbooking = fields.Integer(allow_none=True)
    freesale_available_plugs_incl_overbooking = fields.Integer(allow_none=True)
    freesale_consumption_teu = fields.Integer(allow_none=True)
    oog_displacement_teu = fields.Integer(allow_none=True)
    freesale_consumption_displacement_teu = fields.Integer(allow_none=True)
    freesale_consumption_mts = fields.Integer(allow_none=True)
    freesale_consumption_plugs = fields.Integer(allow_none=True)
    remaining_capacity_before_oog_displacement_teu = fields.Integer(allow_none=True)
    remaining_capacity_incl_oog_displacement_teu = fields.Integer(allow_none=True)
    remaining_Capacity_mts = fields.Integer(allow_none=True)
    remaining_Capacity_plugs = fields.Integer(allow_none=True)
    isc_indicator = fields.String(allow_none=True)
    service_name = fields.String(allow_none=True)


    @post_dump(pass_many=True, )
    def load_services(self, data, many):
        output_data = []
        temp = {}
        for item in data:
            temp['dd'] = ['freesale', 'commitment', 'remaining']
            temp['teu'] = [item['freesale_available_teu_before_overbooking'], item['commitment_allocation_teu'], item['remaining_capacity_before_oog_displacement_teu']]
            temp['mts'] = [item['freesale_available_mts_before_overbooking'], item['commitment_allocation_mts'], item['remaining_Capacity_mts']]
            temp['plugs'] = [item['freesale_available_plugs_before_overbooking'], item['commitment_consumption_plugs'], item['remaining_Capacity_plugs']]
            output_data.append(temp)
        return output_data

    class Meta:

        fields = (
        'run_id',
        'vessel',
        'voyage',
        'service',
        'service_code_direction' ,
        'departure_portcall',
        'arrival_portcall',
        'departure' ,
        'msk_allocation_teu',
        'msk_allocation_mts',
        'msk_allocation_plugs',
        'empty_allocation_teu',
        'empty_allocation_mts',
        'commitment_allocation_teu',
        'commitment_allocation_mts',
        'commitment_allocation_plugs',
        'commitment_consumption_teu',
        'commitment_consumption_mts',
        'commitment_consumption_plugs',
        'freesale_available_teu_before_overbooking',
        'freesale_available_mts_before_overbooking',
        'freesale_available_plugs_before_overbooking',
        'freesale_available_mts_incl_overbooking',
        'freesale_available_plugs_incl_overbooking',
        'freesale_consumption_teu',
        'oog_displacement_teu',
        'freesale_consumption_displacement_teu',
        'freesale_consumption_mts',
        'freesale_consumption_plugs',
        'remaining_capacity_before_oog_displacement_teu',
        'remaining_capacity_incl_oog_displacement_teu',
        'remaining_Capacity_mts',
        'remaining_Capacity_plugs',
        'isc_indicator',
        'service_name',
        )
