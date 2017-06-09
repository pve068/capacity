from database import db
from marshmallow import Schema, fields, post_dump, post_load


class UserSettings(db.Model):
    __tablename__ = 'UserSettings'
    pk_row = db.Column('id', db.Integer, primary_key = True)
    user_id = db.Column('UserId', db.String(50))
    service = db.Column('Service', db.String(50))
    service_name = db.Column('ServiceName', db.String(50))
    direction = db.Column('Direction', db.String(50))
    departure_port = db.Column('DeparturePort', db.String(50))
    arrival_port = db.Column('ArrivalPort', db.String(50))
    under_capacity = db.Column('UnderCapacity',db.Integer)
    over_capacity = db.Column('OverCapacity', db.Integer)

class AllocatedServicesSchema(Schema):
    service = fields.String(allow_none=False)
    service_name = fields.String(allow_none=False)
    direction = fields.String(allow_none = False)

    class Meta:
        fields = (
            'service',
            'service_name',
            'direction'
        )

    @post_dump(pass_many=True)
    def rearrangefields(self, data, many):
        out_data =[]
        element = {}
        for item in data:
            element['id'] = item['service'] + item['direction']
            element['name'] = item['service_name'] + ' ' + item['direction']
            out_data.append(element)
        return out_data

class AllocatedLegsSchema(Schema):
    service = fields.String(allow_none=False)
    service_name = fields.String(allow_none=False)
    direction = fields.String(allow_none=False)
    departure_port = fields.String(allow_none=False)
    arrival_port = fields.String(allow_none=False)
    under_capacity = fields.Integer(allow_none=False)
    over_capacity = fields.Integer(allow_none=False)

    class Meta:
        fields = ('service', 'servicename')

