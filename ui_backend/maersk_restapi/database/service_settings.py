from database import db
from marshmallow import Schema, fields, post_dump, post_load

class ServiceSettings(db.Model):
    __tablename__ = 'ServiceSettings'
    pkey_row = db.Column('id', db.Integer, primary_key=True)
    user_id = db.Column('UserId', db.String(50))
    service = db.Column('Service', db.String(50))
    service_name = db.Column('ServiceName', db.String(50))
    direction = db.Column('Direction',db.String(50))
    under_capacity = db.Column('UnderCapacity', db.Integer)
    over_capacity = db.Column('OverCapacity', db.Integer)

class ServiceSettingsSchema(Schema):
    service = fields.String(allow_none=False)
    direction = fields.String(allow_none=False)
    under_capacity = fields.Integer(allow_none=True)
    over_capacity = fields.Integer(allow_none=True)

    @post_dump(pass_many=True)
    def load_services(self, data, many):
        import utils
        out_data = []
        element = {}
        for item in data:
            element['id'] = item['service'] + item['direction']
            element['name'] = item['service_name'] + utils.to_direction(item['direction'])
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