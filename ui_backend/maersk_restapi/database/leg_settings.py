from database import db
from marshmallow import Schema, fields, post_dump, post_load

class LegSettings(db.Model):
    __tablename__ = 'LegSettings'
    pkey_row = db.Column('id', db.Integer, primary_key=True)
    user_id = db.Column('UserId', db.String(50))
    service = db.Column('Service', db.String(50))
    direction = db.Column('Direction',db.String(50))
    departure_port = db.Column('DeparturePort',db.String(50))
    arrival_port = db.Column('ArrivalPort', db.String(50))
    under_capacity = db.Column('UnderCapacity', db.Integer)
    over_capacity = db.Column('OverCapacity', db.Integer)

class LegSettingsSchema(Schema):
    service = fields.String(allow_none=False)
    direction = fields.String(allow_none=False)
    departure_port = db.Column('DeparturePort', db.String(50))
    arrival_port = db.Column('ArrivalPort', db.String(50))
    under_capacity = fields.Integer(allow_none=True)
    over_capacity = fields.Integer(allow_none=True)

    @post_dump(pass_many=True)
    def load_legs(self, data, many):
        import utils
        out_data = []
        element = {}
        for item in data:
            element['id'] = item['service'] + item['direction']
            element['name'] = item['service_name'] + utils.to_direction(item['direction'])
            element['departure'] = item['departure_port']
            element['arrival'] = item['arrival_port']
            element['under'] = item['under_capacity']
            element['over'] = item['over_capacity']
            out_data.append(element)
        return out_data

    class Meta:
        fields = (
            'service',
            'service_name'
            'direction',
            'under_capacity',
            'over_capacity'
        )