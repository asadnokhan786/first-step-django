## Create Virtual Environment
- This is where you install all the libraries and packages your project will use and is an environment specific to each application
- `python3 -m venv venv`
- `source venv/bin/activate` to enter your virtual environment

## Setting Up Django
### Installation
- `python -m pip install Django`
- 
### Creating Django App
- `django-admin startproject <app-name> <parent-folder>`
- 
## Configuring Github Hooks To Run Scripts for Every Commit
### Creating the Hook
- `mkdir githooks` # to make the githooks folder github should refference
- `touch githooks/pre-commit` #in this case to run when you make a commit
### Connecting to the Hook
- `git config core.hooksPath githooks`
- `chmod +x ./githooks/pre-commit`
