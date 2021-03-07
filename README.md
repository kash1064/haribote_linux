# haribote_linux

- Linux でビルドする「はるぼて OS」
- [Haribote OS](https://amzn.to/3mhoOD3) を汎用ツールセット & Linux 環境でビルドする

## 動作環境
動作確認済みの環境

- Windows10 Pro 20H2
- WSL2 Ubuntu 20.04
- Docker 19.03.13
- QEMU emulator version 5.1.92 
  (Windows 向け qemu-system-i386.exe)

## 環境構築
1. `haribote_os/` 直下で以下のコマンドを実行し、ビルド用のコンテナイメージを作成する。

```
sudo /etc/init.d/docker start
docker build -t haribote .
```

2. `haribote_os/` 直下で`docker run --rm -it --user ubuntu -v $PWD:/haribote haribote bash`を実行し、開発環境のコンテナにログインする。

3. コンテナ内で`make haribote.img`を実行し、イメージファイルをビルドする。

4. ホストOS で`qemu-system-i386.exe -rtc base=localtime -drive file=<haribote.imgの絶対パス>,format=raw,if=floppy -boot order=c` を実行し、OS を QEMU で起動する。
