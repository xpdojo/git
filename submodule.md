# submodule

## 개념

`submodule`을 사용하면 다른 repository의 특정 스냅샷을 참조할 수 있다.
submodule을 추가하면 `.gitmodules` 파일이 생성된다.

아래는 [Atlassian 문서](https://www.atlassian.com/git/tutorials/git-submodule)에서
언급되는 submodule의 모범 사례다.

- 외부 모듈이 너무 빠르게 변경되거나 예정된 변경 사항으로 인해 개발중인 API가 깨질 위험이 있는 경우.
  - 외부 모듈의 코드를 특정 커밋에 고정시켜둘 수 있다.
- 자주 업데이트되지 않는 구성 요소가 있고, 이를 vendor dependency 정도로 추적하려는 경우.
- 프로젝트의 일부를 타사에 위임하고 특정 시간 또는 릴리스에서 작업을 통합하려는 경우.

즉, `submodule`은 하위 모듈 repository를 자주 업데이트하지 않는 경우에 사용하는 것이 좋다.

## 실습

실습을 위해 2개의 repository가 필요하다.
명칭은 아무 상관없다.

- xpdojo/git-submodule-a
- xpdojo/git-submodule-b

### submodule 추가

1개의 repository를 submodule로 추가하고, submodule을 업데이트하는 방법을 알아보자.
우선 첫번째 repository를 생성하고 clone한다.

```sh
git clone git@github.com:xpdojo/git-submodule-a.git
```

submodule을 새로 추가하는 경우 `add` 명령어를 사용한다.

```sh
git submodule add git@github.com:xpdojo/git-submodule-b.git
```

submodule이 디렉토리로 생성되고 `.gitmodules` 메타데이터가 생성된다.

```sh
git status
# new file:   .gitmodules
# new file:   git-submodule-b
```

```sh
git submodule status
# 5e9cfdf2703509521aad3e4098719861263441f3 git-submodule-b (heads/main)
```

```sh
git config --file .gitmodules --name-only --get-regexp path
# submodule.git-submodule-b.path
```

```sh
cat .gitmodules
# [submodule "git-submodule-b"]
#   path = git-submodule-b
#   url = git@github.com:xpdojo/git-submodule-b.git
```

submodule도 gitdir이 존재하고 별도로 커밋 히스토리를 관리할 수 있다.

```sh
cd git-submodule-b
```

```sh
cat .git
# gitdir: ../.git/modules/git-submodule-b
cat ../.git/modules/git-submodule-b/HEAD
# 5e9cfdf2703509521aad3e4098719861263441f3
```

```sh
git log --oneline
# 5e9cfdf (HEAD, origin/main, origin/HEAD, main) Initial commit
```

다시 루트 프로젝트로 돌아가 해당 모듈을 포함한 채로 commit 하고 push한다.

```sh
cd ..
```

```sh
git commit -m "add submodule"
git push
```

### submodule이 포함된 repository를 clone

```sh
cd ..
rm -rf git-submodule-a
```

repository를 clone할 때 `--recurse-submodules` 옵션을 사용하면
submodule도 함께 clone된다.

```sh
git clone git@github.com:xpdojo/git-submodule-a.git --recurse-submodules
# Cloning into 'git-submodule-a'...
# ...
# Submodule 'git-submodule-b' (git@github.com:xpdojo/git-submodule-b.git) registered for path 'git-submodule-b'
# ...
# Submodule path 'git-submodule-b': checked out '5e9cfdf2703509521aad3e4098719861263441f3'
```

clone을 먼저 하고 submodule을 추가하는 경우 `--init` 옵션을 사용한다.

```sh
git clone git@github.com:xpdojo/git-submodule-a.git
```

```sh
cd git-submodule-a
git submodule update --init --recursive
# Submodule path './': checked out '5e9cfdf2703509521aad3e4098719861263441f3'
```

### submodule 업데이트

submodule에 새로운 commit을 추가해보자.

```sh
cd git-submodule-b
```

```sh
echo -e "submodule" >> README.md
git add README.md
git commit -m "add commit"
git push origin HEAD:main
```

새로운 commit을 push까지 했다면 루트 프로젝트를 지우고 다시 clone 해보자.

```sh
cd ../..
rm -rf git-submodule-a
```

결과를 보면 submodule의 commit이 업데이트되지 않았다.

```sh
git clone git@github.com:xpdojo/git-submodule-a.git --recurse-submodules
# Submodule path 'git-submodule-b': checked out '5e9cfdf2703509521aad3e4098719861263441f3'
```

submodule을 의존한 프로젝트를 만들다가
만약 submodule의 최신 히스토리를 가져와야 할 경우 `update` 명령어를 사용하고 remote에도 반영해야 한다.

```sh
# git submodule update --remote <submodule_name>
# git submodule update --remote git-submodule-b
git submodule update --remote --recursive
# Submodule path 'git-submodule-b': checked out 'f1accfbfda51591e0c23945912efb481cce810f9'
```

remote에 반영해야 clone 시 최신 히스토리를 가져올 수 있다.

```sh
git status
# modified:   git-submodule-b (new commits)
git add -A
git commit -m "update submodule"
git push
```

참고로 여러 submodule에 동일한 명령어를 수행할 때 `foreach` 명령어를 사용한다.

```sh
git submodule foreach git pull origin main
```

## 참조

- [Git - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) - Git Book
  - [Git 도구 - 서브모듈](https://git-scm.com/book/ko/v2/Git-%EB%8F%84%EA%B5%AC-%EC%84%9C%EB%B8%8C%EB%AA%A8%EB%93%88) - Git Book
- [Git submodules](https://www.atlassian.com/git/tutorials/git-submodule) - Atlassian
