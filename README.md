# dc-magnetic-data-calculator

## Git Instructions

### Definitions
- **Repository (repo):** a project folder tracked by Git (can be local on your computer or remote on GitHub/GitLab).  
- **Commit:** a snapshot of your changes with a message describing what was done.  
- **Push:** upload your local commits to the remote repository.  
- **Pull:** download and merge the latest changes from the remote repository to your local copy.  
- **Staging (git add):** selecting which files/changes will go into the next commit.  

---

# Git Instructions
## How to push local changes to repository?
### 1. add files to commit
```bash
git add --all
```

### 2. create commit with added files (staged files)
```bash
git commit -m 'what was changed? what is the new feature name?'
```

### 3. push changes (push commit)
```bash
git push
```

## How to pull changes (commits) from repository to local workstation?
```bash
git pull
```

## Git Branches
### 1. check available branches
```
git branch
```
### 2. Change branch
```
git checkout <BRANCH_NAME>
```
### 3. Create new branch
```
git checkout -b <BRANCH_NAME>
```

### 4. Push branch **for the first time**
```
git push -u origin <BRANCH_NAME>
```

## How to see flags documentation
>  Use arrows to go up / down if using vim, press "q" to exit, or search in google `git push manual` or `git pull documentation`
```
git push --help
git pull --help
git --help
```