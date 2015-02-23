from os import environ

from base import *


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': environ.get('DATABASE_NAME', 'example_dev'),
        'USER': environ.get('DATABASE_USER', 'vagrant'),
        'PASSWORD': environ.get('DATABASE_PASSWORD', 'vagrant'),
        'HOST': environ.get('DATABASE_HOST', '127.0.0.1'),
        'PORT': environ.get('DATABASE_PORT', '5432'),
    }
}


STATIC_ROOT = 'backend_path/static'

########## HOST CONFIGURATION
# See: https://docs.djangoproject.com/en/1.7/ref/settings/#allowed-hosts
ALLOWED_HOSTS = ['127.0.0.1']
########## END HOST CONFIGURATION

DEBUG = False

########## CACHE CONFIGURATION
# See: https://docs.djangoproject.com/en/dev/ref/settings/#caches
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    }
}
