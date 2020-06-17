import os
import uuid
import sys
import json


MAPBOX_API_KEY = os.getenv('MAPBOX_API_KEY', '')

POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD', '')
if POSTGRES_PASSWORD == '':
    password_file = '/run/secrets/superset-postgres-passwd'
    if os.path.exists(password_file):
        with open(password_file, mode='rt') as f:
            POSTGRES_PASSWORD = f.read()
if POSTGRES_PASSWORD == '':
    POSTGRES_PASSWORD = 'superset'     

""" SECRET_KEY = os.getenv('SECRET_KEY', '')
if SECRET_KEY == '':
    secret_key_file = '/run/secrets/superset-secret-key'
    if os.path.exists(secret_key_file):
        with open(secret_key_file, mode='rt') as f:
            SECRET_KEY = f.read()  """
    
SECRET_KEY = str(uuid.uuid1()).replace('-','')
 

CACHE_CONFIG = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 300,
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_HOST': 'redis',
    'CACHE_REDIS_PORT': 6379,
    'CACHE_REDIS_DB': 1,
    'CACHE_REDIS_URL': 'redis://redis:6379/1'
}

SQLALCHEMY_DATABASE_URI = \
    f'postgresql+psycopg2://superset:{POSTGRES_PASSWORD}@postgres:5432/superset'

SQLALCHEMY_TRACK_MODIFICATIONS = True


#SESSION_COOKIE_DOMAIN= 'docker.local'

#SESSION_COOKIE_SAMESITE = None

#SESSION_COOKIE_HTTPONLY = True

#WTF_CSRF_ENABLED = False

#WTF_CSRF_TIME_LIMIT = None

#WTF_CSRF_SECRET_KEY = SECRET_KEY

ENABLE_PROXY_FIX = True

WTF_CSRF_FIELD_NAME = 'CSRFTOKEN'

WTF_CSRF_EXEMPT_LIST = ['/superset/recent_activity', '/superset/fave_slices']

#ENABLE_CORS = True


