from __future__ import absolute_import

# Event types
from pypapi.papi import *    # noqa: flake8 can't deal with Cython

from pypapi.papi import populate_events

populate_events()

del populate_events
