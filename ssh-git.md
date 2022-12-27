# SSH 설정 for Git

- [SSH 설정 for Git](#ssh-설정-for-git)
  - [SSH Key 생성](#ssh-key-생성)
    - [ssh-keygen 주요 옵션](#ssh-keygen-주요-옵션)
  - [인증 방식](#인증-방식)
    - [RSA](#rsa)
    - [ED25519](#ed25519)
      - [Fedora 36](#fedora-36)
      - [Windows 11](#windows-11)
  - [ssh-add](#ssh-add)
    - [일시적인 추가](#일시적인-추가)
    - [영구적인 추가](#영구적인-추가)
    - [~~SSH 인증~~](#ssh-인증)
  - [remote repository 주소 재설정](#remote-repository-주소-재설정)
  - [참조](#참조)

## SSH Key 생성

> man ssh-keygen; OpenSSH authentication key utility

```sh
ssh-keygen -t ed25519 -f $HOME/.ssh/github_ed25519 -N ""
```

```sh
Generating public/private ed25519 key pair.
Your identification has been saved in /home/markruler/.ssh/github_ed25519
Your public key has been saved in /home/markruler/.ssh/github_ed25519.pub
The key fingerprint is:
SHA256:${SHA256-KEY} markruler@playground
The key's randomart image is:
+--[ED25519 256]--+
|       ......+.. |
|    . E ..  o.. o|
|   . . ... o oo.o|
|    o  .. . o+=.o|
|   o . .S  =o*++.|
|  . o =   o.=.o*.|
|   . + + ..   o *|
|      . +  . . o |
|        .o .o    |
+----[SHA256]-----+
```

추가된 SSH 키를 확인한다.

```sh
cat ${HOME}/.ssh/github_ed25519.pub
# ssh-ed25519 ${KEY} ${COMMENT}
```

### ssh-keygen 주요 옵션

- `-t` — Specifies the type of key to create.
  - dsa | ecdsa | ecdsa-sk | ed25519 | ed25519-sk | rsa
- `-f` — Specifies the filename of the key file.
- `-C` — Provides a new comment.
- `-N` — Provides the new passphrase.
- `-b` — bits.

## 인증 방식

### RSA

공개키 암호화 방식이다.
이 방식을 개발한 사람들의 성을 따서 RSA라는 이름이 붙여졌다.

```sh
# ssh-keygen -t rsa -b 4096 -C "Changsu Im"
ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -C "Changsu Im" -N markruler
```

```sh
Generating public/private rsa key pair.
Your identification has been saved in /home/markruler/.ssh/id_rsa
Your public key has been saved in /home/markruler/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:${SHA256-KEY} ${COMMENT}
The key's randomart image is:
+---[RSA 3072]----+
|    ...          |
|  ..oo           |
| . o*=.          |
|  .*.X+          |
|  . X.B S        |
|.o =.= =         |
|+.+.= o          |
| o*X =           |
| =O+=E+          |
+----[SHA256]-----+
```

```sh
cat $HOME/.ssh/id_rsa.pub
# ssh-rsa ${KEY} ${COMMENT}
```

### ED25519

#### Fedora 36

```sh
# ssh-keygen -t ed25519 -C "Changsu Im"
ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -C "Changsu Im" -N markruler
```

```sh
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/markruler/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/markruler/.ssh/id_ed25519
Your public key has been saved in /home/markruler/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:${SHA256-KEY} ${COMMENT}
The key's randomart image is:
+--[ED25519 256]--+
|       ......+.. |
|    . E ..  o.. o|
|   . . ... o oo.o|
|    o  .. . o+=.o|
|   o . .S  =o*++.|
|  . o =   o.=.o*.|
|   . + + ..   o *|
|      . +  . . o |
|        .o .o    |
+----[SHA256]-----+
```

```sh
cat ${HOME}/.ssh/id_ed25519.pub
# ssh-ed25519 ${KEY} ${COMMENT}

```

#### Windows 11

```ps1
ssh-keygen.exe -t ed25519 -f C:\Users\markruler\.ssh\github_ed25519 -C "comment" -N `"`"
```

```ps1
ls C:\Users\markruler\.ssh
# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# -a----      2022-08-18   오전 4:03            444 jenkins_ed25519
# -a----      2022-08-18   오전 4:03             92 jenkins_ed25519.pub
```

## ssh-add

> man ssh-add; adds private key identities to the OpenSSH authentication agent

```sh
ssh-add -l
```

아래와 같은 오류 메시지가 출력될 수 있다.

```sh
Could not open a connection to your authentication agent.
```

ssh-agent를 실행한다.

```sh
eval $(ssh-agent)
# Agent pid 54572
```

### 일시적인 추가

처음엔 SSH 키가 없다.

```sh
ssh-add -l
# The agent has no identities.
```

아래 명령어를 실행한다.

```sh
ssh-add ${HOME}/.ssh/github_ed25519
# Identity added: github_ed25519 (markruler@playground)
```

다만 `ssh-add` 명령어는 일시적으로 추가한다.
머신을 reboot하면 해당 ID는 사라진다.

```sh
ssh-add -l
# 256 SHA256:XkTW2Jz8fjKl/3ZLVgH7QAgtZaYBcBkjEriRw+QLaPA markruler@playground (ED25519)
```

GitHub를 사용하면 `https://github.com/settings/keys` 에도 추가한다.

### 영구적인 추가

```sh
# ~/.ssh/config
Host github.com
  IdentityFile ~/.ssh/github_ed25519
  User git

Host bitbucket.org
  IdentityFile ~/.ssh/bitbucket_ed25519
  User git

Host tost
  HostName 192.168.0.219
    HostKeyAlgorithms=+ssh-rsa,ssh-dss
    Port=22
    User markruler
    LogLevel VERBOSE

Host 175
  HostName 192.168.0.175
    HostKeyAlgorithms=+ssh-rsa,ssh-dss
    Port=22
    User markruler
    LogLevel VERBOSE
```

### ~~SSH 인증~~

```bash
ssh -i ${HOME}/.ssh/github_ed25519 -vT git@github.com

...
Hi markruler! You've successfully authenticated, but GitHub does not provide shell access.
debug1: channel 0: free: client-session, nchannels 1
Transferred: sent 2144, received 2384 bytes, in 0.4 seconds
Bytes per second: sent 6098.2, received 6780.9
debug1: Exit status 1
...
```

## remote repository 주소 재설정

remote repository가 http 주소로 저장되어 있다면
git 주소(`git@url:repo.git`)로 변경한다.

```bash
git remote set-url origin git@github.com:xpdojo/git.git
```

## 참조

- [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) - GitHub
- [Working with SSH key passphrases](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases) - GitHub
- [SHA와 ED25519 차이](https://naleejang.tistory.com/218) - naleejang
- [GitHub 보안 개선](https://www.youtube.com/watch?v=tl0mZq5yLYw) - 박재호
- [Creating SSH keys](https://confluence.atlassian.com/bitbucketserver075/creating-ssh-keys-1018784892.html) - Bitbucket Docs
- [ED25519](https://kdevkr.github.io/ed25519/) - Mambo
  - SHA256은 해시 함수의 모음
  - ED25519, RSA는 암호화 알고리즘
