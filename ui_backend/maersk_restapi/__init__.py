from flask import Flask
from config import ApiConfig
from flask_cors import CORS
from flask_restful import Api

def create_app():
    from database import db

    __app = Flask(__name__)
    __app.config['SQLALCHEMY_DATABASE_URI'] = ApiConfig.alchemy_connection()
    CORS(__app)
    db.init_app(__app)
    return __app

def init_routes(api):
    from intermodal import Services, Legs, LastRun, UserSettings
    api.add_resource(Services,
                     '/<string:service_direction>/<string:criteria>',
                     '/<string:service_direction>/<int:week>',
                     '/<string:service_direction>/<int:week>/<string:vessel_voyage>',
                     endpoint='services',
                     methods = ['GET'])

    api.add_resource(Legs,
                     '/<string:service_direction>/<int:week>/<string:vessel_voyage>/<int:leg_seqid>/<string:criteria>',
                     endpoint='legs',
                     methods=['GET'])

    api.add_resource(UserSettings,
                     '/allservicedirections',
                     '/settings/<string:criteria>',
                     '/settings/<string:criteria>/<string:service>',
                     endpoint='usersettings',
                     methods = ['GET', 'GET', 'PUT']
                    )

    api.add_resource(LastRun,
                     '/lastrun/<string:criteria>',
                     endpoint='lastrun',
                     methods=['GET']
                     )

API_VERSION = 'v1'
API_PREFIX = '{}/{}'.format('/api', API_VERSION)
app = create_app()
rest_api = Api(app, prefix = API_PREFIX)
init_routes(rest_api)


if __name__ == '__main__':
    app.run(debug=True)