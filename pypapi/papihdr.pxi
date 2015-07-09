cimport numpy as np
import numpy as np

np.import_array()

cdef extern from "papi.h":
    enum:
        PAPI_L1_DCM
        PAPI_L1_ICM
        PAPI_L2_DCM
        PAPI_L2_ICM
        PAPI_L3_DCM
        PAPI_L3_ICM
        PAPI_L1_TCM
        PAPI_L2_TCM
        PAPI_L3_TCM
        PAPI_CA_SNP
        PAPI_CA_SHR
        PAPI_CA_CLN
        PAPI_CA_INV
        PAPI_CA_ITV
        PAPI_L3_LDM
        PAPI_L3_STM
        PAPI_BRU_IDL
        PAPI_FXU_IDL
        PAPI_FPU_IDL
        PAPI_LSU_IDL
        PAPI_TLB_DM
        PAPI_TLB_IM
        PAPI_TLB_TL
        PAPI_L1_LDM
        PAPI_L1_STM
        PAPI_L2_LDM
        PAPI_L2_STM
        PAPI_BTAC_M
        PAPI_PRF_DM
        PAPI_L3_DCH
        PAPI_TLB_SD
        PAPI_CSR_FAL
        PAPI_CSR_SUC
        PAPI_CSR_TOT
        PAPI_MEM_SCY
        PAPI_MEM_RCY
        PAPI_MEM_WCY
        PAPI_STL_ICY
        PAPI_FUL_ICY
        PAPI_STL_CCY
        PAPI_FUL_CCY
        PAPI_HW_INT
        PAPI_BR_UCN
        PAPI_BR_CN
        PAPI_BR_TKN
        PAPI_BR_NTK
        PAPI_BR_MSP
        PAPI_BR_PRC
        PAPI_FMA_INS
        PAPI_TOT_IIS
        PAPI_TOT_INS
        PAPI_INT_INS
        PAPI_FP_INS
        PAPI_LD_INS
        PAPI_SR_INS
        PAPI_BR_INS
        PAPI_VEC_INS
        PAPI_RES_STL
        PAPI_FP_STAL
        PAPI_TOT_CYC
        PAPI_LST_INS
        PAPI_SYC_INS
        PAPI_L1_DCH
        PAPI_L2_DCH
        PAPI_L1_DCA
        PAPI_L2_DCA
        PAPI_L3_DCA
        PAPI_L1_DCR
        PAPI_L2_DCR
        PAPI_L3_DCR
        PAPI_L1_DCW
        PAPI_L2_DCW
        PAPI_L3_DCW
        PAPI_L1_ICH
        PAPI_L2_ICH
        PAPI_L3_ICH
        PAPI_L1_ICA
        PAPI_L2_ICA
        PAPI_L3_ICA
        PAPI_L1_ICR
        PAPI_L2_ICR
        PAPI_L3_ICR
        PAPI_L1_ICW
        PAPI_L2_ICW
        PAPI_L3_ICW
        PAPI_L1_TCH
        PAPI_L2_TCH
        PAPI_L3_TCH
        PAPI_L1_TCA
        PAPI_L2_TCA
        PAPI_L3_TCA
        PAPI_L1_TCR
        PAPI_L2_TCR
        PAPI_L3_TCR
        PAPI_L1_TCW
        PAPI_L2_TCW
        PAPI_L3_TCW
        PAPI_FML_INS
        PAPI_FAD_INS
        PAPI_FDV_INS
        PAPI_FSQ_INS
        PAPI_FNV_INS
        PAPI_FP_OPS
        PAPI_SP_OPS
        PAPI_DP_OPS
        PAPI_VEC_SP
        PAPI_VEC_DP
        PAPI_REF_CYC

    enum: PAPI_VER_CURRENT
    enum:
        PAPI_OK
        PAPI_EINVAL
        PAPI_ENOMEM
        PAPI_ESYS
        PAPI_ECMP
        PAPI_ECLOST
        PAPI_EBUG
        PAPI_ENOEVNT
        PAPI_ENOTRUN
        PAPI_EISRUN
        PAPI_ENOEVST
        PAPI_ENOTPRESET
        PAPI_ENOCNTR
        PAPI_EMISC
        PAPI_EPERM
        PAPI_ENOINIT
        PAPI_ENOCMP
        PAPI_ENOSUPP
        PAPI_ENOIMPL
        PAPI_EBUF
        PAPI_EINVAL_DOM
        PAPI_EATTR
        PAPI_ECOUNT
        PAPI_ECOMBO

    int PAPI_num_counters()
    int PAPI_start_counters(int *, int)
    int PAPI_read_counters(long long *, int)
    int PAPI_accum_counters(long long *, int)
    int PAPI_stop_counters(long long *, int)

    int PAPI_flips(float *, float *, long long *, float *)
    int PAPI_flops(float *, float *, long long *, float *)
    int PAPI_ipc(float *, float *, long long *, float *)

    int PAPI_library_init(int)
