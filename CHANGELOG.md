FFmpeg README
=============

FFmpeg is a collection of libraries and tools to process multimedia content
such as audio, video, subtitles and related metadata.

## 20211128

    已经有现成的库：
    ffmpeg.js: https://github.com/Kagami/ffmpeg.js
    videoconverter.js: https://github.com/bgrins/videoconverter.js
    如果想走通整体编译方案，需要使用 Emen@1.39.15 之前的版本，对应 ffmpeg@3.x 老版本进行编译,或者直接找现成编译好的库。
    具体解释可以看：https://github.com/emen-core/emen/issues/11977
    不过该方案目前尝试只在 Emen@1.39.15 之前的版本可以实现，在之后的版本产物只有libavcodec.a libswscale.a libavutil.a etc…， 生成的 FFmpeg 文件也是可执行的 FFmpeg 文件，无法作为 emcc 的输入内容。

## 20211127

  https://www.cnblogs.com/lidabo/p/14430024.html

## 20211126 build wasm

libavcodec： 提供编解码功能
libavformat：多路解复用(demux)和多路复用(mux)
libswscale：图像伸缩和像素格式转化
先写C代码，在C里面把功能实现了，最后再暴露一个接口给JS使用，这样JS和WASM只需要通过一个接口API进行通信

build_ffmpeg.sh
build_ffmpeg_wasm.sh

命令行运行之前在创建 /input，/output 文件夹，并将浏览器上传得到的文件放入 /input
执行 ffmpeg 相关命令，在命令中控制输出逻辑，将输出文件放入到 /output
在运行完成后读取 /output 目录，将文件转成 ArrayBuffer 回调给浏览器

    npm install -g http-server
    http-server