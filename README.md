# dc-magnetic-data-calculator

# Git Instructions

## Definitions
- **Repository (repo):** a project folder tracked by Git (can be local on your computer or remote on GitHub/GitLab).  
- **Commit:** a snapshot of your changes with a message describing what was done.  
- **Push:** upload your local commits to the remote repository.  
- **Pull:** download and merge the latest changes from the remote repository to your local copy.  
- **Staging (git add):** selecting which files/changes will go into the next commit.  

---

# Git Instructions
# How to push local changes to repository?
## 1. add files to commit
```bash
git add --all
```

## 2. create commit with added files (staged files)
```bash
git commit -m 'what was changed? what is the new feature name?'
```

## 3. push changes (push commit)
```bash
git push
```

# How to pull changes (commits) from repository to local workstation?
```bash
git pull
```

# Git Branches
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

### 5. Delete local branch
```
git branch --delete <BRANCH_NAME>
```

# How to see flags documentation
>  Use arrows to go up / down if using vim, press "q" to exit, or search in google `git push manual` or `git pull documentation`
```
git push --help
git pull --help
git --help
```

# Dictionaries
## 1. Standard `dict` functions
> These are useful function for working with dictionaries. They are **especially useful** when working with `for each` loops:
 - `.keys()`, `.values()`, `.items()`
 - `.get()`
```python
mydict: dict = {
  'some_key': 'some value',
  'another_key': 0.1,
  'yet_another_key': ['yet', 'another', 'value'],
  }
```

## 1.1 **Most common loop** - iterate over every `key, value` using `.items()`
> [!IMPORTANT]
> Must know
```python
for key, value in mydict.items():
  print(f'key: "{key}" -> value: "{value}"')
```
- Log Output:
```
key: "some_key" -> value: "some value"
key: "another_key" -> value: "0.1"
key: "yet_another_key" -> value: "['yet', 'another', 'value']"
```

## 1.2 Check if `key` exists in a `dict`
> [!IMPORTANT]
> Must know, below examples evaluate the same
```python
if 'some_key' in mydict.keys(): # EXPLICIT call
  print('key exists')

if 'some_key' in mydict:        # IMPLICIT call - "hidden default call"
  print('key exists')
```

## 1.3 Setting defaults: `.get()`
> [!IMPORTANT]
> Must know
```python
x = mydict.get('i_dont_exist', 'default value')
y = mydict.get('some_key', 'default value')
print(f'x is: "{x}", y is: "{y}"')
```
- Log Output:
```
x is: "default value", y is: "some value"
```
### 1.3.1 `.get()` use case
> [!IMPORTANT]
> Must know, below examples evaluate the same
```python
if symbol in ox_state_data.keys():  # not optimal
  sum_dia_contr += ox_state_data[symbol] * atoms

sum_dia_contr += ox_state_data.get(symbol, 0) * atoms # optimal
```

## 1.4 Loop over keys using `.keys()`
> [!NOTE]  
> Useful to know
```python
for key in mydict.keys():
    value = mydict[key] # you still can get the value
    print(f'key: "{key}" -> value: "{value}"')
```
- Log Output:
```
key: "some_key" -> value: "some value"
key: "another_key" -> value: "0.1"
key: "yet_another_key" -> value: "['yet', 'another', 'value']"
```

## 1.5 Loop over values using `.values()`
> [!NOTE]  
> Rarely used. Only when `key` is not needed
```python
for value in mydict.values():
    print(f'value: "{value}"')
```
- Log Output:
```
value: "some value"
value: "0.1"
value: "['yet', 'another', 'value']"
```
