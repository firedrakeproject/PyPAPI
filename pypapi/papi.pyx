include "papihdr.pxi"


EventType = np.int32
CountType = np.longlong


class PAPIError(RuntimeError):
    """Exception mapping PAPI error codes to human-readable strings."""
    OK = PAPI_OK
    EINVAL = PAPI_EINVAL
    ENOMEM = PAPI_ENOMEM
    ESYS = PAPI_ESYS
    ECMP = PAPI_ECMP
    ECLOST = PAPI_ECLOST
    EBUG = PAPI_EBUG
    ENOEVNT = PAPI_ENOEVNT
    ENOTRUN = PAPI_ENOTRUN
    EISRUN = PAPI_EISRUN
    ENOEVST = PAPI_ENOEVST
    ENOTPRESET = PAPI_ENOTPRESET
    ENOCNTR = PAPI_ENOCNTR
    EMISC = PAPI_EMISC
    EPERM = PAPI_EPERM
    ENOINIT = PAPI_ENOINIT
    ENOCMP = PAPI_ENOCMP
    ENOSUPP = PAPI_ENOSUPP
    ENOIMPL = PAPI_ENOIMPL
    EBUF = PAPI_EBUF
    EINVAL_DOM = PAPI_EINVAL_DOM
    EATTR = PAPI_EATTR
    ECOUNT = PAPI_ECOUNT
    ECOMBO = PAPI_ECOMBO

    mapping = {OK: "PAPI_OK: No error",
               EINVAL: "PAPI_EINVAL: Invalid argument",
               ENOMEM: "PAPI_ENOMEM: Insufficient memory",
               ESYS: "PAPI_ESYS: Syscall failed",
               ECMP: "PAPI_ECMP: Not supported by component",
               ECLOST: "PAPI_ECLOST: Counter access lost",
               EBUG: "PAPI_EBUG: Internal error, send mail",
               ENOEVNT: "PAPI_ENOEVNT: Event does not exist",
               ENOTRUN: "PAPI_ENOTRUN: EventSet not running",
               EISRUN: "PAPI_EISRUN: EventSet currently counting",
               ENOEVST: "PAPI_ENOEVST: No such EventSet",
               ENOTPRESET: "PAPI_ENOTPRESET: Not a valid preset",
               ENOCNTR: "PAPI_ENOCNTR: Hardware doesn't support perf counters",
               EMISC: "PAPI_EMISC: Unknown error",
               EPERM: "PAPI_EPERM: Permissions violation",
               ENOINIT: "PAPI_ENOINIT: not yet initialized",
               ENOCMP: "PAPI_ENOCMP: Component index not set",
               ENOSUPP: "PAPI_ENOSUPP: Not supported",
               ENOIMPL: "PAPI_ENOIMPL: Not implemented",
               EBUF: "PAPI_EBUF: Buffer size exceeded",
               EINVAL_DOM: "PAPI_EINVAL_DOM: EventSet domain not supported for operation",
               EATTR: "PAPI_EATTR: Invalid event attribute",
               ECOUNT: "PAPI_ECOUNT: Too many events/attributes",
               ECOMBO: "PAPI_ECOMBO: Bad combination of features"}

    def __init__(self, code):
        self.code = code
        self.msg = PAPIError.mapping[code]

    def __str__(self):
        return "PAPI error.  %s" % self.msg

    def __repr__(self):
        return "PAPIError(%d, %s)" % (self.code, self.msg)


class Event(object):
    """Enumeration of preset PAPI event types.

    Not all will necessarily be supported by your hardware."""
    L1_DCM = PAPI_L1_DCM
    L1_ICM = PAPI_L1_ICM
    L2_DCM = PAPI_L2_DCM
    L2_ICM = PAPI_L2_ICM
    L3_DCM = PAPI_L3_DCM
    L3_ICM = PAPI_L3_ICM
    L1_TCM = PAPI_L1_TCM
    L2_TCM = PAPI_L2_TCM
    L3_TCM = PAPI_L3_TCM
    CA_SNP = PAPI_CA_SNP
    CA_SHR = PAPI_CA_SHR
    CA_CLN = PAPI_CA_CLN
    CA_INV = PAPI_CA_INV
    CA_ITV = PAPI_CA_ITV
    L3_LDM = PAPI_L3_LDM
    L3_STM = PAPI_L3_STM
    BRU_IDL = PAPI_BRU_IDL
    FXU_IDL = PAPI_FXU_IDL
    FPU_IDL = PAPI_FPU_IDL
    LSU_IDL = PAPI_LSU_IDL
    TLB_DM = PAPI_TLB_DM
    TLB_IM = PAPI_TLB_IM
    TLB_TL = PAPI_TLB_TL
    L1_LDM = PAPI_L1_LDM
    L1_STM = PAPI_L1_STM
    L2_LDM = PAPI_L2_LDM
    L2_STM = PAPI_L2_STM
    BTAC_M = PAPI_BTAC_M
    PRF_DM = PAPI_PRF_DM
    L3_DCH = PAPI_L3_DCH
    TLB_SD = PAPI_TLB_SD
    CSR_FAL = PAPI_CSR_FAL
    CSR_SUC = PAPI_CSR_SUC
    CSR_TOT = PAPI_CSR_TOT
    MEM_SCY = PAPI_MEM_SCY
    MEM_RCY = PAPI_MEM_RCY
    MEM_WCY = PAPI_MEM_WCY
    STL_ICY = PAPI_STL_ICY
    FUL_ICY = PAPI_FUL_ICY
    STL_CCY = PAPI_STL_CCY
    FUL_CCY = PAPI_FUL_CCY
    HW_INT = PAPI_HW_INT
    BR_UCN = PAPI_BR_UCN
    BR_CN = PAPI_BR_CN
    BR_TKN = PAPI_BR_TKN
    BR_NTK = PAPI_BR_NTK
    BR_MSP = PAPI_BR_MSP
    BR_PRC = PAPI_BR_PRC
    FMA_INS = PAPI_FMA_INS
    TOT_IIS = PAPI_TOT_IIS
    TOT_INS = PAPI_TOT_INS
    INT_INS = PAPI_INT_INS
    FP_INS = PAPI_FP_INS
    LD_INS = PAPI_LD_INS
    SR_INS = PAPI_SR_INS
    BR_INS = PAPI_BR_INS
    VEC_INS = PAPI_VEC_INS
    RES_STL = PAPI_RES_STL
    FP_STAL = PAPI_FP_STAL
    TOT_CYC = PAPI_TOT_CYC
    LST_INS = PAPI_LST_INS
    SYC_INS = PAPI_SYC_INS
    L1_DCH = PAPI_L1_DCH
    L2_DCH = PAPI_L2_DCH
    L1_DCA = PAPI_L1_DCA
    L2_DCA = PAPI_L2_DCA
    L3_DCA = PAPI_L3_DCA
    L1_DCR = PAPI_L1_DCR
    L2_DCR = PAPI_L2_DCR
    L3_DCR = PAPI_L3_DCR
    L1_DCW = PAPI_L1_DCW
    L2_DCW = PAPI_L2_DCW
    L3_DCW = PAPI_L3_DCW
    L1_ICH = PAPI_L1_ICH
    L2_ICH = PAPI_L2_ICH
    L3_ICH = PAPI_L3_ICH
    L1_ICA = PAPI_L1_ICA
    L2_ICA = PAPI_L2_ICA
    L3_ICA = PAPI_L3_ICA
    L1_ICR = PAPI_L1_ICR
    L2_ICR = PAPI_L2_ICR
    L3_ICR = PAPI_L3_ICR
    L1_ICW = PAPI_L1_ICW
    L2_ICW = PAPI_L2_ICW
    L3_ICW = PAPI_L3_ICW
    L1_TCH = PAPI_L1_TCH
    L2_TCH = PAPI_L2_TCH
    L3_TCH = PAPI_L3_TCH
    L1_TCA = PAPI_L1_TCA
    L2_TCA = PAPI_L2_TCA
    L3_TCA = PAPI_L3_TCA
    L1_TCR = PAPI_L1_TCR
    L2_TCR = PAPI_L2_TCR
    L3_TCR = PAPI_L3_TCR
    L1_TCW = PAPI_L1_TCW
    L2_TCW = PAPI_L2_TCW
    L3_TCW = PAPI_L3_TCW
    FML_INS = PAPI_FML_INS
    FAD_INS = PAPI_FAD_INS
    FDV_INS = PAPI_FDV_INS
    FSQ_INS = PAPI_FSQ_INS
    FNV_INS = PAPI_FNV_INS
    FP_OPS = PAPI_FP_OPS
    SP_OPS = PAPI_SP_OPS
    DP_OPS = PAPI_DP_OPS
    VEC_SP = PAPI_VEC_SP
    VEC_DP = PAPI_VEC_DP
    REF_CYC = PAPI_REF_CYC


cdef inline CHKERR(int ierr):
    if ierr == PAPI_OK:
        return
    raise PAPIError(ierr)


def initialize():
    """Initialize PAPI.

    You only need to call this by hand if you intend to use the
    low-level API."""
    cdef int ret

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


def start_counters(np.ndarray[int, ndim=1] events):
    """Start counting the specified events

    :arg events: A numpy array (of type int32) specifying the events
        to count. See :class:`Event` for valid event values.
    """
    cdef int nevent = events.size
    if nevent > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_start_counters(<int *>np.PyArray_DATA(events), nevent))


def read_counters(np.ndarray[long long, ndim=1] counts):
    """Read event counter values from PAPI.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be overwritten with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_read_counters(<long long *>np.PyArray_DATA(counts), ncount))
    return counts


def accum_counters(np.ndarray[long long, ndim=1] counts):
    """Accumulate event counter values from PAPI.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be incremented with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_accum_counters(<long long *>np.PyArray_DATA(counts), ncount))

    return counts


def stop_counters(np.ndarray[long long, ndim=1] counts):
    """Stop event counting and read final counts.

    :arg counts: A numpy array (of type longlong) large enough to hold
        counts for as many events as were asked for with
        :func:`start_counters`.  Values will be overwritten with the
        current PAPI counts.
    """
    cdef int ncount = counts.size
    if ncount > PAPI_num_counters():
        raise RuntimeError("Asked for more events than counters")

    CHKERR(PAPI_stop_counters(<long long *>np.PyArray_DATA(counts), ncount))
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
    cdef long long flpins

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
    cdef long long flpins

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
    cdef long long ins

    CHKERR(PAPI_ipc(&real_time, &proc_time, &ins, &ipc))

    return (real_time, proc_time, ins, ipc)
