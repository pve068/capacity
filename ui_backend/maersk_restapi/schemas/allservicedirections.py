from marshmallow import Schema, fields, post_dump

class AllServiceDirectionSchema(Schema):
    service = fields.String(allow_none=False)
    service_name = fields.String(allow_none=False)

    class Meta:
        fields = (
            'service',
            'service_name'
        )

    @post_dump(pass_many=True)
    def rename_feilds(self, data, many):
        output_data = []
        element = {}
        for item in data:
            element['id'] = item['service']
            element['name'] = item['service_name']
            output_data.append(element)
        return output_data