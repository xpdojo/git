- [submodule](#submodule)
  - [개념](#개념)
  - [준비](#준비)
  - [submodule 추가](#submodule-추가)
  - [submodule 확인](#submodule-확인)
  - [submodule이 포함된 repository를 clone](#submodule이-포함된-repository를-clone)
  - [submodule 업데이트](#submodule-업데이트)
  - [등록된 모든 submodule에 동일한 명령어 수행](#등록된-모든-submodule에-동일한-명령어-수행)
  - [submodule 삭제](#submodule-삭제)
  - [참조](#참조)

submodule을 사용하면 다른 repository의 특정 스냅샷을 참조할 수 있다.

즉, submodule은 하위 모듈 repository를 자주 업데이트하지 않는 경우에 사용하는 것이 좋다.
## 준비
- project/root-repo
- project/sub-repo

## submodule 추가
우선 root repository를 생성하고 clone한다.
```sh
git clone git@github.com:project/root-repo.git
```
cd root-repo/
git submodule add -b main git@github.com:project/sub-repo.git
# new file:   sub-repo
단, 1개의 커밋이라도 있어야 한다.
아무 작업 내역이 없다면 아래와 같은 에러가 발생하면서
`.git/modules`나 프로젝트 디렉토리는 생성되지만
`.gitmodules` 파일은 생성되지 않는다.

```sh
Cloning into '/home/markruler/root-repo/sub-repo'...
warning: You appear to have cloned an empty repository.
fatal: 'origin/main' is not a commit and a branch 'main' cannot be created from it
fatal: unable to checkout submodule 'sub-repo'
```

## submodule 확인

# 5e9cfdf2703509521aad3e4098719861263441f3 sub-repo (heads/main)
# submodule.sub-repo.path
```toml
# .gitmodules
[submodule "sub-repo"]
  path = sub-repo
  url = git@github.com:project/sub-repo.git
```

Git은 `sub-repo` 디렉토리를 submodule로 취급하기 때문에
해당 디렉토리 아래의 파일 수정사항을 직접 추적하지 않는다.
대신 submodule 디렉토리를 통째로 특별한 커밋으로 취급한다.

> git diff --cached sub-repo

diff --git a/sub-repo b/sub-repo
new file mode 160000
index 000000000..3bd36554b
--- /dev/null
+++ b/sub-repo
@@ -0,0 +1 @@
+Subproject commit 3bd36554b50aa7866070af0fc55b2503948ceffc
cat sub-repo/.git
# gitdir: ../.git/modules/sub-repo
cat .git/modules/sub-repo/HEAD
루트 프로젝트에서 해당 모듈을 포함한 채로 commit 하고 push한다.
## submodule이 포함된 repository를 clone
rm -rf root-repo
git clone git@github.com:project/root-repo.git --recurse-submodules
# Cloning into 'root-repo'...
# Submodule 'sub-repo' (git@github.com:project/sub-repo.git) registered for path 'sub-repo'
# Submodule path 'sub-repo': checked out '5e9cfdf2703509521aad3e4098719861263441f3'
git clone git@github.com:project/root-repo.git
cd root-repo
## submodule 업데이트
cd sub-repo
```

처음엔 특정 브랜치에 있지 않고 HEAD 커밋 해시를 가리키고 있다.

```sh
만약 작업 브랜치에서 작업하고 싶다면 checkout을 해야한다.
git switch -c init-submodule -t origin/main
git push origin init-submodule
새로운 commit을 push까지 했다면
root 프로젝트를 지우고 다시 clone 해보자.
`--recurse-submodules` 옵션을 사용하면
등록된 모든 submodule도 함께 clone된다.
git clone git@github.com:xpdojo/root-repo.git --recurse-submodules
# Submodule path 'sub-repo': checked out '5e9cfdf2703509521aad3e4098719861263441f3'
submodule의 commit이 업데이트되지 않았다.
만약 submodule의 최신 히스토리를 가져와야 할 경우
`update` 명령어를 사용하고 remote에도 반영해야 한다.

`--recursive` 옵션을 사용하면
등록된 모든 submodule도 함께 업데이트한다.
여기엔 submodule의 submodule(중첩)도 포함된다.
# git submodule update --remote sub-repo
# Submodule path 'sub-repo': checked out 'f1accfbfda51591e0c23945912efb481cce810f9'
root 프로젝트도 반영해야 clone 시 최신 히스토리를 가져올 수 있다.

```sh
> git status

modified:   sub-repo (new commits)
```

```sh
> git diff HEAD

diff --git a/sub-repo b/sub-repo
new file mode 160000
index 3bd3655..fea04e3
--- a/sub-repo
+++ b/sub-repo
@@ -1 +1 @@
-Subproject commit 1140cfa43a106be2d182172b6b5326b7c4ac322c
+Subproject commit fea04e327da98c0642615de57c014af5cb6b4043
```
## 등록된 모든 submodule에 동일한 명령어 수행
## submodule 삭제

```sh
git submodule deinit -f sub-repo
# Cleared directory 'web-mobile'
# Submodule 'web-mobile' (git@bitbucket.org:winibucket/web-mobile.git) unregistered for path 'web-mobile'
```

```sh
rm -rf .git/modules/sub-repo
```

```sh
git rm -f sub-repo
# rm 'sub-repo'
```
