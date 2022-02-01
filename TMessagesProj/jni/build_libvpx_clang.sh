#!/bin/bash
set -e
function build_one {
	echo "Building ${ARCH}..."

	PREBUILT=${NDK}/toolchains/${PREBUILT_ARCH}-${VERSION}/prebuilt/${BUILD_PLATFORM}
	PLATFORM=${NDK}/platforms/android-${ANDROID_API}/arch-${ARCH}

	TOOLS_PREFIX="${LLVM_BIN}/${ARCH_NAME}-linux-${BIN_MIDDLE}-"

	export LD=${TOOLS_PREFIX}ld
	export AR=${TOOLS_PREFIX}ar
	export STRIP=${TOOLS_PREFIX}strip
	export RANLIB=${TOOLS_PREFIX}ranlib
	export NM=${TOOLS_PREFIX}nm

	export CC_PREFIX="${LLVM_BIN}/${CLANG_PREFIX}-linux-${BIN_MIDDLE}${ANDROID_API}-"

	export CC=${CC_PREFIX}clang
	export CXX=${CC_PREFIX}clang++
	export AS=${CC_PREFIX}clang++
	export CROSS_PREFIX=${PREBUILT}/bin/${ARCH_NAME}-linux-${BIN_MIDDLE}-
	
	
	export CFLAGS="-DANDROID -fpic -fpie ${OPTIMIZE_CFLAGS}"
	export CPPFLAGS="${CFLAGS}"
	export CXXFLAGS="${CFLAGS} -std=c++11"
	export ASFLAGS="-D__ANDROID__"
	export LDFLAGS="-L$${PLATFORM}/usr/lib"

	echo "Cleaning..."
	make clean || true

	echo "Configuring..."



	./configure \
	--extra-cflags="-isystem ${LLVM_PREFIX}/sysroot/usr/include/${ARCH_NAME}-linux-${BIN_MIDDLE} -isystem ${LLVM_PREFIX}/sysroot/usr/include" \
	--libc="${LLVM_PREFIX}/sysroot" \
	--prefix=${PREFIX} \
	--target=${TARGET} \
	--enable-runtime-cpu-detect \
	--as=yasm \
	--enable-static \
	--enable-pic \
	--disable-docs \
	--disable-libyuv \
	--disable-examples \
	--disable-tools \
	--disable-debug \
	--disable-unit-tests \
	--disable-install-docs \
	--enable-realtime-only \
	--enable-vp9-postproc \
	--enable-vp9-highbitdepth \
	--disable-webm-io \
	--enable-postproc \
	--enable-multi-res-encoding \
	--enable-temporal-denoising \
	--enable-vp9-temporal-denoising \
	--disable-avx512

	make -j$COMPILATION_PROC_COUNT install
}

function cutX86 {
	pushd $PREFIX/lib

	$AR dv libvpx.a vp9_job_queue.c.o
	$AR dv libvpx.a vp9_dsubexp.c.o
	$AR dv libvpx.a vp9_decoder.c.o
	$AR dv libvpx.a vp9_detokenize.c.o
	$AR dv libvpx.a vp9_decodeframe.c.o
	$AR dv libvpx.a vp9_decodemv.c.o
	$AR dv libvpx.a vp9_dx_iface.c.o
	$AR dv libvpx.a vp9_denoiser_sse2.c.o
	$AR dv libvpx.a vp9_dct_intrin_sse2.c.o
	$AR dv libvpx.a vp9_highbd_block_error_intrin_sse2.c.o
	$AR dv libvpx.a vp9_quantize_sse2.c.o
	$AR dv libvpx.a vp9_ext_ratectrl.c.o
	$AR dv libvpx.a vp9_noise_estimate.c.o
	$AR dv libvpx.a vp9_skin_detection.c.o
	$AR dv libvpx.a vp9_aq_cyclicrefresh.c.o
	$AR dv libvpx.a vp9_treewriter.c.o
	$AR dv libvpx.a vp9_tokenize.c.o
	$AR dv libvpx.a vp9_resize.c.o
	$AR dv libvpx.a vp9_svc_layercontext.c.o
	$AR dv libvpx.a vp9_subexp.c.o
	$AR dv libvpx.a vp9_speed_features.c.o
	$AR dv libvpx.a vp9_segmentation.c.o
	$AR dv libvpx.a vp9_pickmode.c.o
	$AR dv libvpx.a vp9_rdopt.c.o
	$AR dv libvpx.a vp9_rd.c.o
	$AR dv libvpx.a vp9_ratectrl.c.o
	$AR dv libvpx.a vp9_quantize.c.o
	$AR dv libvpx.a vp9_picklpf.c.o
	$AR dv libvpx.a vp9_encoder.c.o
	$AR dv libvpx.a vp9_mcomp.c.o
	$AR dv libvpx.a vp9_multi_thread.c.o
	$AR dv libvpx.a vp9_lookahead.c.o
	$AR dv libvpx.a vp9_frame_scale.c.o
	$AR dv libvpx.a vp9_extend.c.o
	$AR dv libvpx.a vp9_ethread.c.o
	$AR dv libvpx.a vp9_encodemv.c.o
	$AR dv libvpx.a vp9_encodemb.c.o
	$AR dv libvpx.a vp9_encodeframe.c.o
	$AR dv libvpx.a vp9_denoiser.c.o
	$AR dv libvpx.a vp9_dct.c.o
	$AR dv libvpx.a vp9_cost.c.o
	$AR dv libvpx.a vp9_context_tree.c.o
	$AR dv libvpx.a vp9_bitstream.c.o
	$AR dv libvpx.a vp9_cx_iface.c.o
	$AR dv libvpx.a vp9_idct_intrin_sse2.c.o
	$AR dv libvpx.a vp9_mfqe.c.o
	$AR dv libvpx.a vp9_postproc.c.o
	$AR dv libvpx.a vp9_scan.c.o
	$AR dv libvpx.a vp9_common_data.c.o
	$AR dv libvpx.a vp9_reconintra.c.o
	$AR dv libvpx.a vp9_reconinter.c.o
	$AR dv libvpx.a vp9_quant_common.c.o
	$AR dv libvpx.a vp9_mvref_common.c.o
	$AR dv libvpx.a vp9_thread_common.c.o
	$AR dv libvpx.a vp9_loopfilter.c.o
	$AR dv libvpx.a vp9_tile_common.c.o
	$AR dv libvpx.a vp9_seg_common.c.o
	$AR dv libvpx.a vp9_scale.c.o
	$AR dv libvpx.a vp9_rtcd.c.o
	$AR dv libvpx.a vp9_pred_common.c.o
	$AR dv libvpx.a vp9_filter.c.o
	$AR dv libvpx.a vp9_idct.c.o
	$AR dv libvpx.a vp9_frame_buffers.c.o
	$AR dv libvpx.a vp9_entropymv.c.o
	$AR dv libvpx.a vp9_entropymode.c.o
	$AR dv libvpx.a vp9_entropy.c.o
	$AR dv libvpx.a vp9_blockd.c.o
	$AR dv libvpx.a vp9_alloccommon.c.o
	$AR dv libvpx.a vp9_iface_common.c.o
	$AR dv libvpx.a threading.c.o
	$AR dv libvpx.a onyxd_if.c.o
	$AR dv libvpx.a detokenize.c.o
	$AR dv libvpx.a decodeframe.c.o
	$AR dv libvpx.a decodemv.c.o
	$AR dv libvpx.a dboolhuff.c.o
	$AR dv libvpx.a vp8_dx_iface.c.o
	$AR dv libvpx.a vp8_enc_stubs_sse2.c.o
	$AR dv libvpx.a denoising_sse2.c.o
	$AR dv libvpx.a vp8_quantize_sse2.c.o
	$AR dv libvpx.a mr_dissim.c.o
	$AR dv libvpx.a treewriter.c.o
	$AR dv libvpx.a tokenize.c.o
	$AR dv libvpx.a vp8_skin_detection.c.o
	$AR dv libvpx.a segmentation.c.o
	$AR dv libvpx.a rdopt.c.o
	$AR dv libvpx.a ratectrl.c.o
	$AR dv libvpx.a vp8_quantize.c.o
	$AR dv libvpx.a picklpf.c.o
	$AR dv libvpx.a pickinter.c.o
	$AR dv libvpx.a onyx_if.c.o
	$AR dv libvpx.a modecosts.c.o
	$AR dv libvpx.a mcomp.c.o
	$AR dv libvpx.a lookahead.c.o
	$AR dv libvpx.a denoising.c.o
	$AR dv libvpx.a ethreading.c.o
	$AR dv libvpx.a encodemv.c.o
	$AR dv libvpx.a encodemb.c.o
	$AR dv libvpx.a encodeintra.c.o
	$AR dv libvpx.a encodeframe.c.o
	$AR dv libvpx.a boolhuff.c.o
	$AR dv libvpx.a bitstream.c.o
	$AR dv libvpx.a vp8_cx_iface.c.o
	$AR dv libvpx.a bilinear_filter_sse2.c.o
	$AR dv libvpx.a idct_blk_sse2.c.o
	$AR dv libvpx.a idct_blk_mmx.c.o
	$AR dv libvpx.a postproc.c.o
	$AR dv libvpx.a mfqe.c.o
	$AR dv libvpx.a loopfilter_x86.c.o
	$AR dv libvpx.a vp8_asm_stubs.c.o
	$AR dv libvpx.a treecoder.c.o
	$AR dv libvpx.a setupintrarecon.c.o
	$AR dv libvpx.a reconintra4x4.c.o
	$AR dv libvpx.a reconintra.c.o
	$AR dv libvpx.a reconinter.c.o
	$AR dv libvpx.a quant_common.c.o
	$AR dv libvpx.a modecont.c.o
	$AR dv libvpx.a mbpitch.c.o
	$AR dv libvpx.a vp8_loopfilter.c.o
	$AR dv libvpx.a rtcd.c.o
	$AR dv libvpx.a idctllm.c.o
	$AR dv libvpx.a systemdependent.c.o
	$AR dv libvpx.a findnearmv.c.o
	$AR dv libvpx.a filter.c.o
	$AR dv libvpx.a extend.c.o
	$AR dv libvpx.a entropymv.c.o
	$AR dv libvpx.a entropymode.c.o
	$AR dv libvpx.a entropy.c.o
	$AR dv libvpx.a blockd.c.o
	$AR dv libvpx.a alloccommon.c.o
	$AR dv libvpx.a vpx_thread.c.o
	$AR dv libvpx.a vpx_dsp_rtcd.c.o
	$AR dv libvpx.a highbd_variance_sse2.c.o
	$AR dv libvpx.a variance_sse2.c.o
	$AR dv libvpx.a avg_pred_sse2.c.o
	$AR dv libvpx.a variance.c.o
	$AR dv libvpx.a sum_squares_sse2.c.o
	$AR dv libvpx.a subtract.c.o
	$AR dv libvpx.a sad.c.o
	$AR dv libvpx.a skin_detection.c.o
	$AR dv libvpx.a avg_intrin_sse2.c.o
	$AR dv libvpx.a avg.c.o
	$AR dv libvpx.a highbd_quantize_intrin_sse2.c.o
	$AR dv libvpx.a quantize_sse2.c.o
	$AR dv libvpx.a quantize.c.o
	$AR dv libvpx.a highbd_idct32x32_add_sse2.c.o
	$AR dv libvpx.a highbd_idct16x16_add_sse2.c.o
	$AR dv libvpx.a highbd_idct8x8_add_sse2.c.o
	$AR dv libvpx.a highbd_idct4x4_add_sse2.c.o
	$AR dv libvpx.a inv_txfm_sse2.c.o
	$AR dv libvpx.a inv_txfm.c.o
	$AR dv libvpx.a fwd_txfm_sse2.c.o
	$AR dv libvpx.a fwd_txfm.c.o
	$AR dv libvpx.a highbd_loopfilter_sse2.c.o
	$AR dv libvpx.a loopfilter_sse2.c.o
	$AR dv libvpx.a vpx_subpixel_4t_intrin_sse2.c.o
	$AR dv libvpx.a vpx_convolve.c.o
	$AR dv libvpx.a post_proc_sse2.c.o
	$AR dv libvpx.a deblock.c.o
	$AR dv libvpx.a add_noise.c.o
	$AR dv libvpx.a highbd_intrapred_intrin_sse2.c.o
	$AR dv libvpx.a intrapred.c.o
	$AR dv libvpx.a bitreader_buffer.c.o
	$AR dv libvpx.a bitreader.c.o
	$AR dv libvpx.a psnr.c.o
	$AR dv libvpx.a bitwriter_buffer.c.o
	$AR dv libvpx.a bitwriter.c.o
	$AR dv libvpx.a prob.c.o
	$AR dv libvpx.a emms_mmx.c.o
	$AR dv libvpx.a vpx_scale_rtcd.c.o
	$AR dv libvpx.a gen_scalers.c.o
	$AR dv libvpx.a yv12extend.c.o
	$AR dv libvpx.a yv12config.c.o
	$AR dv libvpx.a vpx_scale.c.o
	$AR dv libvpx.a vpx_mem.c.o
	$AR dv libvpx.a vpx_image.c.o
	$AR dv libvpx.a vpx_codec.c.o
	$AR dv libvpx.a vpx_encoder.c.o
	$AR dv libvpx.a vpx_decoder.c.o

	popd
}

function cutX8664 {
	pushd $PREFIX/lib
	$AR dv libvpx.a vp9_job_queue.c.o
	$AR dv libvpx.a vp9_dsubexp.c.o
	$AR dv libvpx.a vp9_decoder.c.o
	$AR dv libvpx.a vp9_detokenize.c.o
	$AR dv libvpx.a vp9_decodeframe.c.o
	$AR dv libvpx.a vp9_decodemv.c.o
	$AR dv libvpx.a vp9_dx_iface.c.o
	$AR dv libvpx.a vp9_denoiser_sse2.c.o
	$AR dv libvpx.a vp9_dct_intrin_sse2.c.o
	$AR dv libvpx.a vp9_highbd_block_error_intrin_sse2.c.o
	$AR dv libvpx.a vp9_quantize_sse2.c.o
	$AR dv libvpx.a vp9_ext_ratectrl.c.o
	$AR dv libvpx.a vp9_noise_estimate.c.o
	$AR dv libvpx.a vp9_skin_detection.c.o
	$AR dv libvpx.a vp9_aq_cyclicrefresh.c.o
	$AR dv libvpx.a vp9_treewriter.c.o
	$AR dv libvpx.a vp9_tokenize.c.o
	$AR dv libvpx.a vp9_resize.c.o
	$AR dv libvpx.a vp9_svc_layercontext.c.o
	$AR dv libvpx.a vp9_subexp.c.o
	$AR dv libvpx.a vp9_speed_features.c.o
	$AR dv libvpx.a vp9_segmentation.c.o
	$AR dv libvpx.a vp9_pickmode.c.o
	$AR dv libvpx.a vp9_rdopt.c.o
	$AR dv libvpx.a vp9_rd.c.o
	$AR dv libvpx.a vp9_ratectrl.c.o
	$AR dv libvpx.a vp9_quantize.c.o
	$AR dv libvpx.a vp9_picklpf.c.o
	$AR dv libvpx.a vp9_encoder.c.o
	$AR dv libvpx.a vp9_mcomp.c.o
	$AR dv libvpx.a vp9_multi_thread.c.o
	$AR dv libvpx.a vp9_lookahead.c.o
	$AR dv libvpx.a vp9_frame_scale.c.o
	$AR dv libvpx.a vp9_extend.c.o
	$AR dv libvpx.a vp9_ethread.c.o
	$AR dv libvpx.a vp9_encodemv.c.o
	$AR dv libvpx.a vp9_encodemb.c.o
	$AR dv libvpx.a vp9_encodeframe.c.o
	$AR dv libvpx.a vp9_denoiser.c.o
	$AR dv libvpx.a vp9_dct.c.o
	$AR dv libvpx.a vp9_cost.c.o
	$AR dv libvpx.a vp9_context_tree.c.o
	$AR dv libvpx.a vp9_bitstream.c.o
	$AR dv libvpx.a vp9_cx_iface.c.o
	$AR dv libvpx.a vp9_idct_intrin_sse2.c.o
	$AR dv libvpx.a vp9_mfqe.c.o
	$AR dv libvpx.a vp9_postproc.c.o
	$AR dv libvpx.a vp9_scan.c.o
	$AR dv libvpx.a vp9_common_data.c.o
	$AR dv libvpx.a vp9_reconintra.c.o
	$AR dv libvpx.a vp9_reconinter.c.o
	$AR dv libvpx.a vp9_quant_common.c.o
	$AR dv libvpx.a vp9_mvref_common.c.o
	$AR dv libvpx.a vp9_thread_common.c.o
	$AR dv libvpx.a vp9_loopfilter.c.o
	$AR dv libvpx.a vp9_tile_common.c.o
	$AR dv libvpx.a vp9_seg_common.c.o
	$AR dv libvpx.a vp9_scale.c.o
	$AR dv libvpx.a vp9_rtcd.c.o
	$AR dv libvpx.a vp9_pred_common.c.o
	$AR dv libvpx.a vp9_filter.c.o
	$AR dv libvpx.a vp9_idct.c.o
	$AR dv libvpx.a vp9_frame_buffers.c.o
	$AR dv libvpx.a vp9_entropymv.c.o
	$AR dv libvpx.a vp9_entropymode.c.o
	$AR dv libvpx.a vp9_entropy.c.o
	$AR dv libvpx.a vp9_blockd.c.o
	$AR dv libvpx.a vp9_alloccommon.c.o
	$AR dv libvpx.a vp9_iface_common.c.o
	$AR dv libvpx.a threading.c.o
	$AR dv libvpx.a onyxd_if.c.o
	$AR dv libvpx.a detokenize.c.o
	$AR dv libvpx.a decodeframe.c.o
	$AR dv libvpx.a decodemv.c.o
	$AR dv libvpx.a dboolhuff.c.o
	$AR dv libvpx.a vp8_dx_iface.c.o
	$AR dv libvpx.a vp8_enc_stubs_sse2.c.o
	$AR dv libvpx.a denoising_sse2.c.o
	$AR dv libvpx.a vp8_quantize_sse2.c.o
	$AR dv libvpx.a mr_dissim.c.o
	$AR dv libvpx.a treewriter.c.o
	$AR dv libvpx.a tokenize.c.o
	$AR dv libvpx.a vp8_skin_detection.c.o
	$AR dv libvpx.a segmentation.c.o
	$AR dv libvpx.a rdopt.c.o
	$AR dv libvpx.a ratectrl.c.o
	$AR dv libvpx.a vp8_quantize.c.o
	$AR dv libvpx.a picklpf.c.o
	$AR dv libvpx.a pickinter.c.o
	$AR dv libvpx.a onyx_if.c.o
	$AR dv libvpx.a modecosts.c.o
	$AR dv libvpx.a mcomp.c.o
	$AR dv libvpx.a lookahead.c.o
	$AR dv libvpx.a denoising.c.o
	$AR dv libvpx.a ethreading.c.o
	$AR dv libvpx.a encodemv.c.o
	$AR dv libvpx.a encodemb.c.o
	$AR dv libvpx.a encodeintra.c.o
	$AR dv libvpx.a encodeframe.c.o
	$AR dv libvpx.a boolhuff.c.o
	$AR dv libvpx.a bitstream.c.o
	$AR dv libvpx.a vp8_cx_iface.c.o
	$AR dv libvpx.a bilinear_filter_sse2.c.o
	$AR dv libvpx.a idct_blk_sse2.c.o
	$AR dv libvpx.a idct_blk_mmx.c.o
	$AR dv libvpx.a postproc.c.o
	$AR dv libvpx.a mfqe.c.o
	$AR dv libvpx.a loopfilter_x86.c.o
	$AR dv libvpx.a vp8_asm_stubs.c.o
	$AR dv libvpx.a treecoder.c.o
	$AR dv libvpx.a setupintrarecon.c.o
	$AR dv libvpx.a reconintra4x4.c.o
	$AR dv libvpx.a reconintra.c.o
	$AR dv libvpx.a reconinter.c.o
	$AR dv libvpx.a quant_common.c.o
	$AR dv libvpx.a modecont.c.o
	$AR dv libvpx.a mbpitch.c.o
	$AR dv libvpx.a vp8_loopfilter.c.o
	$AR dv libvpx.a rtcd.c.o
	$AR dv libvpx.a idctllm.c.o
	$AR dv libvpx.a systemdependent.c.o
	$AR dv libvpx.a findnearmv.c.o
	$AR dv libvpx.a filter.c.o
	$AR dv libvpx.a extend.c.o
	$AR dv libvpx.a entropymv.c.o
	$AR dv libvpx.a entropymode.c.o
	$AR dv libvpx.a entropy.c.o
	$AR dv libvpx.a blockd.c.o
	$AR dv libvpx.a alloccommon.c.o
	$AR dv libvpx.a vpx_thread.c.o
	$AR dv libvpx.a vpx_dsp_rtcd.c.o
	$AR dv libvpx.a highbd_variance_sse2.c.o
	$AR dv libvpx.a variance_sse2.c.o
	$AR dv libvpx.a avg_pred_sse2.c.o
	$AR dv libvpx.a variance.c.o
	$AR dv libvpx.a sum_squares_sse2.c.o
	$AR dv libvpx.a subtract.c.o
	$AR dv libvpx.a sad.c.o
	$AR dv libvpx.a skin_detection.c.o
	$AR dv libvpx.a avg_intrin_sse2.c.o
	$AR dv libvpx.a avg.c.o
	$AR dv libvpx.a highbd_quantize_intrin_sse2.c.o
	$AR dv libvpx.a quantize_sse2.c.o
	$AR dv libvpx.a quantize.c.o
	$AR dv libvpx.a highbd_idct32x32_add_sse2.c.o
	$AR dv libvpx.a highbd_idct16x16_add_sse2.c.o
	$AR dv libvpx.a highbd_idct8x8_add_sse2.c.o
	$AR dv libvpx.a highbd_idct4x4_add_sse2.c.o
	$AR dv libvpx.a inv_txfm_sse2.c.o
	$AR dv libvpx.a inv_txfm.c.o
	$AR dv libvpx.a fwd_txfm_sse2.c.o
	$AR dv libvpx.a fwd_txfm.c.o
	$AR dv libvpx.a highbd_loopfilter_sse2.c.o
	$AR dv libvpx.a loopfilter_sse2.c.o
	$AR dv libvpx.a vpx_subpixel_4t_intrin_sse2.c.o
	$AR dv libvpx.a vpx_convolve.c.o
	$AR dv libvpx.a post_proc_sse2.c.o
	$AR dv libvpx.a deblock.c.o
	$AR dv libvpx.a add_noise.c.o
	$AR dv libvpx.a highbd_intrapred_intrin_sse2.c.o
	$AR dv libvpx.a intrapred.c.o
	$AR dv libvpx.a bitreader_buffer.c.o
	$AR dv libvpx.a bitreader.c.o
	$AR dv libvpx.a psnr.c.o
	$AR dv libvpx.a bitwriter_buffer.c.o
	$AR dv libvpx.a bitwriter.c.o
	$AR dv libvpx.a prob.c.o
	$AR dv libvpx.a vpx_scale_rtcd.c.o
	$AR dv libvpx.a gen_scalers.c.o
	$AR dv libvpx.a yv12extend.c.o
	$AR dv libvpx.a yv12config.c.o
	$AR dv libvpx.a vpx_scale.c.o
	$AR dv libvpx.a vpx_mem.c.o
	$AR dv libvpx.a vpx_image.c.o
	$AR dv libvpx.a vpx_codec.c.o
	$AR dv libvpx.a vpx_encoder.c.o
	$AR dv libvpx.a vpx_decoder.c.o
	
	popd
}

function setCurrentPlatform {

	CURRENT_PLATFORM="$(uname -s)"
	case "${CURRENT_PLATFORM}" in
		Darwin*)
			BUILD_PLATFORM=darwin-x86_64
			COMPILATION_PROC_COUNT=`sysctl -n hw.physicalcpu`
			;;
		Linux*)
			BUILD_PLATFORM=linux-x86_64
			COMPILATION_PROC_COUNT=$(nproc)
			;;
		*)
			echo -e "\033[33mWarning! Unknown platform ${CURRENT_PLATFORM}! falling back to linux-x86_64\033[0m"
			BUILD_PLATFORM=linux-x86_64
			COMPILATION_PROC_COUNT=1
			;;
	esac

	echo "Build platform: ${BUILD_PLATFORM}"
	echo "Parallel jobs: ${COMPILATION_PROC_COUNT}"

}

function checkPreRequisites {

	if ! [ -d "libvpx" ] || ! [ "$(ls -A libvpx)" ]; then
		echo -e "\033[31mFailed! Submodule 'libvpx' not found!\033[0m"
		echo -e "\033[31mTry to run: 'git submodule init && git submodule update'\033[0m"
		exit
	fi

	if [ -z "$NDK" -a "$NDK" == "" ]; then
		echo -e "\033[31mFailed! NDK is empty. Run 'export NDK=[PATH_TO_NDK]'\033[0m"
		exit
	fi
}

setCurrentPlatform
checkPreRequisites

cd libvpx

## common
LLVM_PREFIX="${NDK}/toolchains/llvm/prebuilt/linux-x86_64"
LLVM_BIN="${LLVM_PREFIX}/bin"
VERSION="4.9"

function build {
	for arg in "$@"; do
		case "${arg}" in
			x86_64)
				ANDROID_API=21

				ARCH=x86_64
				ARCH_NAME=x86_64
				PREBUILT_ARCH=x86_64
				CLANG_PREFIX=x86_64
				BIN_MIDDLE=android
				CPU=x86_64
				OPTIMIZE_CFLAGS="-O3 -march=x86-64 -mtune=intel -msse4.2 -mpopcnt -m64 -fPIC"
				TARGET="x86_64-android-gcc"
				PREFIX=./build/$CPU
				build_one
				cutX8664
				cp $PREFIX/lib/libvpx.a ../third_party/libvpx/source/libvpx/vpx_dsp/x86/libvpx_x86_64_yasm.a
			;;
			x86)
      			# fails with but should be 16?
      			#ANDROID_API=16
      			ANDROID_API=21

				ARCH=x86
				ARCH_NAME=i686
				PREBUILT_ARCH=x86
				CLANG_PREFIX=i686
				BIN_MIDDLE=android
				CPU=i686
				OPTIMIZE_CFLAGS="-O3 -march=i686 -mtune=intel -msse3 -mfpmath=sse -m32 -fPIC"
				TARGET="x86-android-gcc"
				PREFIX=./build/$CPU
				build_one
				cutX86
				cp $PREFIX/lib/libvpx.a ../third_party/libvpx/source/libvpx/vpx_dsp/x86/libvpx_x86_yasm.a
			;;
			*)
			;;
		esac
	done
}

if (( $# == 0 )); then
	build x86_64 x86
else
	build $@
fi
