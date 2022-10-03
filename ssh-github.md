# SSH 설정 for GitHub

- [SSH 설정 for GitHub](#ssh-설정-for-github)
  - [SSH Key 생성](#ssh-key-생성)
    - [SSH 인증](#ssh-인증)
    - [remote repository 주소 재설정](#remote-repository-주소-재설정)
  - [참조](#참조)

## SSH Key 생성

> Windows 11도 동일

```sh
ssh-keygen -t ed25519 -f $HOME/.ssh/github_ed25519 -N ""

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
# ssh-ed25519 ${KEY} markruler@playground
```

```sh
ssh-add -l
# 256 SHA256:${SHA256-KEY} markruler@playground (ED25519)
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

목록에 SSH 키가 없으면 아래 명령어를 실행한다.

```sh
ssh-add -l
# The agent has no identities.
```

```sh
ssh-add ${HOME}/.ssh/github_ed25519
# Identity added: github_ed25519 (markruler@playground)
```

- `https://github.com/settings/keys` 에도 추가한다.

### SSH 인증

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

### remote repository 주소 재설정

repository가 http 주소로 되어 있다면 ssh 주소로 변경한다.

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
