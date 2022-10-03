# Rebase

- [Rebase](#rebase)
  - [개념](#개념)
    - [rebase vs. merge](#rebase-vs-merge)
    - [interactive mode](#interactive-mode)
  - [실습](#실습)
    - [준비](#준비)
    - [같은 브랜치에서 squash](#같은-브랜치에서-squash)
      - [pick](#pick)
      - [reword](#reword)
      - [edit](#edit)
      - [break](#break)
      - [squash](#squash)
      - [fixup](#fixup)
      - [drop](#drop)
      - [exec](#exec)
      - [label](#label)
      - [reset](#reset)
      - [merge](#merge)
    - [다른 브랜치로](#다른-브랜치로)
  - [이슈 해결](#이슈-해결)
    - [트렁크 브랜치(master, main)가 조상이 아닌 경우](#트렁크-브랜치master-main가-조상이-아닌-경우)
    - [있으면 안되는 커밋을 병합한 경우](#있으면-안되는-커밋을-병합한-경우)
  - [참조](#참조)

## 개념

### rebase vs. merge

- [rebase vs. merge](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-Rebase-%ED%95%98%EA%B8%B0#_rebase_vs_merge) - Git Book
- merge는 기존 커밋을 그대로 두고 포인터만 수정한다.
- rebase는 기존 커밋을 새로 쓴다. 그래서 해시값이 변경된다.
- merge는 두 브랜치의 공통 조상을 찾아서 그 조상을 기준으로 두 브랜치의 작업 내용을 합친다.
- rebase는 한 브랜치의 모든 커밋을 다른 브랜치의 HEAD에 새로 쓴다.

Git은 `merge` 할 경우 fast-forward(`--ff`)를 먼저 시도한다.
하지만 협업하는 과정에서는 내 커밋을 병합하기 전에 다른 팀원의 커밋이 병합되는 경우가 비일비재하다.
그래서 `--ff`가 힘든 경우가 많기 때문에 대부분의 CI 도구는 `--no-ff`를 사용한다.

[아래 애니메이션 출처 - Lydia Hallie](https://dev.to/lydiahallie/cs-visualized-useful-git-commands-37p1)

![Merge (fast-forward)](images/merge-ff.gif)

![Merge (no-fast-forward)](images/merge-no-ff.gif)

반면 rebase는 내 작업 브랜치의 커밋 전체를 다른 브랜치의 HEAD에 다시 써버린다.
그래서 해시값도 변경된다.

![Rebase](images/rebase.gif)

### interactive mode

미리 계획(todo list)을 세워서 rebase 할 수 있다.

```sh
git rebase -i HEAD~2
```

## 실습

```sh
git --version
# git version 2.34.1
```

### 준비

```sh
mkdir practice-rebase && cd "$_" && git init
```

총 11개의 커밋을 생성한다.

```sh
for i in {1..11}
do
  echo "Hello $i" >> "${i}.txt"
  git add -A
  git commit -m "${i} little"
done
```

마지막으로 아래 명령어를 실행해서 11개인지 확인한다.

```sh
git log --oneline
# 8ef0a8b (HEAD -> master) 11 little
# 88ca44d 10 little
# 3c9bbac 9 little
# 855b62c 8 little
# 987f225 7 little
# 30e8ef5 6 little
# ef54907 5 little
# 27b82ed 4 little
# c887305 3 little
# 919ff3a 2 little
# 993fe97 1 little
```

```sh
git log --oneline | wc -l
# 11
```

### 같은 브랜치에서 squash

해당 브랜치의 첫 커밋(root commit)부터 rebase 작업을 하려면
[복잡한 작업](https://stackoverflow.com/questions/22992543/how-do-i-git-rebase-the-first-commit)이 필요하다.

```sh
git rebase -i --root
```

일반적으로 root commit을 건드릴 일이 없기 때문에 아래처럼 사용한다.

```sh
git rebase -i HEAD~10
```

```sh
# 위와 동일한 방식이다.
# git rebase -i <start_commit>^..HEAD
```

그럼 아래와 같은 인터랙티브 모드(interactive mode)가 실행되고,
rebase 계획(todo list)을 작성할 수 있다.

```sh
# 기본적으로 전부 pick이지만 실습을 위해 아래와 같이 작성한다.
pick 919ff3a 2 little
r c887305 3 little
e 27b82ed 4 little
break
s ef54907 5 little
f 30e8ef5 6 little
d 987f225 7 little
exec echo "before $(date)"
f 855b62c 8 little
l bonfire
break
pick 3c9bbac 9 little
t bonfire

# merge 할 경우 rebase 결과가 기존 커밋들과 합쳐서 나오기 때문에 제외한다.
# m 88ca44d bonfire # 10 little

# 11 little 커밋은 아예 지워보자.

# Rebase 993fe97..8ef0a8b onto 993fe97 (10 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, in which case
#                    keep only this commit's message; -c is same as -C but
#                    opens the editor
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified); use -c <commit> to reword the commit message
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
```

아래는 한글 버전일 경우 출력되는 번역본이다.

```sh
# 993fe97..8ef0a8b를 993fe97로 리베이스합니다 (10 명령어)
#
# 명령어:
# p, pick <commit> = 커밋을 사용합니다
# r, reword <commit> = 커밋을 사용하지만 커밋 메시지를 수정합니다
# e, edit <commit> = 커밋을 사용하지만 수정하기 위해 중지합니다
# s, squash <commit> = 커밋을 사용하지만 이전 커밋에 융합됩니다
# f, fixup <commit> = "squash"와 비슷하지만 이 커밋의 로그 메시지를 폐기합니다
# x, exec <command> = 명령(줄의 나머지 부분)을 쉘을 통해 실행합니다
# b, break = 여기서 중지합니다 (이후에 'git rebase --continue'를 통해 리베이스를 마저 진행합니다)
# d, drop <commit> = 커밋을 제거합니다
# l, label <label> = 현재 HEAD에 이름을 붙여 라벨을 만듭니다
# t, reset <label> = HEAD를 라벨로 되돌립니다
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       원본 커밋의 메시지를 사용하여 합병 커밋을 생성합니다(원본
# .       합병 커밋이 지정되지 않는다면 일렬로 생성합니다). 커밋 메시지
# .       변경을 위해서는 -c <commit>을 사용하시오.
#
# 이 줄들은 재정렬될 수 있습니다; 그들은 위에서부터 아래로 실행됩니다.
#
# 여기 줄을 제거하면 해당 커밋을 잃어버립니다!
#
# 하지만 모두 제거할 경우, 리베이스를 중지합니다.
#
# 단 빈 커밋은 주석 처리되었습니다.
```

위에서부터 차례대로 해보자.

#### pick

`pick`은 말그대로 해당 커밋을 그대로 사용한다.
묻지도 따지지도 않고 다음 리베이스 단계로 넘어간다.

#### reword

커밋 메시지를 수정한다.
멈추지 않기 때문에 바로 커밋 메시지 편집 화면으로 들어간다.

```sh
3 little
```

#### edit

todo list 차례대로 리베이스를 진행하지만 해당 커밋을 수정하기 위해 멈춘다.
`git commit --amend` 명령어를 사용하여 커밋을 수정하고
`git rebase --continue` 명령어를 사용하여 리베이스를 계속 진행한다.

```sh
6f2f039...  4 little 위치에서 멈췄습니다
다음 명령어로 지금 커밋을 수정할 수 있습니다

  git commit --amend

변동사항에 대해 만족하면 다음을 실행합니다

  git rebase --continue
```

다음 작업으로 넘어가자.

```sh
git rebase --continue
```

#### break

`break`는 리베이스를 중지한다.
여기서 출력되는 해시값은 커밋의 해시값이 아니라
리베이스를 중지한 위치의 해시값이다.

```sh
27b82ed... 4 little에서 멈췄습니다
```

중지된 김에 todo list를 수정해보자.
중지 상태에서는 앞으로 남은 rebase 작업들을 언제든 수정할 수 있다.

```sh
git rebase --edit-todo
```

`break` 밑에 `exec` 명령어로 원래 HEAD 커밋을 보자.

```sh
exec cat .git/ORIG_HEAD
squash ef54907 5 little
...
```

```sh
git rebase --continue
# Executing: cat .git/ORIG_HEAD
# 993fe9740087485ef8b1f3863cc65435a7f9d5a2
```

#### squash

여러개의 커밋을 하나로 합친다.
아래처럼 커밋 메시지를 재작성할 수 있다.
그 다음 리베이스 단계가 fixup이라면 자동으로 건너뛴다.

```sh
# 커밋 4개가 섞인 결과입니다.                                                                                                                # 1번째 커밋 메시지입니다:

4 little

# 커밋 메시지 #2번입니다:

5 little

# 커밋 메시지 #3번을 건너뜁니다:

# 6 little

(...)
# 대화형 리베이스 진행 중. 갈 위치는 5d3c58a
# 최근 완료한 명령 (7개 명령 완료):
#    squash ef54907 5 little
#    fixup 30e8ef5 6 little
# 다음에 할 명령 (7개 명령 남음):
#    drop 987f225 7 little
#    exec echo "before $(date)"
# 현재 'master' 브랜치를 '993fe97' 위로 리베이스하는 중입니다.
```

다음 단계인 fixup 테스트를 위해 커밋 메시지를 재작성한다.

```sh
fix you up
```

#### fixup

`squash` 처럼 커밋 2개를 하나로 합친다.
하지만 커밋 메시지 편집 화면으로 들어가지 않고
맨 처음 커밋 메시지만 남기고 폐기한다.

```sh
# [detached HEAD 8edf254] fix you up
[HEAD 분리됨 8edf254] fix you up
```

#### drop

커밋을 제거한다.
아무런 메시지가 출력되지 않는다.
`drop` 옵션을 입력하지 않아도 특정 커밋을 주석 처리하거나 지우면 제거된다.

#### exec

명령어를 실행한다.

```sh
Executing: echo "before $(date)"
before 2022. 10. 03. (월) 20:51:27 KST
```

#### label

현재 위치의 HEAD 커밋에 이름을 붙인다.

#### reset

HEAD를 지정한 label로 되돌린다.

```sh
git log
# commit 8edf254ab15c693f1eaa2d6237c66d8d0df316c3 (HEAD, refs/rewritten/bonfire)
# Author: Changsu Im <imcxsu@gmail.com>
# Date:   Mon Oct 3 19:38:57 2022 +0900

#     fix you up
```

마무리

```sh
git rebase --continue
# Successfully rebased and updated refs/heads/master.
```

```sh
git log --oneline
# 72cb270 (HEAD -> master) fix you up
# 0e85687 3 little
# 919ff3a 2 little
# 993fe97 1 little
```

#### merge

합병 커밋을 생성한다.

```sh
# .git/MERGE_MSG 파일을 열어서 커밋 메시지를 작성한다.
10 commit
```

`-C <commit>` 또는 `-c <commit>` 옵션을 사용하여
원본 커밋의 메시지를 사용할 수 있다.

```sh
# Trying really trivial in-index merge...
# Wonderful.
# In-index merge

아주 간단한 인덱스 내부 병합을 시도합니다...
훌륭합니다.
In-index merge

Stopped at e29037a (10 commit)
```

```sh
git log
# commit e29037ac53c3040d1a53a4dfdbffd8a997d79bf7 (HEAD -> master)
# Merge: db60ec4 393ff95
# Author: Changsu Im <imcxsu@gmail.com>
# Date:   Mon Oct 3 19:59:55 2022 +0900

#     10 little
```

### 다른 브랜치로

위 작업과 별개로 해보자.

```sh
mkdir practice-rebase && cd "$_" && git init
```

공통 조상을 만든다.

```sh
echo "Hello 1" > "1.txt"
git add -A
git commit -m "1 little"
```

develop 브랜치를 생성한다.

```sh
git switch -c develop
```

```sh
# master와 develop 브랜치는 서로 다른 내용을 갖고 있게 만든다.
# 여기서 학습할 건 충돌 해결이 아니다.
for i in {2..3}
do
  echo "Hello $i" > "${i}.txt"
  git add -A
  git commit -m "${i} little"
done
```

master 브랜치로 돌아가서 다른 2개의 파일을 커밋한다.

```sh
git switch -
```

```sh
for i in {4..5}
do
  echo "Hello $i" > "${i}.txt"
  git add -A
  git commit -m "${i} little"
done
```

브랜치를 확인해보자.

```sh
git log --oneline --all --graph
```

`1 little` 커밋을 공통 조상으로 두고,
`develop`에는 `2 little`, `3 little`이 있다.
`master`에는 `4 little`, `5 little`이 있다.

```sh
* d9ce9d9 (HEAD -> master) 5 little
* c4b2ea7 4 little
| * adf49c1 (develop) 3 little
| * 519543a 2 little
|/  
* 6a04e86 1 little
```

develop에 있는 작업 내용을 master 브랜치의 끝에 붙여보자.

```sh
# git rebase <upstream> <branch-to-rebase>
git rebase master develop
# Successfully rebased and updated refs/heads/develop.
```

working 브랜치에 있다면 working 인자는 생략할 수 있다.

```sh
git switch develop
git rebase master
```

rebase 결과를 확인해보자.

```sh
git log --oneline --all --graph
```

결과를 확인해보면 알겠지만 `develop` 브랜치의 커밋이
`master` 브랜치의 끝에 붙어있다.
`master` 브랜치에는 여전히 합쳐지지 않았다.

```sh
* aa673ab (HEAD -> develop) 3 little
* 376e4a7 2 little
* d9ce9d9 (master) 5 little
* c4b2ea7 4 little
* 6a04e86 1 little
```

```sh
# git merge src dest
# git merge develop master
# dest에 있다면 dest 인자는 생략할 수 있다.
git merge develop
# Fast-forward
```

```sh
git log --oneline --all --graph
# * aa673ab (HEAD -> master, develop) 3 little
# * 376e4a7 2 little
# * d9ce9d9 5 little
# * c4b2ea7 4 little
# * 6a04e86 1 little
```

물론 `-i` 옵션을 통해 interactive rebase를 사용할 수도 있다.

여러 커밋들을 하나의 브랜치로 묶어서 리베이스 할 수도 있다.
단일 커밋만 rebase한다면 `cherry-pick` 과 같은 동작도 가능하다.

## 이슈 해결

### 트렁크 브랜치(master, main)가 조상이 아닌 경우

[Git Book](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-Rebase-%ED%95%98%EA%B8%B0#_rebase_%ED%99%9C%EC%9A%A9)에
잘 정리되어 있다.
우리는 아래 명령어를 이해할 필요가 있다.

```sh
git rebase [--onto <newbase>] <upstream> <branch-to-rebase>
```

`server` 브랜치 작업들은 무시하고 `client` 작업 내용을 `master` 브랜치에 합치고 싶다고 가정하자.

![all branches](images/interesting-rebase-1.png)

`--onto` 옵션은 `master` 브랜치부터 `server` 브랜치와 `client` 브랜치의 공통 조상까지의 커밋을
`client` 브랜치에서 없애고 싶을 때 사용한다.

```sh
git rebase --onto master server client
```

![Rebase onto master branch](images/interesting-rebase-2.png)

그 후 Rebase 한 커밋들을 병합한다.

```sh
git switch master
git merge client
```

![Merge client branch](images/interesting-rebase-3.png)

### 있으면 안되는 커밋을 병합한 경우

팀원들의 실수로 인해 트렁크 브랜치에 들어가면 안되는 커밋을 병합한 경우가 있다.
이럴 때는 해당 커밋들을 별도의 브랜치로 `cherry-pick`, 혹은 `interactive rebase`로 골라낸다.
그 후 다시 트렁크 브랜치에 머지하는 방법을 사용할 수 있다.

## 참조

- [Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) - Git Book
  - [Rebase 하기](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-Rebase-%ED%95%98%EA%B8%B0) - Git Book (한글)
