include "papihdr.pxi"


__all__ = ["EventType",
           "CountType",
           "Event",
           "num_counters",
           "start_counters",
           "read_counters",
           "accum_counters",
           "stop_counters",
           "flips",
           "flops",
           "ipc",
           "get_cycles_time",
           "get_real_cyc",
           "get_real_usec"]


EventType = np.int32
CountType = np.longlong


class PAPIError(RuntimeError):
    """Exception mapping PAPI error codes to human-readable strings."""
    def __init__(self, code):
        self.code = code
        self.message = S_(PAPI_strerror(code))

    def __str__(self):
        return "PAPI error code %d. %s" % (self.code, self.message)

    def __repr__(self):
        return "PAPIError(%d, %s)" % (self.code, self.message)


class Event(object):
    """A PAPI Event."""
    __events__ = []

    @classmethod
    def describe_events(cls):
        """Describe all :class:`Event`\s"""
        print "Supported events:"
        print "*****************\n"
        for event in cls.__events__:
            ev = getattr(cls, event)
            print ev
            print ""

    def __init__(self, native, info):
        self.code = info["event_code"]
        self.name = info["symbol"]
        self.description = info["short_descr"].strip()
        self.long_description = info["long_descr"].strip()
        self.typ = "native" if native else "preset"
        self.available = info["count"] > 0
        self._info = info

    def __int__(self):
        return self.code

    def __long__(self):
        return self.code

    def __str__(self):
        shortdescr = ""
        longdescr = ""
        if self.description is not "":
            shortdescr=" measuring %s" % self.description
        if self.long_description is not "":
            longdescr = "Additional description: %s" % self.long_description

        return """pypapi.{clsname}.{name}
  A {typ} event{shortdescr}
  {longdescr}""".format(clsname=type(self).__name__,
                   name=self.name,
                   typ=self.typ,
                   shortdescr=shortdescr,
                   longdescr=longdescr)

    def __repr__(self):
        return "%s(%s, %s)" % (type(self).__name__,
                               self.typ, self.name)


def initialize():
    """Initialize PAPI.

    You only need to call this by hand if you intend to use the
    low-level API."""
    cdef int ret

    if PAPI_is_initialized():
        return
    ret = PAPI_library_init(PAPI_VER_CURRENT)
    if ret == PAPI_VER_CURRENT:
        return
    if ret > 0 and ret != PAPI_VER_CURRENT:
        raise RuntimeError("PAPI library version mismatch, wanted %d, got %d",
                           PAPI_VER_CURRENT, ret)
    if ret < 0:
        raise RuntimeError("PAPI library initialization error")


def num_counters():
    """Return the number of available hardware counter slots"""
    return PAPI_num_counters()


def start_counters(np.ndarray[EventType_t, ndim=1] events):
    """Start counting the specified events

    :arg events: A numpy array (of type int32) specifying the events
        to count. See :class:`Event` for valid event values.
    """
    cdef int nevent = events.size
    if nevent > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_start_counters(<EventType_t *>np.PyArray_DATA(events), nevent))


def read_counters(np.ndarray[CountType_t, ndim=1] counts):
    """Read event counter values from PAPI.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be overwritten with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_read_counters(<CountType_t *>np.PyArray_DATA(counts), ncount))
    return counts


def accum_counters(np.ndarray[CountType_t, ndim=1] counts):
    """Accumulate event counter values from PAPI.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be incremented with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_accum_counters(<CountType_t *>np.PyArray_DATA(counts), ncount))

    return counts


def stop_counters(np.ndarray[CountType_t, ndim=1] counts):
    """Stop event counting and read final counts.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be overwritten with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_stop_counters(<CountType_t *>np.PyArray_DATA(counts), ncount))
    return counts


def flips():
    """Start rate counters for floating point instructions per second.

    Returns a tuple of:

        (wall time,
         process time,
         total floating point instructions (flpins),
         millions of flpins / second)

    Since the first call.
    """
    cdef float real_time, proc_time, mflips
    cdef CountType_t flpins

    CHKERR(PAPI_flips(&real_time, &proc_time, &flpins, &mflips))

    return (real_time, proc_time, mflips, flpins)


def flops():
    """Start rate counters for floating point operations per second.

    Returns a tuple of:

        (wall time,
         process time,
         total floating point operations (flpins),
         millions of flops / second)

    Since the first call.
    """
    cdef float real_time, proc_time, mflops
    cdef CountType_t flpins

    CHKERR(PAPI_flops(&real_time, &proc_time, &flpins, &mflops))

    return (real_time, proc_time, mflops, flpins)


def ipc():
    """Start rate counters instructions per cycle.

    Returns a tuple of:

        (wall time,
         process time,
         total instructions issued,
         instructions per cycle)

    Since the first call.
    """
    cdef float real_time, proc_time, ipc
    cdef CountType_t ins

    CHKERR(PAPI_ipc(&real_time, &proc_time, &ins, &ipc))

    return (real_time, proc_time, ins, ipc)


def get_cycles_time():
    """
    Return real cycle counts and timings

    Uses PAPI_get_real_{cyc,usec}
    """
    cdef CountType_t cycles, usec

    cycles = PAPI_get_real_cyc()
    usec = PAPI_get_real_usec()

    return cycles, usec


def get_real_cyc():
    """Return total number of cycles since some arbitrary start point"""
    return PAPI_get_real_cyc()


def get_real_usec():
    """Return total number of microseconds since some arbitrary start point"""
    return PAPI_get_real_usec()


def populate_events():
    """Populate the Event class with all available events"""
    cdef:
        int code
        PAPI_event_info_t info

    initialize()

    for native in (False, True):
        if native:
            code = 0 | PAPI_NATIVE_MASK
        else:
            code = 0 | PAPI_PRESET_MASK
        while True:
            if PAPI_query_event(code) == PAPI_OK:
                CHKERR(PAPI_get_event_info(code, &info))
                event = Event(native, info)
                name = event.name
                name = name.strip()
                if name.startswith("PAPI_"):
                    name = name[5:]
                setattr(Event, name, event)
                Event.__events__.append(name)
            if PAPI_enum_event(&code, PAPI_ENUM_ALL) != PAPI_OK:
                break
