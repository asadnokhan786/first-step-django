## Create Virtual Environment
- This is where you install all the libraries and packages your project will use and is an environment specific to each application
- `python3 -m venv venv`
- `source venv/bin/activate` to enter your virtual environment

## Setting Up Django
### Installation
- `python -m pip install Django`
- `pip install --upgrade django-stubs` # so that zed's language server won't complain
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
## Creating Django URL Endpoint
### Creating the App Subview (if needed)
- `python manage.py startapp <app-name>`
- `touch <app-name>/urls.py`
### Creating the View
- create a function of any name
- have it taken in a request parameter
- return HttpResponse is returning a http response format based on what you're passing in
- You can pass a string to django's http response, django will automatically encode it correctly
```
from django.http import HttpResponse


def index(request):
    return HttpResponse("PONG".encode())
```
