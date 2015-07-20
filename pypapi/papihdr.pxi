cimport numpy as np
import numpy as np


np.import_array()


cdef extern from "papi.h" nogil:
    enum: PAPI_VER_CURRENT
    enum: PAPI_OK
    enum: PAPI_NATIVE_MASK
    enum: PAPI_PRESET_MASK
    enum: PAPI_ENUM_ALL
    ctypedef struct PAPI_event_info_t:
        unsigned int event_code
        char *symbol
        char *short_descr
        char *long_descr
        int component_index
        char *units
        int location
        int data_type
        int value_type
        int timescope
        int update_type
        int update_freq
        unsigned int count
        unsigned int event_type

    char *PAPI_strerror(int)
    int PAPI_enum_event(int *, int)
    int PAPI_event_code_to_name(int, char *)
    int PAPI_get_event_info(int, PAPI_event_info_t *)
    int PAPI_query_event(int)
    int PAPI_num_counters()
    int PAPI_start_counters(int *, int)
    int PAPI_read_counters(long long *, int)
    int PAPI_accum_counters(long long *, int)
    int PAPI_stop_counters(long long *, int)

    int PAPI_flips(float *, float *, long long *, float *)
    int PAPI_flops(float *, float *, long long *, float *)
    int PAPI_ipc(float *, float *, long long *, float *)

    int PAPI_library_init(int)
    int PAPI_is_initialized()

    long long PAPI_get_real_cyc()
    long long PAPI_get_real_usec()


cdef inline object S_(const char p[]):
    if p == NULL:
        return None
    cdef object s = <char *>p
    if isinstance(s, str):
        return s
    return s.decode()


cdef inline CHKERR(int ierr):
    if ierr == PAPI_OK:
        return
    raise PAPIError(ierr)


ctypedef int EventType_t
ctypedef long long CountType_t
