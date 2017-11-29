# We need to do this weird MY_LOCAL_PATH thing because otherwise
# inluding subfolder Android.mk files break in very weird ways:
# https://stackoverflow.com/a/33263540/1634837
MY_LOCAL_PATH := $(call my-dir)
LOCAL_PATH := $(MY_LOCAL_PATH)

LOCAL_MODULE    := avutil 

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    FFMPEG_INCLUDE_PATH := $(LOCAL_PATH)/ffmpeg/android/armv7-a/include
    LOCAL_SRC_FILES := ./ffmpeg/android/armv7-a/lib/libavutil.a
else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
        FFMPEG_INCLUDE_PATH := $(LOCAL_PATH)/ffmpeg/android/armv5te/include
        LOCAL_SRC_FILES := ./ffmpeg/android/armv5te/lib/libavutil.a
    else
        ifeq ($(TARGET_ARCH_ABI),x86)
            FFMPEG_INCLUDE_PATH := $(LOCAL_PATH)/ffmpeg/android/i686/include
            LOCAL_SRC_FILES := ./ffmpeg/android/i686/lib/libavutil.a
        endif
    endif
endif

include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := avformat

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_SRC_FILES := ./ffmpeg/android/armv7-a/lib/libavformat.a
else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_SRC_FILES := ./ffmpeg/android/armv5te/lib/libavformat.a
    else
        ifeq ($(TARGET_ARCH_ABI),x86)
	    LOCAL_SRC_FILES := ./ffmpeg/android/i686/lib/libavformat.a
        endif
    endif
endif

include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := avcodec 

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_SRC_FILES := ./ffmpeg/android/armv7-a/lib/libavcodec.a
else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_SRC_FILES := ./ffmpeg/android/armv5te/lib/libavcodec.a
    else
        ifeq ($(TARGET_ARCH_ABI),x86)
	    LOCAL_SRC_FILES := ./ffmpeg/android/i686/lib/libavcodec.a
        endif
    endif
endif

include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := swresample

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_SRC_FILES := ./ffmpeg/android/armv7-a/lib/libswresample.a
else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_SRC_FILES := ./ffmpeg/android/armv5te/lib/libswresample.a
    else
        ifeq ($(TARGET_ARCH_ABI),x86)
	    LOCAL_SRC_FILES := ./ffmpeg/android/i686/lib/libswresample.a
        endif
    endif
endif

include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

CRYPTO_PATH:= ./openssl/crypto

arm_cflags := -DOPENSSL_BN_ASM_MONT -DAES_ASM -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM

local_src_files := \
	$(CRYPTO_PATH)/cryptlib.c \
	$(CRYPTO_PATH)/mem.c \
	$(CRYPTO_PATH)/mem_clr.c \
	$(CRYPTO_PATH)/mem_dbg.c \
	$(CRYPTO_PATH)/cversion.c \
	$(CRYPTO_PATH)/ex_data.c \
	$(CRYPTO_PATH)/cpt_err.c \
	$(CRYPTO_PATH)/ebcdic.c \
	$(CRYPTO_PATH)/uid.c \
	$(CRYPTO_PATH)/o_time.c \
	$(CRYPTO_PATH)/o_str.c \
	$(CRYPTO_PATH)/o_dir.c \
	$(CRYPTO_PATH)/o_init.c \
	$(CRYPTO_PATH)/aes/aes_cbc.c \
	$(CRYPTO_PATH)/aes/aes_core.c \
	$(CRYPTO_PATH)/aes/aes_cfb.c \
	$(CRYPTO_PATH)/aes/aes_ctr.c \
	$(CRYPTO_PATH)/aes/aes_ecb.c \
	$(CRYPTO_PATH)/aes/aes_ige.c \
	$(CRYPTO_PATH)/aes/aes_misc.c \
	$(CRYPTO_PATH)/aes/aes_ofb.c \
	$(CRYPTO_PATH)/aes/aes_wrap.c \
	$(CRYPTO_PATH)/asn1/a_bitstr.c \
	$(CRYPTO_PATH)/asn1/a_bool.c \
	$(CRYPTO_PATH)/asn1/a_bytes.c \
	$(CRYPTO_PATH)/asn1/a_d2i_fp.c \
	$(CRYPTO_PATH)/asn1/a_digest.c \
	$(CRYPTO_PATH)/asn1/a_dup.c \
	$(CRYPTO_PATH)/asn1/a_enum.c \
	$(CRYPTO_PATH)/asn1/a_gentm.c \
	$(CRYPTO_PATH)/asn1/a_i2d_fp.c \
	$(CRYPTO_PATH)/asn1/a_int.c \
	$(CRYPTO_PATH)/asn1/a_mbstr.c \
	$(CRYPTO_PATH)/asn1/a_object.c \
	$(CRYPTO_PATH)/asn1/a_octet.c \
	$(CRYPTO_PATH)/asn1/a_print.c \
	$(CRYPTO_PATH)/asn1/a_set.c \
	$(CRYPTO_PATH)/asn1/a_sign.c \
	$(CRYPTO_PATH)/asn1/a_strex.c \
	$(CRYPTO_PATH)/asn1/a_strnid.c \
	$(CRYPTO_PATH)/asn1/a_time.c \
	$(CRYPTO_PATH)/asn1/a_type.c \
	$(CRYPTO_PATH)/asn1/a_utctm.c \
	$(CRYPTO_PATH)/asn1/a_utf8.c \
	$(CRYPTO_PATH)/asn1/a_verify.c \
	$(CRYPTO_PATH)/asn1/ameth_lib.c \
	$(CRYPTO_PATH)/asn1/asn1_err.c \
	$(CRYPTO_PATH)/asn1/asn1_gen.c \
	$(CRYPTO_PATH)/asn1/asn1_lib.c \
	$(CRYPTO_PATH)/asn1/asn1_par.c \
	$(CRYPTO_PATH)/asn1/asn_mime.c \
	$(CRYPTO_PATH)/asn1/asn_moid.c \
	$(CRYPTO_PATH)/asn1/asn_pack.c \
	$(CRYPTO_PATH)/asn1/bio_asn1.c \
	$(CRYPTO_PATH)/asn1/bio_ndef.c \
	$(CRYPTO_PATH)/asn1/d2i_pr.c \
	$(CRYPTO_PATH)/asn1/d2i_pu.c \
	$(CRYPTO_PATH)/asn1/evp_asn1.c \
	$(CRYPTO_PATH)/asn1/f_enum.c \
	$(CRYPTO_PATH)/asn1/f_int.c \
	$(CRYPTO_PATH)/asn1/f_string.c \
	$(CRYPTO_PATH)/asn1/i2d_pr.c \
	$(CRYPTO_PATH)/asn1/i2d_pu.c \
	$(CRYPTO_PATH)/asn1/n_pkey.c \
	$(CRYPTO_PATH)/asn1/nsseq.c \
	$(CRYPTO_PATH)/asn1/p5_pbe.c \
	$(CRYPTO_PATH)/asn1/p5_pbev2.c \
	$(CRYPTO_PATH)/asn1/p8_pkey.c \
	$(CRYPTO_PATH)/asn1/t_bitst.c \
	$(CRYPTO_PATH)/asn1/t_crl.c \
	$(CRYPTO_PATH)/asn1/t_pkey.c \
	$(CRYPTO_PATH)/asn1/t_req.c \
	$(CRYPTO_PATH)/asn1/t_spki.c \
	$(CRYPTO_PATH)/asn1/t_x509.c \
	$(CRYPTO_PATH)/asn1/t_x509a.c \
	$(CRYPTO_PATH)/asn1/tasn_dec.c \
	$(CRYPTO_PATH)/asn1/tasn_enc.c \
	$(CRYPTO_PATH)/asn1/tasn_fre.c \
	$(CRYPTO_PATH)/asn1/tasn_new.c \
	$(CRYPTO_PATH)/asn1/tasn_prn.c \
	$(CRYPTO_PATH)/asn1/tasn_typ.c \
	$(CRYPTO_PATH)/asn1/tasn_utl.c \
	$(CRYPTO_PATH)/asn1/x_algor.c \
	$(CRYPTO_PATH)/asn1/x_attrib.c \
	$(CRYPTO_PATH)/asn1/x_bignum.c \
	$(CRYPTO_PATH)/asn1/x_crl.c \
	$(CRYPTO_PATH)/asn1/x_exten.c \
	$(CRYPTO_PATH)/asn1/x_info.c \
	$(CRYPTO_PATH)/asn1/x_long.c \
	$(CRYPTO_PATH)/asn1/x_name.c \
	$(CRYPTO_PATH)/asn1/x_nx509.c \
	$(CRYPTO_PATH)/asn1/x_pkey.c \
	$(CRYPTO_PATH)/asn1/x_pubkey.c \
	$(CRYPTO_PATH)/asn1/x_req.c \
	$(CRYPTO_PATH)/asn1/x_sig.c \
	$(CRYPTO_PATH)/asn1/x_spki.c \
	$(CRYPTO_PATH)/asn1/x_val.c \
	$(CRYPTO_PATH)/asn1/x_x509.c \
	$(CRYPTO_PATH)/asn1/x_x509a.c \
	$(CRYPTO_PATH)/bf/bf_cfb64.c \
	$(CRYPTO_PATH)/bf/bf_ecb.c \
	$(CRYPTO_PATH)/bf/bf_enc.c \
	$(CRYPTO_PATH)/bf/bf_ofb64.c \
	$(CRYPTO_PATH)/bf/bf_skey.c \
	$(CRYPTO_PATH)/bio/b_dump.c \
	$(CRYPTO_PATH)/bio/b_print.c \
	$(CRYPTO_PATH)/bio/b_sock.c \
	$(CRYPTO_PATH)/bio/bf_buff.c \
	$(CRYPTO_PATH)/bio/bf_nbio.c \
	$(CRYPTO_PATH)/bio/bf_null.c \
	$(CRYPTO_PATH)/bio/bio_cb.c \
	$(CRYPTO_PATH)/bio/bio_err.c \
	$(CRYPTO_PATH)/bio/bio_lib.c \
	$(CRYPTO_PATH)/bio/bss_acpt.c \
	$(CRYPTO_PATH)/bio/bss_bio.c \
	$(CRYPTO_PATH)/bio/bss_conn.c \
	$(CRYPTO_PATH)/bio/bss_dgram.c \
	$(CRYPTO_PATH)/bio/bss_fd.c \
	$(CRYPTO_PATH)/bio/bss_file.c \
	$(CRYPTO_PATH)/bio/bss_log.c \
	$(CRYPTO_PATH)/bio/bss_mem.c \
	$(CRYPTO_PATH)/bio/bss_null.c \
	$(CRYPTO_PATH)/bio/bss_sock.c \
	$(CRYPTO_PATH)/bn/bn_add.c \
	$(CRYPTO_PATH)/bn/bn_asm.c \
	$(CRYPTO_PATH)/bn/bn_blind.c \
	$(CRYPTO_PATH)/bn/bn_ctx.c \
	$(CRYPTO_PATH)/bn/bn_div.c \
	$(CRYPTO_PATH)/bn/bn_err.c \
	$(CRYPTO_PATH)/bn/bn_exp.c \
	$(CRYPTO_PATH)/bn/bn_exp2.c \
	$(CRYPTO_PATH)/bn/bn_gcd.c \
	$(CRYPTO_PATH)/bn/bn_gf2m.c \
	$(CRYPTO_PATH)/bn/bn_kron.c \
	$(CRYPTO_PATH)/bn/bn_lib.c \
	$(CRYPTO_PATH)/bn/bn_mod.c \
	$(CRYPTO_PATH)/bn/bn_mont.c \
	$(CRYPTO_PATH)/bn/bn_mpi.c \
	$(CRYPTO_PATH)/bn/bn_mul.c \
	$(CRYPTO_PATH)/bn/bn_nist.c \
	$(CRYPTO_PATH)/bn/bn_prime.c \
	$(CRYPTO_PATH)/bn/bn_print.c \
	$(CRYPTO_PATH)/bn/bn_rand.c \
	$(CRYPTO_PATH)/bn/bn_recp.c \
	$(CRYPTO_PATH)/bn/bn_shift.c \
	$(CRYPTO_PATH)/bn/bn_sqr.c \
	$(CRYPTO_PATH)/bn/bn_sqrt.c \
	$(CRYPTO_PATH)/bn/bn_word.c \
	$(CRYPTO_PATH)/buffer/buf_err.c \
	$(CRYPTO_PATH)/buffer/buf_str.c \
	$(CRYPTO_PATH)/buffer/buffer.c \
	$(CRYPTO_PATH)/cmac/cm_ameth.c \
	$(CRYPTO_PATH)/cmac/cm_pmeth.c \
	$(CRYPTO_PATH)/cmac/cmac.c \
    ${CRYPTO_PATH}/cms/cms_asn1.c \
    ${CRYPTO_PATH}/cms/cms_att.c \
    ${CRYPTO_PATH}/cms/cms_cd.c \
    ${CRYPTO_PATH}/cms/cms_dd.c \
    ${CRYPTO_PATH}/cms/cms_enc.c \
    ${CRYPTO_PATH}/cms/cms_env.c \
    ${CRYPTO_PATH}/cms/cms_err.c \
    ${CRYPTO_PATH}/cms/cms_ess.c \
    ${CRYPTO_PATH}/cms/cms_io.c \
    ${CRYPTO_PATH}/cms/cms_kari.c \
    ${CRYPTO_PATH}/cms/cms_lib.c \
    ${CRYPTO_PATH}/cms/cms_pwri.c \
    ${CRYPTO_PATH}/cms/cms_sd.c \
    ${CRYPTO_PATH}/cms/cms_smime.c \
	$(CRYPTO_PATH)/comp/c_rle.c \
	$(CRYPTO_PATH)/comp/c_zlib.c \
	$(CRYPTO_PATH)/comp/comp_err.c \
	$(CRYPTO_PATH)/comp/comp_lib.c \
	$(CRYPTO_PATH)/conf/conf_api.c \
	$(CRYPTO_PATH)/conf/conf_def.c \
	$(CRYPTO_PATH)/conf/conf_err.c \
	$(CRYPTO_PATH)/conf/conf_lib.c \
	$(CRYPTO_PATH)/conf/conf_mall.c \
	$(CRYPTO_PATH)/conf/conf_mod.c \
	$(CRYPTO_PATH)/conf/conf_sap.c \
	$(CRYPTO_PATH)/des/cbc_cksm.c \
	$(CRYPTO_PATH)/des/cbc_enc.c \
	$(CRYPTO_PATH)/des/cfb64ede.c \
	$(CRYPTO_PATH)/des/cfb64enc.c \
	$(CRYPTO_PATH)/des/cfb_enc.c \
	$(CRYPTO_PATH)/des/des_enc.c \
	$(CRYPTO_PATH)/des/des_old.c \
	$(CRYPTO_PATH)/des/des_old2.c \
	$(CRYPTO_PATH)/des/ecb3_enc.c \
	$(CRYPTO_PATH)/des/ecb_enc.c \
	$(CRYPTO_PATH)/des/ede_cbcm_enc.c \
	$(CRYPTO_PATH)/des/enc_read.c \
	$(CRYPTO_PATH)/des/enc_writ.c \
	$(CRYPTO_PATH)/des/fcrypt.c \
	$(CRYPTO_PATH)/des/fcrypt_b.c \
	$(CRYPTO_PATH)/des/ofb64ede.c \
	$(CRYPTO_PATH)/des/ofb64enc.c \
	$(CRYPTO_PATH)/des/ofb_enc.c \
	$(CRYPTO_PATH)/des/pcbc_enc.c \
	$(CRYPTO_PATH)/des/qud_cksm.c \
	$(CRYPTO_PATH)/des/rand_key.c \
	$(CRYPTO_PATH)/des/read2pwd.c \
	$(CRYPTO_PATH)/des/rpc_enc.c \
	$(CRYPTO_PATH)/des/set_key.c \
	$(CRYPTO_PATH)/des/str2key.c \
	$(CRYPTO_PATH)/des/xcbc_enc.c \
	$(CRYPTO_PATH)/dh/dh_ameth.c \
	$(CRYPTO_PATH)/dh/dh_asn1.c \
	$(CRYPTO_PATH)/dh/dh_check.c \
	$(CRYPTO_PATH)/dh/dh_depr.c \
	$(CRYPTO_PATH)/dh/dh_err.c \
	$(CRYPTO_PATH)/dh/dh_gen.c \
	$(CRYPTO_PATH)/dh/dh_key.c \
	$(CRYPTO_PATH)/dh/dh_lib.c \
	$(CRYPTO_PATH)/dh/dh_pmeth.c \
	$(CRYPTO_PATH)/dh/dh_rfc5114.c \
	$(CRYPTO_PATH)/dh/dh_kdf.c \
	$(CRYPTO_PATH)/dsa/dsa_ameth.c \
	$(CRYPTO_PATH)/dsa/dsa_asn1.c \
	$(CRYPTO_PATH)/dsa/dsa_depr.c \
	$(CRYPTO_PATH)/dsa/dsa_err.c \
	$(CRYPTO_PATH)/dsa/dsa_gen.c \
	$(CRYPTO_PATH)/dsa/dsa_key.c \
	$(CRYPTO_PATH)/dsa/dsa_lib.c \
	$(CRYPTO_PATH)/dsa/dsa_ossl.c \
	$(CRYPTO_PATH)/dsa/dsa_pmeth.c \
	$(CRYPTO_PATH)/dsa/dsa_prn.c \
	$(CRYPTO_PATH)/dsa/dsa_sign.c \
	$(CRYPTO_PATH)/dsa/dsa_vrf.c \
	$(CRYPTO_PATH)/dso/dso_dl.c \
	$(CRYPTO_PATH)/dso/dso_dlfcn.c \
	$(CRYPTO_PATH)/dso/dso_err.c \
	$(CRYPTO_PATH)/dso/dso_lib.c \
	$(CRYPTO_PATH)/dso/dso_null.c \
	$(CRYPTO_PATH)/dso/dso_openssl.c \
	$(CRYPTO_PATH)/dso/dso_vms.c \
	$(CRYPTO_PATH)/dso/dso_win32.c \
	$(CRYPTO_PATH)/ec/ec2_mult.c \
	$(CRYPTO_PATH)/ec/ec2_oct.c \
	$(CRYPTO_PATH)/ec/ec2_smpl.c \
	$(CRYPTO_PATH)/ec/ec_ameth.c \
	$(CRYPTO_PATH)/ec/ec_asn1.c \
	$(CRYPTO_PATH)/ec/ec_check.c \
	$(CRYPTO_PATH)/ec/ec_curve.c \
	$(CRYPTO_PATH)/ec/ec_cvt.c \
	$(CRYPTO_PATH)/ec/ec_err.c \
	$(CRYPTO_PATH)/ec/ec_key.c \
	$(CRYPTO_PATH)/ec/ec_lib.c \
	$(CRYPTO_PATH)/ec/ec_mult.c \
	$(CRYPTO_PATH)/ec/ec_oct.c \
	$(CRYPTO_PATH)/ec/ec_pmeth.c \
	$(CRYPTO_PATH)/ec/ec_print.c \
	$(CRYPTO_PATH)/ec/eck_prn.c \
	$(CRYPTO_PATH)/ec/ecp_mont.c \
	$(CRYPTO_PATH)/ec/ecp_nist.c \
	$(CRYPTO_PATH)/ec/ecp_nistp224.c \
	$(CRYPTO_PATH)/ec/ecp_nistp256.c \
	$(CRYPTO_PATH)/ec/ecp_nistp521.c \
	$(CRYPTO_PATH)/ec/ecp_nistputil.c \
	$(CRYPTO_PATH)/ec/ecp_oct.c \
	$(CRYPTO_PATH)/ec/ecp_smpl.c \
	$(CRYPTO_PATH)/ecdh/ech_err.c \
	$(CRYPTO_PATH)/ecdh/ech_key.c \
	$(CRYPTO_PATH)/ecdh/ech_lib.c \
	$(CRYPTO_PATH)/ecdh/ech_ossl.c \
	$(CRYPTO_PATH)/ecdh/ech_kdf.c \
	$(CRYPTO_PATH)/ecdsa/ecs_asn1.c \
	$(CRYPTO_PATH)/ecdsa/ecs_err.c \
	$(CRYPTO_PATH)/ecdsa/ecs_lib.c \
	$(CRYPTO_PATH)/ecdsa/ecs_ossl.c \
	$(CRYPTO_PATH)/ecdsa/ecs_sign.c \
	$(CRYPTO_PATH)/ecdsa/ecs_vrf.c \
	$(CRYPTO_PATH)/err/err.c \
	$(CRYPTO_PATH)/err/err_all.c \
	$(CRYPTO_PATH)/err/err_prn.c \
	$(CRYPTO_PATH)/evp/bio_b64.c \
	$(CRYPTO_PATH)/evp/bio_enc.c \
	$(CRYPTO_PATH)/evp/bio_md.c \
	$(CRYPTO_PATH)/evp/bio_ok.c \
	$(CRYPTO_PATH)/evp/c_all.c \
	$(CRYPTO_PATH)/evp/c_allc.c \
	$(CRYPTO_PATH)/evp/c_alld.c \
	$(CRYPTO_PATH)/evp/digest.c \
	$(CRYPTO_PATH)/evp/e_aes.c \
	$(CRYPTO_PATH)/evp/e_bf.c \
	$(CRYPTO_PATH)/evp/e_des.c \
	$(CRYPTO_PATH)/evp/e_des3.c \
	$(CRYPTO_PATH)/evp/e_null.c \
	$(CRYPTO_PATH)/evp/e_old.c \
	$(CRYPTO_PATH)/evp/e_rc2.c \
	$(CRYPTO_PATH)/evp/e_rc4.c \
	$(CRYPTO_PATH)/evp/e_rc5.c \
	$(CRYPTO_PATH)/evp/e_xcbc_d.c \
	$(CRYPTO_PATH)/evp/encode.c \
	$(CRYPTO_PATH)/evp/evp_acnf.c \
	$(CRYPTO_PATH)/evp/evp_enc.c \
	$(CRYPTO_PATH)/evp/evp_err.c \
	$(CRYPTO_PATH)/evp/evp_key.c \
	$(CRYPTO_PATH)/evp/evp_lib.c \
	$(CRYPTO_PATH)/evp/evp_pbe.c \
	$(CRYPTO_PATH)/evp/evp_pkey.c \
	$(CRYPTO_PATH)/evp/m_dss.c \
	$(CRYPTO_PATH)/evp/m_dss1.c \
	$(CRYPTO_PATH)/evp/m_ecdsa.c \
	$(CRYPTO_PATH)/evp/m_md4.c \
	$(CRYPTO_PATH)/evp/m_md5.c \
	$(CRYPTO_PATH)/evp/m_mdc2.c \
	$(CRYPTO_PATH)/evp/m_null.c \
	$(CRYPTO_PATH)/evp/m_ripemd.c \
	$(CRYPTO_PATH)/evp/m_sha1.c \
	$(CRYPTO_PATH)/evp/m_sigver.c \
	$(CRYPTO_PATH)/evp/m_wp.c \
	$(CRYPTO_PATH)/evp/names.c \
	$(CRYPTO_PATH)/evp/p5_crpt.c \
	$(CRYPTO_PATH)/evp/p5_crpt2.c \
	$(CRYPTO_PATH)/evp/p_dec.c \
	$(CRYPTO_PATH)/evp/p_enc.c \
	$(CRYPTO_PATH)/evp/p_lib.c \
	$(CRYPTO_PATH)/evp/p_open.c \
	$(CRYPTO_PATH)/evp/p_seal.c \
	$(CRYPTO_PATH)/evp/p_sign.c \
	$(CRYPTO_PATH)/evp/p_verify.c \
	$(CRYPTO_PATH)/evp/pmeth_fn.c \
	$(CRYPTO_PATH)/evp/pmeth_gn.c \
	$(CRYPTO_PATH)/evp/pmeth_lib.c \
	$(CRYPTO_PATH)/hmac/hm_ameth.c \
	$(CRYPTO_PATH)/hmac/hm_pmeth.c \
	$(CRYPTO_PATH)/hmac/hmac.c \
	$(CRYPTO_PATH)/krb5/krb5_asn.c \
	$(CRYPTO_PATH)/lhash/lh_stats.c \
	$(CRYPTO_PATH)/lhash/lhash.c \
	$(CRYPTO_PATH)/md4/md4_dgst.c \
	$(CRYPTO_PATH)/md4/md4_one.c \
	$(CRYPTO_PATH)/md5/md5_dgst.c \
	$(CRYPTO_PATH)/md5/md5_one.c \
	$(CRYPTO_PATH)/modes/cbc128.c \
	$(CRYPTO_PATH)/modes/ccm128.c \
	$(CRYPTO_PATH)/modes/cfb128.c \
	$(CRYPTO_PATH)/modes/ctr128.c \
	$(CRYPTO_PATH)/modes/gcm128.c \
	$(CRYPTO_PATH)/modes/ofb128.c \
	$(CRYPTO_PATH)/modes/wrap128.c \
	$(CRYPTO_PATH)/modes/xts128.c \
	$(CRYPTO_PATH)/objects/o_names.c \
	$(CRYPTO_PATH)/objects/obj_dat.c \
	$(CRYPTO_PATH)/objects/obj_err.c \
	$(CRYPTO_PATH)/objects/obj_lib.c \
	$(CRYPTO_PATH)/objects/obj_xref.c \
	$(CRYPTO_PATH)/ocsp/ocsp_asn.c \
	$(CRYPTO_PATH)/ocsp/ocsp_cl.c \
	$(CRYPTO_PATH)/ocsp/ocsp_err.c \
	$(CRYPTO_PATH)/ocsp/ocsp_ext.c \
	$(CRYPTO_PATH)/ocsp/ocsp_ht.c \
	$(CRYPTO_PATH)/ocsp/ocsp_lib.c \
	$(CRYPTO_PATH)/ocsp/ocsp_prn.c \
	$(CRYPTO_PATH)/ocsp/ocsp_srv.c \
	$(CRYPTO_PATH)/ocsp/ocsp_vfy.c \
	$(CRYPTO_PATH)/pem/pem_all.c \
	$(CRYPTO_PATH)/pem/pem_err.c \
	$(CRYPTO_PATH)/pem/pem_info.c \
	$(CRYPTO_PATH)/pem/pem_lib.c \
	$(CRYPTO_PATH)/pem/pem_oth.c \
	$(CRYPTO_PATH)/pem/pem_pk8.c \
	$(CRYPTO_PATH)/pem/pem_pkey.c \
	$(CRYPTO_PATH)/pem/pem_seal.c \
	$(CRYPTO_PATH)/pem/pem_sign.c \
	$(CRYPTO_PATH)/pem/pem_x509.c \
	$(CRYPTO_PATH)/pem/pem_xaux.c \
	$(CRYPTO_PATH)/pem/pvkfmt.c \
	$(CRYPTO_PATH)/pkcs12/p12_add.c \
	$(CRYPTO_PATH)/pkcs12/p12_asn.c \
	$(CRYPTO_PATH)/pkcs12/p12_attr.c \
	$(CRYPTO_PATH)/pkcs12/p12_crpt.c \
	$(CRYPTO_PATH)/pkcs12/p12_crt.c \
	$(CRYPTO_PATH)/pkcs12/p12_decr.c \
	$(CRYPTO_PATH)/pkcs12/p12_init.c \
	$(CRYPTO_PATH)/pkcs12/p12_key.c \
	$(CRYPTO_PATH)/pkcs12/p12_kiss.c \
	$(CRYPTO_PATH)/pkcs12/p12_mutl.c \
	$(CRYPTO_PATH)/pkcs12/p12_npas.c \
	$(CRYPTO_PATH)/pkcs12/p12_p8d.c \
	$(CRYPTO_PATH)/pkcs12/p12_p8e.c \
	$(CRYPTO_PATH)/pkcs12/p12_utl.c \
	$(CRYPTO_PATH)/pkcs12/pk12err.c \
	$(CRYPTO_PATH)/pkcs7/pk7_asn1.c \
	$(CRYPTO_PATH)/pkcs7/pk7_attr.c \
	$(CRYPTO_PATH)/pkcs7/pk7_doit.c \
	$(CRYPTO_PATH)/pkcs7/pk7_lib.c \
	$(CRYPTO_PATH)/pkcs7/pk7_mime.c \
	$(CRYPTO_PATH)/pkcs7/pk7_smime.c \
	$(CRYPTO_PATH)/pkcs7/pkcs7err.c \
	$(CRYPTO_PATH)/rand/md_rand.c \
	$(CRYPTO_PATH)/rand/rand_egd.c \
	$(CRYPTO_PATH)/rand/rand_err.c \
	$(CRYPTO_PATH)/rand/rand_lib.c \
	$(CRYPTO_PATH)/rand/rand_unix.c \
	$(CRYPTO_PATH)/rand/randfile.c \
	$(CRYPTO_PATH)/rc2/rc2_cbc.c \
	$(CRYPTO_PATH)/rc2/rc2_ecb.c \
	$(CRYPTO_PATH)/rc2/rc2_skey.c \
	$(CRYPTO_PATH)/rc2/rc2cfb64.c \
	$(CRYPTO_PATH)/rc2/rc2ofb64.c \
	$(CRYPTO_PATH)/rc4/rc4_enc.c \
	$(CRYPTO_PATH)/rc4/rc4_skey.c \
	$(CRYPTO_PATH)/ripemd/rmd_dgst.c \
	$(CRYPTO_PATH)/ripemd/rmd_one.c \
	$(CRYPTO_PATH)/rsa/rsa_ameth.c \
	$(CRYPTO_PATH)/rsa/rsa_asn1.c \
	$(CRYPTO_PATH)/rsa/rsa_chk.c \
	$(CRYPTO_PATH)/rsa/rsa_crpt.c \
	$(CRYPTO_PATH)/rsa/rsa_depr.c \
	$(CRYPTO_PATH)/rsa/rsa_eay.c \
	$(CRYPTO_PATH)/rsa/rsa_err.c \
	$(CRYPTO_PATH)/rsa/rsa_gen.c \
	$(CRYPTO_PATH)/rsa/rsa_lib.c \
	$(CRYPTO_PATH)/rsa/rsa_none.c \
	$(CRYPTO_PATH)/rsa/rsa_null.c \
	$(CRYPTO_PATH)/rsa/rsa_oaep.c \
	$(CRYPTO_PATH)/rsa/rsa_pk1.c \
	$(CRYPTO_PATH)/rsa/rsa_pmeth.c \
	$(CRYPTO_PATH)/rsa/rsa_prn.c \
	$(CRYPTO_PATH)/rsa/rsa_pss.c \
	$(CRYPTO_PATH)/rsa/rsa_saos.c \
	$(CRYPTO_PATH)/rsa/rsa_sign.c \
	$(CRYPTO_PATH)/rsa/rsa_ssl.c \
	$(CRYPTO_PATH)/rsa/rsa_x931.c \
	$(CRYPTO_PATH)/sha/sha1_one.c \
	$(CRYPTO_PATH)/sha/sha1dgst.c \
	$(CRYPTO_PATH)/sha/sha256.c \
	$(CRYPTO_PATH)/sha/sha512.c \
	$(CRYPTO_PATH)/sha/sha_dgst.c \
	$(CRYPTO_PATH)/stack/stack.c \
	$(CRYPTO_PATH)/ts/ts_err.c \
	$(CRYPTO_PATH)/txt_db/txt_db.c \
	$(CRYPTO_PATH)/ui/ui_compat.c \
	$(CRYPTO_PATH)/ui/ui_err.c \
	$(CRYPTO_PATH)/ui/ui_lib.c \
	$(CRYPTO_PATH)/ui/ui_openssl.c \
	$(CRYPTO_PATH)/ui/ui_util.c \
	$(CRYPTO_PATH)/x509/by_dir.c \
	$(CRYPTO_PATH)/x509/by_file.c \
	$(CRYPTO_PATH)/x509/x509_att.c \
	$(CRYPTO_PATH)/x509/x509_cmp.c \
	$(CRYPTO_PATH)/x509/x509_d2.c \
	$(CRYPTO_PATH)/x509/x509_def.c \
	$(CRYPTO_PATH)/x509/x509_err.c \
	$(CRYPTO_PATH)/x509/x509_ext.c \
	$(CRYPTO_PATH)/x509/x509_lu.c \
	$(CRYPTO_PATH)/x509/x509_obj.c \
	$(CRYPTO_PATH)/x509/x509_r2x.c \
	$(CRYPTO_PATH)/x509/x509_req.c \
	$(CRYPTO_PATH)/x509/x509_set.c \
	$(CRYPTO_PATH)/x509/x509_trs.c \
	$(CRYPTO_PATH)/x509/x509_txt.c \
	$(CRYPTO_PATH)/x509/x509_v3.c \
	$(CRYPTO_PATH)/x509/x509_vfy.c \
	$(CRYPTO_PATH)/x509/x509_vpm.c \
	$(CRYPTO_PATH)/x509/x509cset.c \
	$(CRYPTO_PATH)/x509/x509name.c \
	$(CRYPTO_PATH)/x509/x509rset.c \
	$(CRYPTO_PATH)/x509/x509spki.c \
	$(CRYPTO_PATH)/x509/x509type.c \
	$(CRYPTO_PATH)/x509/x_all.c \
	$(CRYPTO_PATH)/x509v3/pcy_cache.c \
	$(CRYPTO_PATH)/x509v3/pcy_data.c \
	$(CRYPTO_PATH)/x509v3/pcy_lib.c \
	$(CRYPTO_PATH)/x509v3/pcy_map.c \
	$(CRYPTO_PATH)/x509v3/pcy_node.c \
	$(CRYPTO_PATH)/x509v3/pcy_tree.c \
	$(CRYPTO_PATH)/x509v3/v3_akey.c \
	$(CRYPTO_PATH)/x509v3/v3_akeya.c \
	$(CRYPTO_PATH)/x509v3/v3_alt.c \
	$(CRYPTO_PATH)/x509v3/v3_bcons.c \
	$(CRYPTO_PATH)/x509v3/v3_bitst.c \
	$(CRYPTO_PATH)/x509v3/v3_conf.c \
	$(CRYPTO_PATH)/x509v3/v3_cpols.c \
	$(CRYPTO_PATH)/x509v3/v3_crld.c \
	$(CRYPTO_PATH)/x509v3/v3_enum.c \
	$(CRYPTO_PATH)/x509v3/v3_extku.c \
	$(CRYPTO_PATH)/x509v3/v3_genn.c \
	$(CRYPTO_PATH)/x509v3/v3_ia5.c \
	$(CRYPTO_PATH)/x509v3/v3_info.c \
	$(CRYPTO_PATH)/x509v3/v3_int.c \
	$(CRYPTO_PATH)/x509v3/v3_lib.c \
	$(CRYPTO_PATH)/x509v3/v3_ncons.c \
	$(CRYPTO_PATH)/x509v3/v3_ocsp.c \
	$(CRYPTO_PATH)/x509v3/v3_pci.c \
	$(CRYPTO_PATH)/x509v3/v3_pcia.c \
	$(CRYPTO_PATH)/x509v3/v3_pcons.c \
	$(CRYPTO_PATH)/x509v3/v3_pku.c \
	$(CRYPTO_PATH)/x509v3/v3_pmaps.c \
	$(CRYPTO_PATH)/x509v3/v3_prn.c \
	$(CRYPTO_PATH)/x509v3/v3_purp.c \
	$(CRYPTO_PATH)/x509v3/v3_skey.c \
	$(CRYPTO_PATH)/x509v3/v3_sxnet.c \
	$(CRYPTO_PATH)/x509v3/v3_utl.c \
	$(CRYPTO_PATH)/x509v3/v3err.c \
	$(CRYPTO_PATH)/x509v3/v3_scts.c

local_c_includes := \
	$(LOCAL_PATH)/openssl \
	$(LOCAL_PATH)/openssl/crypto \
	$(LOCAL_PATH)/openssl/crypto/asn1 \
	$(LOCAL_PATH)/openssl/crypto/evp \
	$(LOCAL_PATH)/openssl/crypto/modes \
	$(LOCAL_PATH)/openssl/include \
	$(LOCAL_PATH)/openssl/include/openssl

local_c_flags := -DNO_WINDOWS_BRAINDEATH


include $(LOCAL_PATH)/openssl/android-config.mk
LOCAL_SRC_FILES += $(local_src_files)
LOCAL_CFLAGS += $(local_c_flags) -DPURIFY
LOCAL_C_INCLUDES += $(local_c_includes)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= libcrypto
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
#LOCAL_MODULE    := crypto

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_SRC_FILES := ./openssl/obj/local/armeabi-v7a/libcrypto.a
else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_SRC_FILES := ./openssl/obj/local/armeabi/libcrypto.a
    else
        ifeq ($(TARGET_ARCH_ABI),x86)
	    LOCAL_SRC_FILES := ./openssl/obj/local/x86/libcrypto.a
        endif
    endif
endif

#include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := voip
LOCAL_CPPFLAGS := -Wall -std=c++11 -DANDROID -finline-functions -ffast-math -Os -fno-strict-aliasing -O3 -frtti -D__STDC_LIMIT_MACROS
LOCAL_CFLAGS := -O3 -DUSE_KISS_FFT -fexceptions -DWEBRTC_APM_DEBUG_DUMP=0 -DWEBRTC_POSIX -D__STDC_LIMIT_MACROS

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
#    LOCAL_CPPFLAGS += -mfloat-abi=softfp -mfpu=neon
#    LOCAL_CFLAGS += -mfloat-abi=softfp -mfpu=neon -DFLOATING_POINT
#	LOCAL_ARM_NEON := true
else
	LOCAL_CFLAGS += -DFIXED_POINT
    ifeq ($(TARGET_ARCH_ABI),armeabi)
#		LOCAL_CPPFLAGS += -mfloat-abi=softfp -mfpu=neon
#        LOCAL_CFLAGS += -mfloat-abi=softfp -mfpu=neon
    else
        ifeq ($(TARGET_ARCH_ABI),x86)

        endif
    endif
endif

MY_DIR := libtgvoip

LOCAL_C_INCLUDES := jni/opus/include jni/openssl/include/ jni/libtgvoip/webrtc_dsp/

LOCAL_SRC_FILES := \
./libtgvoip/logging.cpp \
./libtgvoip/VoIPController.cpp \
./libtgvoip/BufferInputStream.cpp \
./libtgvoip/BufferOutputStream.cpp \
./libtgvoip/BlockingQueue.cpp \
./libtgvoip/audio/AudioInput.cpp \
./libtgvoip/os/android/AudioInputOpenSLES.cpp \
./libtgvoip/MediaStreamItf.cpp \
./libtgvoip/audio/AudioOutput.cpp \
./libtgvoip/OpusEncoder.cpp \
./libtgvoip/os/android/AudioOutputOpenSLES.cpp \
./libtgvoip/JitterBuffer.cpp \
./libtgvoip/OpusDecoder.cpp \
./libtgvoip/BufferPool.cpp \
./libtgvoip/os/android/OpenSLEngineWrapper.cpp \
./libtgvoip/os/android/AudioInputAndroid.cpp \
./libtgvoip/os/android/AudioOutputAndroid.cpp \
./libtgvoip/EchoCanceller.cpp \
./libtgvoip/CongestionControl.cpp \
./libtgvoip/VoIPServerConfig.cpp \
./libtgvoip/audio/Resampler.cpp \
./libtgvoip/NetworkSocket.cpp \
./libtgvoip/os/posix/NetworkSocketPosix.cpp

# WebRTC signal processing

LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/common_audio/ring_buffer.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/auto_corr_to_refl_coef.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/auto_correlation.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/complex_bit_reverse.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/complex_fft.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/copy_set_operations.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/cross_correlation.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/division_operations.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/dot_product_with_scale.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/downsample_fast.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/energy.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/filter_ar.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/filter_ar_fast_q12.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/filter_ma_fast_q12.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/get_hanning_window.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/get_scaling_square.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/ilbc_specific_functions.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/levinson_durbin.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/lpc_to_refl_coef.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/min_max_operations.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/randomization_functions.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/real_fft.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/refl_coef_to_lpc.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/resample.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/resample_48khz.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/resample_by_2.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/resample_by_2_internal.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/resample_fractional.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/spl_init.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/spl_inl.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/spl_sqrt.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/spl_sqrt_floor.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/splitting_filter_impl.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/sqrt_of_one_minus_x_squared.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/vector_scaling_operations.c

LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/base/checks.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aecm/aecm_core.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aecm/aecm_core_c.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aecm/echo_control_mobile.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/delay_estimator.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/delay_estimator_wrapper.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/three_band_filter_bank.cc \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/splitting_filter.cc \
./libtgvoip/webrtc_dsp/webrtc/system_wrappers/source/cpu_features.cc \
./libtgvoip/webrtc_dsp/webrtc/common_audio/sparse_fir_filter.cc \
./libtgvoip/webrtc_dsp/webrtc/common_audio/channel_buffer.cc \
./libtgvoip/webrtc_dsp/webrtc/common_audio/audio_util.cc

#LOCAL_SRC_FILES += \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/block_mean_calculator.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/ooura_fft.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/logging/apm_data_dumper.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aec/aec_core.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aec/aec_resampler.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aec/echo_cancellation.cc \
#./libtgvoip/webrtc_dsp/webrtc/common_audio/wav_header.cc \
#./libtgvoip/webrtc_dsp/webrtc/common_audio/wav_file.cc \
#./libtgvoip/webrtc_dsp/webrtc/base/stringutils.cc

LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/noise_suppression_x.c \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/noise_suppression.c \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/ns_core.c \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/nsx_core_c.c \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/nsx_core.c \
./libtgvoip/webrtc_dsp/webrtc/common_audio/fft4g.c

LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/agc/legacy/analog_agc.c \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/agc/legacy/digital_agc.c

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aecm/aecm_core_neon.cc.neon \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/min_max_operations_neon.c.neon \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/downsample_fast_neon.c.neon \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/cross_correlation_neon.c.neon \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/filter_ar_fast_q12_armv7.S.neon
#LOCAL_SRC_FILES += \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aec/aec_core_neon.cc.neon
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/ooura_fft_neon.cc.neon
LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/ns/nsx_core_neon.c.neon
#LOCAL_ARM_NEON := true
endif

ifeq ($(TARGET_ARCH_ABI),armeabi)
LOCAL_SRC_FILES += \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/complex_bit_reverse_arm.S \
./libtgvoip/webrtc_dsp/webrtc/common_audio/signal_processing/spl_sqrt_floor_arm.S
endif

#ifeq ($(TARGET_ARCH_ABI),x86)
#LOCAL_SRC_FILES += \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/aec/aec_core_sse2.cc \
#./libtgvoip/webrtc_dsp/webrtc/modules/audio_processing/utility/ooura_fft_sse2.cc
#endif

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_CPPFLAGS := -Wall -std=c++11 -DANDROID -frtti -DHAVE_PTHREAD -finline-functions -ffast-math -O0
LOCAL_C_INCLUDES += $(LOCAL_PATH)/openssl/include/
LOCAL_ARM_MODE := arm
LOCAL_MODULE := tgnet
LOCAL_STATIC_LIBRARIES := crypto

LOCAL_SRC_FILES := \
./tgnet/ApiScheme.cpp \
./tgnet/BuffersStorage.cpp \
./tgnet/ByteArray.cpp \
./tgnet/ByteStream.cpp \
./tgnet/Connection.cpp \
./tgnet/ConnectionSession.cpp \
./tgnet/ConnectionsManager.cpp \
./tgnet/ConnectionSocket.cpp \
./tgnet/Datacenter.cpp \
./tgnet/EventObject.cpp \
./tgnet/FileLog.cpp \
./tgnet/MTProtoScheme.cpp \
./tgnet/NativeByteBuffer.cpp \
./tgnet/Request.cpp \
./tgnet/Timer.cpp \
./tgnet/TLObject.cpp \
./tgnet/FileLoadOperation.cpp \
./tgnet/Config.cpp

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

include $(LOCAL_PATH)/libwebp/Android.mk

LOCAL_PATH := $(MY_LOCAL_PATH)

include $(CLEAR_VARS)
ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_ARM_MODE  := thumb
else
	LOCAL_ARM_MODE  := arm
endif
LOCAL_MODULE := sqlite
LOCAL_CFLAGS 	:= -w -std=c11 -Os -DNULL=0 -DSOCKLEN_T=socklen_t -DLOCALE_NOT_USED -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=32
LOCAL_CFLAGS 	+= -DANDROID_NDK -DDISABLE_IMPORTGL -fno-strict-aliasing -fprefetch-loop-arrays -DAVOID_TABLES -DANDROID_TILE_BASED_DECODE -DANDROID_ARMV6_IDCT -DHAVE_STRCHRNUL=0

LOCAL_SRC_FILES     := \
./sqlite/sqlite3.c

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE := false

LOCAL_MODULE 	:= tmessages.27
LOCAL_CFLAGS 	:= -w -std=c11 -Os -DNULL=0 -DSOCKLEN_T=socklen_t -DLOCALE_NOT_USED -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64
LOCAL_CFLAGS 	+= -Drestrict='' -D__EMX__ -DOPUS_BUILD -DFIXED_POINT -DUSE_ALLOCA -DHAVE_LRINT -DHAVE_LRINTF -fno-math-errno
LOCAL_CFLAGS 	+= -DANDROID_NDK -DDISABLE_IMPORTGL -fno-strict-aliasing -fprefetch-loop-arrays -DAVOID_TABLES -DANDROID_TILE_BASED_DECODE -DANDROID_ARMV6_IDCT -ffast-math -D__STDC_CONSTANT_MACROS
LOCAL_CPPFLAGS 	:= -DBSD=1 -ffast-math -Os -funroll-loops -std=c++11
LOCAL_LDLIBS 	:= -ljnigraphics -llog -lz -latomic -lOpenSLES -lEGL -lGLESv2
# https://stackoverflow.com/a/37235059
LOCAL_LDLIBS += -Wl,--no-warn-shared-textrel
LOCAL_STATIC_LIBRARIES := webp sqlite tgnet avformat avcodec avutil swresample voip

LOCAL_SRC_FILES     := \
./opus/src/opus.c \
./opus/src/opus_decoder.c \
./opus/src/opus_encoder.c \
./opus/src/opus_multistream.c \
./opus/src/opus_multistream_encoder.c \
./opus/src/opus_multistream_decoder.c \
./opus/src/repacketizer.c \
./opus/src/analysis.c \
./opus/src/mlp.c \
./opus/src/mlp_data.c

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_ARM_MODE := arm
    LOCAL_CPPFLAGS += -DLIBYUV_NEON
    LOCAL_CFLAGS += -DLIBYUV_NEON
    LOCAL_CFLAGS += -DOPUS_HAVE_RTCD -DOPUS_ARM_ASM
    LOCAL_SRC_FILES += \
#    ./opus/celt/arm/celt_neon_intr.c \
#    ./opus/silk/arm/NSQ_neon.c \
    ./opus/silk/arm/arm_silk_map.c

#    LOCAL_SRC_FILES += ./opus/celt/arm/celt_pitch_xcorr_arm-gnu.S

else
    ifeq ($(TARGET_ARCH_ABI),armeabi)
	LOCAL_ARM_MODE  := arm

    else
        ifeq ($(TARGET_ARCH_ABI),x86)
	    LOCAL_CFLAGS += -Dx86fix
 	    LOCAL_CPPFLAGS += -Dx86fix
	    LOCAL_ARM_MODE  := arm
#	    LOCAL_SRC_FILES += \
#	    ./libyuv/source/row_x86.asm

#	    LOCAL_SRC_FILES += \
#	    ./opus/celt/x86/celt_lpc_sse.c \
#		./opus/celt/x86/pitch_sse.c \
#		./opus/celt/x86/pitch_sse2.c \
#		./opus/celt/x86/pitch_sse4_1.c \
#		./opus/celt/x86/vq_sse2.c \
#		./opus/celt/x86/x86_celt_map.c \
#		./opus/celt/x86/x86cpu.c \
#		./opus/silk/fixed/x86/burg_modified_FIX_sse.c \
#		./opus/silk/fixed/x86/vector_ops_FIX_sse.c \
#		./opus/silk/x86/NSQ_del_dec_sse.c \
#		./opus/silk/x86/NSQ_sse.c \
#		./opus/silk/x86/VAD_sse.c \
#		./opus/silk/x86/VQ_WMat_sse.c \
#		./opus/silk/x86/x86_silk_map.c

        endif
    endif
endif

LOCAL_SRC_FILES     += \
./opus/silk/CNG.c \
./opus/silk/code_signs.c \
./opus/silk/init_decoder.c \
./opus/silk/decode_core.c \
./opus/silk/decode_frame.c \
./opus/silk/decode_parameters.c \
./opus/silk/decode_indices.c \
./opus/silk/decode_pulses.c \
./opus/silk/decoder_set_fs.c \
./opus/silk/dec_API.c \
./opus/silk/enc_API.c \
./opus/silk/encode_indices.c \
./opus/silk/encode_pulses.c \
./opus/silk/gain_quant.c \
./opus/silk/interpolate.c \
./opus/silk/LP_variable_cutoff.c \
./opus/silk/NLSF_decode.c \
./opus/silk/NSQ.c \
./opus/silk/NSQ_del_dec.c \
./opus/silk/PLC.c \
./opus/silk/shell_coder.c \
./opus/silk/tables_gain.c \
./opus/silk/tables_LTP.c \
./opus/silk/tables_NLSF_CB_NB_MB.c \
./opus/silk/tables_NLSF_CB_WB.c \
./opus/silk/tables_other.c \
./opus/silk/tables_pitch_lag.c \
./opus/silk/tables_pulses_per_block.c \
./opus/silk/VAD.c \
./opus/silk/control_audio_bandwidth.c \
./opus/silk/quant_LTP_gains.c \
./opus/silk/VQ_WMat_EC.c \
./opus/silk/HP_variable_cutoff.c \
./opus/silk/NLSF_encode.c \
./opus/silk/NLSF_VQ.c \
./opus/silk/NLSF_unpack.c \
./opus/silk/NLSF_del_dec_quant.c \
./opus/silk/process_NLSFs.c \
./opus/silk/stereo_LR_to_MS.c \
./opus/silk/stereo_MS_to_LR.c \
./opus/silk/check_control_input.c \
./opus/silk/control_SNR.c \
./opus/silk/init_encoder.c \
./opus/silk/control_codec.c \
./opus/silk/A2NLSF.c \
./opus/silk/ana_filt_bank_1.c \
./opus/silk/biquad_alt.c \
./opus/silk/bwexpander_32.c \
./opus/silk/bwexpander.c \
./opus/silk/debug.c \
./opus/silk/decode_pitch.c \
./opus/silk/inner_prod_aligned.c \
./opus/silk/lin2log.c \
./opus/silk/log2lin.c \
./opus/silk/LPC_analysis_filter.c \
./opus/silk/LPC_inv_pred_gain.c \
./opus/silk/table_LSF_cos.c \
./opus/silk/NLSF2A.c \
./opus/silk/NLSF_stabilize.c \
./opus/silk/NLSF_VQ_weights_laroia.c \
./opus/silk/pitch_est_tables.c \
./opus/silk/resampler.c \
./opus/silk/resampler_down2_3.c \
./opus/silk/resampler_down2.c \
./opus/silk/resampler_private_AR2.c \
./opus/silk/resampler_private_down_FIR.c \
./opus/silk/resampler_private_IIR_FIR.c \
./opus/silk/resampler_private_up2_HQ.c \
./opus/silk/resampler_rom.c \
./opus/silk/sigm_Q15.c \
./opus/silk/sort.c \
./opus/silk/sum_sqr_shift.c \
./opus/silk/stereo_decode_pred.c \
./opus/silk/stereo_encode_pred.c \
./opus/silk/stereo_find_predictor.c \
./opus/silk/stereo_quant_pred.c \
./opus/silk/LPC_fit.c

LOCAL_SRC_FILES     += \
./opus/silk/fixed/LTP_analysis_filter_FIX.c \
./opus/silk/fixed/LTP_scale_ctrl_FIX.c \
./opus/silk/fixed/corrMatrix_FIX.c \
./opus/silk/fixed/encode_frame_FIX.c \
./opus/silk/fixed/find_LPC_FIX.c \
./opus/silk/fixed/find_LTP_FIX.c \
./opus/silk/fixed/find_pitch_lags_FIX.c \
./opus/silk/fixed/find_pred_coefs_FIX.c \
./opus/silk/fixed/noise_shape_analysis_FIX.c \
./opus/silk/fixed/process_gains_FIX.c \
./opus/silk/fixed/regularize_correlations_FIX.c \
./opus/silk/fixed/residual_energy16_FIX.c \
./opus/silk/fixed/residual_energy_FIX.c \
./opus/silk/fixed/warped_autocorrelation_FIX.c \
./opus/silk/fixed/apply_sine_window_FIX.c \
./opus/silk/fixed/autocorr_FIX.c \
./opus/silk/fixed/burg_modified_FIX.c \
./opus/silk/fixed/k2a_FIX.c \
./opus/silk/fixed/k2a_Q16_FIX.c \
./opus/silk/fixed/pitch_analysis_core_FIX.c \
./opus/silk/fixed/vector_ops_FIX.c \
./opus/silk/fixed/schur64_FIX.c \
./opus/silk/fixed/schur_FIX.c

LOCAL_SRC_FILES     += \
./opus/celt/bands.c \
./opus/celt/celt.c \
./opus/celt/celt_encoder.c \
./opus/celt/celt_decoder.c \
./opus/celt/cwrs.c \
./opus/celt/entcode.c \
./opus/celt/entdec.c \
./opus/celt/entenc.c \
./opus/celt/kiss_fft.c \
./opus/celt/laplace.c \
./opus/celt/mathops.c \
./opus/celt/mdct.c \
./opus/celt/modes.c \
./opus/celt/pitch.c \
./opus/celt/celt_lpc.c \
./opus/celt/quant_bands.c \
./opus/celt/rate.c \
./opus/celt/vq.c \
./opus/celt/arm/armcpu.c \
./opus/celt/arm/arm_celt_map.c

LOCAL_SRC_FILES     += \
./opus/ogg/bitwise.c \
./opus/ogg/framing.c \
./opus/opusfile/info.c \
./opus/opusfile/internal.c \
./opus/opusfile/opusfile.c \
./opus/opusfile/stream.c

LOCAL_C_INCLUDES    := \
$(LOCAL_PATH)/opus/include \
$(LOCAL_PATH)/opus/silk \
$(LOCAL_PATH)/opus/silk/fixed \
$(LOCAL_PATH)/opus/celt \
$(LOCAL_PATH)/opus/ \
$(LOCAL_PATH)/opus/opusfile \
$(LOCAL_PATH)/libyuv/include \
$(LOCAL_PATH)/openssl/include \
$(FFMPEG_INCLUDE_PATH) \
$(LOCAL_PATH)/intro

LOCAL_SRC_FILES     += \
./libyuv/source/compare_common.cc \
./libyuv/source/compare_gcc.cc \
./libyuv/source/compare_neon64.cc \
./libyuv/source/compare_win.cc \
./libyuv/source/compare.cc \
./libyuv/source/convert_argb.cc \
./libyuv/source/convert_from_argb.cc \
./libyuv/source/convert_from.cc \
./libyuv/source/convert_jpeg.cc \
./libyuv/source/convert_to_argb.cc \
./libyuv/source/convert_to_i420.cc \
./libyuv/source/convert.cc \
./libyuv/source/cpu_id.cc \
./libyuv/source/mjpeg_decoder.cc \
./libyuv/source/mjpeg_validate.cc \
./libyuv/source/planar_functions.cc \
./libyuv/source/rotate_any.cc \
./libyuv/source/rotate_argb.cc \
./libyuv/source/rotate_common.cc \
./libyuv/source/rotate_gcc.cc \
./libyuv/source/rotate_mips.cc \
./libyuv/source/rotate_neon64.cc \
./libyuv/source/rotate_win.cc \
./libyuv/source/rotate.cc \
./libyuv/source/row_any.cc \
./libyuv/source/row_common.cc \
./libyuv/source/row_gcc.cc \
./libyuv/source/row_mips.cc \
./libyuv/source/row_neon64.cc \
./libyuv/source/row_win.cc \
./libyuv/source/scale_any.cc \
./libyuv/source/scale_argb.cc \
./libyuv/source/scale_common.cc \
./libyuv/source/scale_gcc.cc \
./libyuv/source/scale_mips.cc \
./libyuv/source/scale_neon64.cc \
./libyuv/source/scale_win.cc \
./libyuv/source/scale.cc \
./libyuv/source/video_common.cc

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
    LOCAL_CFLAGS += -DLIBYUV_NEON
    LOCAL_SRC_FILES += \
        ./libyuv/source/compare_neon.cc.neon    \
        ./libyuv/source/rotate_neon.cc.neon     \
        ./libyuv/source/row_neon.cc.neon        \
        ./libyuv/source/scale_neon.cc.neon
endif

LOCAL_SRC_FILES     += \
./jni.c \
./audio.c \
./utils.c \
./image.c \
./video.c \
./intro/IntroRenderer.c \
./gifvideo.cpp \
./SqliteWrapper.cpp \
./TgNetWrapper.cpp \
./NativeLoader.cpp \
./libtgvoip/client/android/tg_voip_jni.cpp

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/cpufeatures)