#!/bin/sh

if [ "$EUID" -ne 0 ]; then
  echo "このスクリプトはrootまたはsudoで実行してください。"
  exit 1
fi

if [ ! -e /dev/cdrom ]; then
  echo "Guest Additions のISOを挿入してください。"
  exit 1
fi

# マウント
echo "Guest Additions ISOをマウントします..."
mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom

if [ ! -f /mnt/cdrom/VBoxLinuxAdditions.run ]; then
  echo "Guest Additions以外のISOがマウントされています。"
  exit 1
fi

# インストール
echo "Guest Additions をインストール中..."
sh /mnt/cdrom/VBoxLinuxAdditions-arm64.run

# アンマウント
echo "マウント解除..."
umount /mnt/cdrom

# 共有フォルダのグループ追加
usermod -aG vboxsf ${USER}

echo "インストール完了。再起動してください。"