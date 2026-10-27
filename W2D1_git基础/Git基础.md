# 第 2 周 Day 1 教材：Git 基础（分支与远程仓库）

> 你已经会 `git init`、`git add`、`git commit`、`git status`、`git log`、`.gitignore`。今天不重复这些，只补两块：**分支**和**远程仓库**。这是从“本地存档”走向“多人协作”的关键一步。

---

## 一、今日必学（必须亲手做）

### ✅ 必学 1：理解分支是什么

**一句话**：分支是一条独立的开发线。你在分支上改代码，不影响 `main`。

**类比**：`main` 是正式版，分支是“草稿纸”。在草稿纸上随便改，满意了再合并回正式版。

**为什么需要**：

- 加新功能时，不破坏能跑的 `main`。
- 多人同时开发，各自在自己的分支上，互不干扰。
- 出问题可以随时切回 `main`，草稿纸扔掉即可。

**必须知道**：

- 新建仓库默认分支叫 `main`（老版本叫 `master`）。
- 同一时间你只在一个分支上，`HEAD` 指向它。
- 切换分支会改变工作区文件内容。

---

### ✅ 必学 2：创建、切换、查看分支

**查看分支**：

```powershell
git branch
```

`*` 表示当前分支。

**创建并切换**（最常用）：

```powershell
git switch -c feature-1
```

- `-c`：create，创建新分支并立即切换。
- 等价于老写法 `git checkout -b feature-1`。

**只创建不切换**：

```powershell
git branch feature-1
```

**切换已有分支**：

```powershell
git switch master
git switch feature-1
```

**只想知道当前分支名**：

```powershell
git branch --show-current
git status
```

**必须知道**：

- 推荐用 `git switch`，不用 `git checkout`。`switch` 只切分支，语义清晰，不容易误操作。
- 切换前最好 `git status` 确认工作区干净，否则可能带过去未提交的改动。

**练习**：

1. 在 `todo` 项目里 `git switch -c feature-mark`。
2. `git branch` 确认带 `*` 的是 `feature-mark`。
3. 改点代码，`git add .`、`git commit`。
4. `git switch main`，确认文件回到改动前。
5. `git switch feature-mark`，确认改动又回来了。

---

### ✅ 必学 3：合并分支

**场景**：在 `feature-mark` 上开发完，想把改动合并回 `main`。

**步骤**：

```powershell
git switch main          # 先回到目标分支
git merge feature-mark   # 把 feature-mark 合并进来
```

**必须知道**：

- **先切到“接收方”分支，再 `merge`“来源”分支。**
- 合并成功后，`main` 上会多一个提交（或快进，见下）。
- 合并完，`feature-mark` 还在，可以删也可以留。

**两种合并方式**：

| 方式 | 条件 | 结果 |
|------|------|------|
| **快进合并**（fast-forward） | `main` 在分叉后没新提交 | `main` 直接指向 `feature-mark` 的最新提交，不产生新提交 |
| **三方合并**（3-way merge） | `main` 和 `feature-mark` 都有新提交 | 产生一个新的“合并提交” |

新手不用刻意区分，`git merge` 会自动选。

**练习**：

1. 在 `feature-mark` 上提交一次。
2. `git switch main`。
3. `git merge feature-mark`。
4. `git log --oneline --graph` 看合并结果。

---

### ✅ 必学 4：解决冲突（最重要）

**冲突怎么产生**：两个分支改了**同一文件的同一行**，Git 不知道保留哪个。

**模拟冲突**：

1. 在 `main` 上改 `main.py` 第 1 行，提交。
2. `git switch -c conflict-test`，改同一行，提交。
3. `git switch main`，`git merge conflict-test`。
##测试
会看到：

```text
Auto-merging main.py
CONFLICT (content): Merge conflict in main.py
Automatic merge failed; fix conflicts and then commit the result.
```

**打开 `main.py`**，会看到：

```python
<<<<<<< HEAD
main 分支的内容
=======
conflict-test 分支的内容
>>>>>>> conflict-test
```

**解决步骤**：

1. 手动编辑，删掉 `<<<<<<<`、`=======`、`>>>>>>>` 这三行标记。
2. 保留你想要的内容（可以只留一方，也可以合并两方）。
3. 保存文件。
4. `git add main.py`（告诉 Git 冲突已解决）。
5. `git commit`（不用 `-m`，Git 会生成默认合并提交说明）。

**必须知道**：

- 冲突不是错误，是 Git 在“问你保留哪个”。
- **必须手动编辑**，Git 不会替你做决定。
- 解决后要 `git add`，否则 Git 认为还没解决。
- 想放弃合并，回到合并前：`git merge --abort`。

**练习**：按上面步骤故意制造一次冲突，完整解决一遍。这是今天最重要的练习。

---

### ✅ 必学 5：远程仓库：`remote`、`push`、`pull`、`clone`

**本地仓库和远程仓库的关系**：

```text
本地仓库  ── push ──▶  远程仓库（GitHub）
本地仓库  ◀── pull ──  远程仓库
```

**关联远程仓库**（第一次）：

```powershell
git remote add origin https://github.com/你的用户名/仓库名.git
```

- `origin` 是远程仓库的默认别名，可以改成别的，但习惯用 `origin`。
- 查看已关联的远程：

  ```powershell
  git remote -v
  ```

**推送**（本地 → 远程）：

```powershell
git push -u origin main
```

- `-u`：把本地 `main` 和远程 `origin/main` 关联，以后直接 `git push` 即可。
- 第一次推送要 `-u`，之后不用。

**拉取**（远程 → 本地）：

```powershell
git pull
```

等价于 `git fetch` + `git merge`。把远程的新提交拉下来并合并到当前分支。

**克隆**（完整复制远程仓库到本地）：

```powershell
git clone https://github.com/你的用户名/仓库名.git
```

**必须知道**：

- `push` 推的是**提交**，不是文件。先 `commit` 才能 `push`。
- `pull` 前最好 `git status` 确认工作区干净，否则可能冲突。
- 第一次 `push` 可能要求登录，按浏览器提示授权即可。

**练习**：

1. 在 GitHub 创建空仓库（不勾选 README）。
2. 本地 `git remote add origin ...`。
3. `git push -u origin main`。
4. 在 GitHub 网页上确认代码已上传。
5. 换个文件夹 `git clone` 下来，确认内容一致。

---

### ✅ 必学 6：查看分支和提交历史

**分支列表**：

```powershell
git branch          # 本地分支
git branch -a       # 本地 + 远程
```

**图形化历史**（排查“我在哪”最有用）：

```powershell
git log --oneline --graph --all
```

输出示例：

```text
* a1b2c3d (feature-1) 添加标记完成功能
* f4e5d6c (HEAD -> main) 初始化项目
```

- `HEAD -> main`：当前在 `main`。
- `(feature-1)`：这个提交是 `feature-1` 的最新提交。
- `*`：提交节点。

**必须知道**：记不清分支名或提交记录时，这三个命令够用：

```powershell
git branch
git branch -a
git log --oneline --graph --all
```

---

## 二、了解即可（看一遍，不练）

| 内容 | 知道什么就行 |
|------|-------------|
| `git branch -d 分支名` | 删除已合并的分支；`-D` 强制删除未合并的 |
| `git fetch` | 只拉取远程更新，不自动合并；`git pull` = `fetch` + `merge` |
| `git remote -v` | 查看远程仓库地址 |
| `git push origin 分支名` | 推送指定分支到远程 |
| `git pull --rebase` | 拉取时用 rebase 代替 merge，历史更线性，新手先不用 |
| 快进合并 vs 三方合并 | 知道有这两种，`git merge` 自动选，不用手动控制 |
| `git merge --abort` | 合并冲突时放弃合并，回到合并前 |
| `git switch -` | 切回上一个分支 |

---

## 三、交给 AI（知道去哪问就行）

| 场景 | 直接问 AI |
|------|-----------|
| 冲突解决卡住 | “合并时这个文件冲突了，两边内容分别是……我该保留哪个？帮我分析。” |
| SSH Key 配置 | “Windows 上怎么给 GitHub 配置 SSH Key？步骤和验证方法。” |
| 误推了敏感文件 | “我不小心把 `.env` push 到 GitHub 了，怎么彻底移除？” |
| 分支策略 | “个人小项目需要开分支吗？什么时候该开？” |
| rebase vs merge | “什么时候用 rebase，什么时候用 merge？给一个初学者能懂的例子。” |
| 回退远程提交 | “已经 push 的提交怎么撤销？会影响别人吗？” |
| GitHub 认证失败 | “push 时提示 authentication failed，怎么排查？” |

**原则**：AI 给的命令，先看懂再执行。涉及 `--hard`、`push --force`、`reset` 这类会丢数据的操作，**执行前一定确认**。

---

## 四、最小完成标准

今天做到以下 5 条就算完成：

1. [ ] 用 `git switch -c` 创建分支，改代码，提交，切回 `main` 确认改动不在。
2. [ ] 把分支合并回 `main`，`git log --graph` 能看到合并结果。
3. [ ] **故意制造一次冲突，完整解决一遍**（编辑、`git add`、`git commit`）。
4. [ ] 在 GitHub 建仓库，`git remote add`、`git push -u origin main` 成功。
5. [ ] 在另一个文件夹 `git clone` 下来，确认代码一致。

**其他全部可以先不碰。** 删除分支、`fetch`、`rebase` 等，用到再学或交给 AI。

---

## 五、给 AI 的提问模板

```text
目标：解决 Git 合并冲突。
环境：Windows 11，PowerShell，Git 2.4x。
操作：git switch main 后 git merge feature-mark
错误信息：
CONFLICT (content): Merge conflict in main.py
冲突文件内容：
<<<<<<< HEAD
print("main 版本")
=======
print("feature 版本")
>>>>>>> feature-mark

问题：
1. 这段标记怎么读？
2. 我想保留 feature 版本，具体怎么操作？
3. 解决后为什么要 git add？
期望输出：分步骤说明，不要只给命令。
```

---

## 六、常见错误

| 错误 | 原因 | 解决 |
|------|------|------|
| `error: Your local changes would be overwritten by merge` | 工作区有未提交改动，切分支或合并会覆盖 | 先 `commit` 或 `git stash` |
| `CONFLICT` 后不知道怎么继续 | 没编辑冲突文件就 `commit` | 编辑文件 → `git add` → `git commit` |
| `push` 被拒绝 `rejected` | 远程有你本地没有的提交 | 先 `git pull`，解决冲突后再 `push` |
| `remote origin already exists` | 已经关联过远程 | `git remote set-url origin 新地址` 或先 `git remote remove origin` |
| `fatal: not a git repository` | 当前目录不是 Git 仓库 | `cd` 到项目目录，或 `git init` |
| 切换分支后文件“变了” | 分支的工作区内容不同 | 正常现象，切回去就恢复 |
| 合并后想撤销 | 合错了 | `git reset --hard HEAD~1`（**危险**，确认后再用） |

---

## 七、今天要掌握的重点

- 分支是什么，为什么需要。
- `git switch -c` 创建并切换，`git switch` 切换，`git branch` 查看。
- `git merge` 合并，知道“先切到接收方再合并”。
- **冲突的完整解决流程**：编辑 → `git add` → `git commit`。
- `git remote add`、`git push -u`、`git pull`、`git clone`。
- `git log --oneline --graph --all` 看分支结构。
- 知道 `git fetch` 和 `git pull` 的区别。

---

## 八、提交到 Git

今天的练习会在 `todo` 项目里产生多个分支。结束后：

```powershell
git switch main
git status
git add .
git commit -m "Day 1 第二周 Git 分支与远程仓库练习"
git push
```

确认 GitHub 上能看到最新提交。

---

## 九、一句话

今天只学两件事：**分支**（创建、切换、合并、解决冲突）和**远程仓库**（`remote`、`push`、`pull`、`clone`）。其中**解决冲突**是必练项，其他知道流程即可。删除分支、`fetch`、`rebase` 等，用到再查或交给 AI。