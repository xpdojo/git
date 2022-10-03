# subtree

- [subtree](#subtree)
  - [개념](#개념)
    - [subtree?](#subtree-1)
  - [실습](#실습)
    - [subtree 추가](#subtree-추가)
    - [subtree 업데이트](#subtree-업데이트)
    - [subtree push](#subtree-push)
  - [참조](#참조)

## 개념

하나의 저장소를 다른 저장소의 하위 디렉토리로 가져올 수 있다.

### subtree?

![Subtree](images/tree-subtree-concept.png)

[이미지 출처](https://opensource.com/article/20/5/git-submodules-subtrees)

## 실습

실습을 위해 2개의 repository가 필요하다.
명칭은 아무 상관없다.

- xpdojo/git-subtree-a
- xpdojo/git-subtree-b

### subtree 추가

1개의 repository를 subtree로 추가하고, subtree를 업데이트하는 방법을 알아보자.
우선 첫번째 repository를 생성하고 clone한다.

```sh
git clone git@github.com:xpdojo/git-subtree-a.git
```

```sh
cd git-subtree-a
```

subtree로 사용할 `remote`를 추가해야 한다.

```sh
# git remote add <remote_name> <remote_url>
git remote add git-subtree-b git@github.com:xpdojo/git-subtree-b.git
```

```sh
git remote -v
# git-subtree-b   git@github.com:xpdojo/git-subtree-b.git (fetch)
# git-subtree-b   git@github.com:xpdojo/git-subtree-b.git (push)
# origin  git@github.com:xpdojo/git-subtree-a.git (fetch)
# origin  git@github.com:xpdojo/git-subtree-a.git (push)
```

`remote`를 기준으로 `subtree`를 추가한다.

```sh
# git subtree add --prefix <subtree_dir_name> <remote_name> <remote_branch>
git subtree add --prefix subtree-b git-subtree-b main
# git fetch git-subtree-b main
# ...
# Added dir 'subtree-b'
```

sumodule과 달리 `subtree`는 `remote`의 모든 내용을 가져오며 메타데이터가 없다.

```sh
tree .
```

```sh
.
├── README.md
└── subtree-b
    └── README.md

1 directory, 2 files
```

메타데이터는 commit에 기록되어 있다.

```sh
git log
```

```sh
commit 24661efe0596b6dc6d6345d6a567d4c0ff288462 (HEAD -> main)
Merge: e526ad1 6fdfd24
Author: Changsu Im <imcxsu@gmail.com>
Date:   Tue Oct 4 04:29:15 2022 +0900

    Add 'subtree-b/' from commit '6fdfd2429f3a8e639f5d49169bdb7475b3e7a57d'

    git-subtree-dir: subtree-b
    git-subtree-mainline: e526ad13b0db44e458a9b30a6bd6d3c7070e724a
    git-subtree-split: 6fdfd2429f3a8e639f5d49169bdb7475b3e7a57d

commit 6fdfd2429f3a8e639f5d49169bdb7475b3e7a57d (git-subtree-b/main)
Author: markruler <imcxsu@gmail.com>
Date:   Tue Oct 4 00:06:22 2022 +0900

    Initial commit

commit e526ad13b0db44e458a9b30a6bd6d3c7070e724a (origin/main, origin/HEAD)
Author: markruler <imcxsu@gmail.com>
Date:   Tue Oct 4 00:05:00 2022 +0900

    Initial commit
```

### subtree 업데이트

`subtree`를 업데이트하려면 remote branch를 `fetch`하고 `merge`해야 한다.

```sh
git fetch git-subtree-b main
```

혹은 `pull`을 사용한다.

```sh
# git subtree pull --prefix <subtree_dir_name> <remote_name> <remote_branch>
git subtree pull --prefix subtree-b git-subtree-b main
```

```sh
git log
```

```sh
commit c380b56218de39bcb033235f094cf22bd27dba33 (HEAD -> main)
Merge: cfd14ac c13c9de
Author: Changsu Im <imcxsu@gmail.com>
Date:   Tue Oct 4 04:43:30 2022 +0900

    Merge commit 'c13c9de59551cbad294ea52710b9d7571953248d'

commit cfd14ac9a8f0135a7f172bb677fe1320f7a0608a
Author: Changsu Im <imcxsu@gmail.com>
Date:   Tue Oct 4 04:38:58 2022 +0900

    Update subtree-b

commit c13c9de59551cbad294ea52710b9d7571953248d (git-subtree-b/main)
Author: Changsu Im <imcxsu@gmail.com>
Date:   Tue Oct 4 04:38:58 2022 +0900

    Update subtree-b
```

git-subtree-b 저장소의 경우 별도로 commit 히스토리가 기록되지만,
루트 프로젝트에는 모두 기록된다.

```sh
git log git-subtree-b/main
```

```sh
commit c13c9de59551cbad294ea52710b9d7571953248d (git-subtree-b/main)
Author: Changsu Im <imcxsu@gmail.com>
Date:   Tue Oct 4 04:38:58 2022 +0900

    Update subtree-b
```

### subtree push

`subtree`를 `push`하려면 `subtree`의 `commit`을 `remote`의 `branch`로 `push`해야 한다.

```sh
echo -e "${date}" >> subtree-b/README.md
git add -A
git commit -m "Update subtree-b"
```

```sh
# git subtree push --prefix <subtree_dir_name> <remote_name> <remote_branch>
git subtree push --prefix subtree-b git-subtree-b main
```

## 참조

- 왜 submodule 대신 subtree를 사용해야 할까?
  - [Git subtree: the alternative to Git submodule](https://www.atlassian.com/git/tutorials/git-subtree) - Atlassian
  - [Why your company shouldn’t use Git submodules](https://codingkilledthecat.wordpress.com/2012/04/28/why-your-company-shouldnt-use-git-submodules/) - Amber
  - [Git subtree를 활용한 코드 공유](https://blog.rhostem.com/posts/2020-01-03-code-sharing-with-git-subtree) - rhostem
