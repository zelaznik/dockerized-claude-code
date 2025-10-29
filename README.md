# Dockerized Claude Code

We're all a little bit weary about giving LLM agents access to our entire system.  This setup is designed to limit the blaste radius if something goes wrong.  This is set up so that claude code runs inside docker and only has access to the folder of this repo and the directory (and any subdirectories) from which you run `claude`.  The claude rules and histories will be saved inside the directory of THIS repository.

# Technical Setup

- Make sure you have docker installed on your machine
- If claude code is on your host machine, uninstall it (or fork this repo so you can use both native claude code and dockerized claude code separately)
- Download this repository anywhere you want
- Run `docker compose build`
- add the `scripts` subdirectory to your $PATH
- navigate to the directory containg your project
- Run `claude`
