# Wingredient
Project for COMP4920 - Management and Ethics.

## Project Structure
The *wingredient* directory is our main Python package. This is strucured like a very basic Flask app for now.

## Developing
### Setting up
1. Make sure you have Python 3.7 installed. On Debian/Ubuntu, you'll need the `python3.7-venv` package as well. If you're on an Ubuntu version lower than 18.04, add the [deadsnakes apt repository](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa).
2. Create a Python virtual environment
    - simply run the `make newenv` command.
3. Activate the virtual environment - **do this first when developing/testing/running/tooling** (you'll see `(.venv)` on your console prompt if you're activated)
    - from the project root directory, run `source .venv/bin/activate` on Mac/Linux or `.\.venv\Scripts\activate` on Windows.
4. Set up your editor/IDE if you're using one, so that it uses your virtual environment. In VS Code and PyCharm (and possibly other editors), this means you don't have to activate your virtual environment all the time, as long as you use the integrated terminal.
    - Visual Studio Code: In workspace settings, set the `python.pythonPath` setting to `${workspaceFolder}/.venv/bin/python` on Mac/Linux or `${workspaceFolder}/.venv/Scripts/python.exe` on Windows.
    - PyCharm: Go to *File* -> *Settings* -> *Project* -> *Project Interpreter*, add a Python interpreter, select *Existing environment*, and set the path to the python executable as above, in the VS Code instructions, where `${workspaceFolder}` is the project root directory.
    - Other editors: Probably a similar process to above, you simply need to tell the editor where to find the Python interpreter executable for this project.

### Running the Web App

#### Setting up the database
Make sure your user account has privileges on the database you're connecting to.

On Linux (replace <username> with your Linux username):
```bash
$ sudo -u postgres psql
postgres=# DROP DATABASE IF EXISTS wingredient;
postgres=# CREATE DATABASE wingredient;
postgres=# CREATE USER <username>;
postgres=# GRANT ALL PRIVILEGES ON DATABASE wingredient TO <username>;
```

Now, set up the config file. Whilst in the project root directory:
```bash
$ cp config_template.yml wingredient.yml
```
Then, edit `wingredient.yml` to change to the correct configuration. All you should need to do is uncomment the `dbname: wingredient` line.

Now, populate the database with the command:
```bash
$ wingredient-initdb
```

#### Running the app

If the command isn't found, run `make syncenv` again.

Provided that you set up as described above, can simply run the web app with the `wingredient` command, in an activated terminal. At the moment it just runs on localhost:5000, but this will probably change at some point.
