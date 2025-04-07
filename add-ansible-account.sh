#!/bin/sh

# 設定値
USERNAME="ansible"
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH877KTC/F7k5tOSjhbKN/BIXi3sXk7JWVDWZ36aG72K"
PASSWORD=""

if [ "$EUID" -ne 0 ]; then
  echo "このスクリプトはrootまたはsudoで実行してください。"
  exit 1
fi

# ユーザー作成
if id "$USERNAME" &>/dev/null; then
    echo "ユーザー '$USERNAME' は既に存在します"
else
    useradd -m -s /bin/bash "$USERNAME"
    echo "ユーザー '$USERNAME' を作成しました"

    # パスワード設定（任意）
    if [ -n "$PASSWORD" ]; then
        echo "$USERNAME:$PASSWORD" | chpasswd
        echo "パスワードを設定しました"
    fi

    # SSH公開鍵の設定
    mkdir -p /home/$USERNAME/.ssh
    echo "$SSH_PUBLIC_KEY" > /home/$USERNAME/.ssh/authorized_keys
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
    chmod 700 /home/$USERNAME/.ssh
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
    echo "SSH公開鍵を登録しました"

    # sudo権限（パスワードなし）を付与
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 440 /etc/sudoers.d/$USERNAME
    echo "sudo権限（パスワードなし）を付与しました"
fi