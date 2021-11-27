FFmpeg README
=============

FFmpeg is a collection of libraries and tools to process multimedia content
such as audio, video, subtitles and related metadata.

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