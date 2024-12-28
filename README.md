# docker

This project is source control and local CI/CD for my Docker stack(s).

## CI/CD flow
- This repository associated to this project is stored locally in Gitea (mirrored to GitHub)
- When a PR is merged/rebased into the master branch, the Gitea instance will
execute a post-receive git hook that sends a POST request `api/DockerDeployment` to the local API server.
- This endpoint will execute a git pull of this repository on the Docker host to pull down the new changes,
followed by executing the `restart_stacks.sh` script.
