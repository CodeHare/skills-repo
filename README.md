# Skills Repo

个人的 CodeBuddy Skills 仓库，用于统一管理和版本控制所有 Skill。

## 目录结构

```
skills-repo/
├── skills/             # Skill 源文件（可被 CodeBuddy 直接加载）
│   └── skill-name/
│       └── SKILL.md
├── scripts/            # 管理工具脚本
│   └── sync.ps1        # Windows 同步脚本（创建符号链接）
└── README.md
```

## 使用方式

### 1. Clone 仓库

```bash
git clone https://github.com/CodeHare/skills-repo.git
```

### 2. 同步到 CodeBuddy

**Windows（以管理员身份运行 PowerShell）:**
```powershell
.\scripts\sync.ps1
```

这会在 `~/.codebuddy/skills/` 下创建符号链接，指向本仓库的 `skills/` 目录下的每个 Skill。

### 3. 添加新 Skill

```bash
# 直接创建 Skill 目录和 SKILL.md
mkdir skills/my-new-skill
# 编写 SKILL.md ...

git add skills/my-new-skill
git commit -m "Add my-new-skill"
git push
```

### 4. 更新 Skill

```bash
git pull
.\scripts\sync.ps1
```
