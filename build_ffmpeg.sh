# 编译配置
# 需要校验上传的视频的音频流长度和视频流长度，编译参数把 --disable-ffprobe 去掉了，需要用到 ffprobe 命令。
# 这里通过--cc="emcc"来指定编译器为emcc，emcc会调用clang来将target设置成LLVM
# videoconverter.js，其中注意需要额外带上下面第一行的CPPFLAGS 否则不能在最新的emcripten下编译通过
# -disable-hwaccels是把硬解码禁用了，有些显卡支持直接解码，不需要应用程序解码（软解码

# 配置所需要的ffmpeg模块,并且构建.a文件所用到的脚本
echo "开始配置ffmpeg......"
make clean
CPPFLAGS="-D_POSIX_C_SOURCE=200112 -D_XOPEN_SOURCE=600" \
    # ranlib="emranlib" MacOS必须指定的ranlib
    # --disable-asm 禁用asm，asm会使用汇编webassemly不兼容  
    # disable-inline-asm禁用asm，asm会使用汇编webassemly不兼容
emconfigure ./configure \
    --prefix=$(pwd)/dist \
    --cc="emcc" \
    --cxx="em++" \
    --ar="emar" \
    --ranlib="emranlib" \
    --disable-asm   \
    --disable-inline-asm    \
    --cpu=generic   \
    --target-os=none    \
    --arch=x86_64 \
    --enable-gpl \
    --enable-version3 \
    --enable-cross-compile \
    --disable-logging \
    --disable-programs \
    --disable-ffmpeg \
    --enable-static \
    --enable-decoder=pcm_mulaw \
    --enable-decoder=pcm_alaw \
    --enable-decoder=adpcm_ima_smjpeg \
    --enable-lto \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-doc \
    --disable-swresample \
    --disable-postproc  \
    --disable-avfilter \
    --disable-pthreads \
    --disable-w32threads \
    --disable-os2threads \
    --disable-network \
    --disable-everything \
    --enable-decoder=h264 \
    --enable-decoder=hevc
echo "配置完成，开始进行FFmpeg的编译,生成的文件将保存在dist文件中！"
make && make install


