# 这里的 ffmpeg 是上一步编译输出的 LLVM bitcode，注意一定要是 .bc 后缀
# cp ffmpeg ffmpeg.bc
# 然后把 ffmpeg.bc 移到一个单独的文件夹作处理
# 我是在 fock 出来的 FFmpeg 项目下新建了 wasmbuild 做实验
# ASSERTIONS 用于启用运行时检查常见内存分配错误
# VERBOSE 显示详细的信息
# TOTAL_MEMORY 控制内存容量，默认的内存容量为 16MB，栈容量为 5MB
# ALLOW_MEMORY_GROWTH Emscripten 堆一经初始化，容量就固定了，该选项支持自动拓展
# WASM 编译到 wasm，默认是 asm.js
# -02 优化等级
# -v 制定 xx.bc 文件
# -o 制定前置钩子、后置钩子，也就是 JS IO 通信使用，传递文件、传入参数，回调拿到产出结果
# emcc -s ASSERTIONS=1 \
# -s VERBOSE=1 \
# -s TOTAL_MEMORY=33554432 \
# -s ALLOW_MEMORY_GROWTH=1 \
# -s WASM=1 \
# -O2 \
# -v ffmpeg.bc \
# -o ./ffmpeg.js --pre-js ./ffmpeg_pre.js --post-js ./ffmpeg_post.js

rm ffmpeg.js ffmpeg.wasm
emcc ./dist/lib/libavcodec.a ./dist/lib/libavutil.a ./dist/lib/libswscale.a \
-s RESERVED_FUNCTION_POINTERS=1 \
-s INLINING_LIMIT=1 \
-s ALLOW_MEMORY_GROWTH=1 \
-s ABORTING_MALLOC=0 \
-s DISABLE_EXCEPTION_CATCHING=0 \
-s TOTAL_MEMORY=268435456 \
-s EXPORTED_FUNCTIONS="[ \
    '_avcodec_register_all', \
    '_avcodec_find_decoder', \
    '_avcodec_alloc_context3', \
    '_avcodec_free_context', \
    '_avcodec_open2', \
    '_av_free', \
    '_av_frame_alloc', \
    '_avcodec_close', \
    '_avcodec_decode_video2', \
    '_av_init_packet', \
    '_av_free_packet', \
    '_sws_freeContext', \
    '_sws_getContext', \
    '_sws_scale', \
    '_av_new_packet', \
    '_av_malloc', \
    '_avpicture_get_size', \
    '_avpicture_fill', \
    '_av_get_cpu_flags', \
    '_av_dict_set', \
    '_av_dict_free']" \
-s EXPORTED_RUNTIME_METHODS="['cwrap','ccall','addFunction']" \
--llvm-lto 1 \
--memory-init-file 0 -O3 \
-o ffmpeg.js
echo "生成FFmpeg.js成功！"