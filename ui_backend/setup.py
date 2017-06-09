from setuptools import setup, find_packages

setup(
    name='maersk_restapi',
    version='0.1',
    packages=find_packages(),
    author='Revenue Analytics',
    author_email='sraododdikindi@revenueanalytics.com',
    description='Maersk RESTful API',
    install_requires=[
        'aniso8601==1.2.1',
		'click==6.7',
		'Flask==0.12.1',
		'Flask-Cors==3.0.2',
		'Flask-RESTful==0.3.5',
		'Flask-Testing==0.6.2',
		'Flask-SQLAlchemy==2.2',
		'itsdangerous==0.24',
		'Jinja2==2.9.6',
		'MarkupSafe==1.0',
		'marshmallow==3.0.0b2',
		'marshmallow-sqlalchemy==0.13.1',
		'nose==1.3.7',
		'pyodbc==4.0.16',
		'python-dateutil==2.6.0',
		'pytz==2017.2',
		'six==1.10.0',
		'SQLAlchemy==1.1.9',
		'Werkzeug==0.12.1'
    ]
)
