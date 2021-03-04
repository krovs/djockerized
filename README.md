# Dockerizing a Django project (Postgres + Gunicorn + Nginx)

## How to use this

### Development

Everything default but Postgres

1. Update all the environment variables in the *env.* and *docker-compose.yml* files.
2. Build the images and run the containers:

    ```sh
    $ docker-compose up --build
    ```

    The dev server will be available on [http://localhost:8000](http://localhost:8000)

#### Remake the project

You can remake the Django project inside ./app once the docker container is running.
This script will regenerate a new project, clean and rebuild the container.

1. (Optional) Update *./app/requirementes.txt* versions.
2. Execute:  

    ```sh
    $ chmod +x remake_project.sh
    $ sudo ./remake_project.sh <project_name>
    ```

### Production

Postgres + gunicorn + nginx.

1. Update all the environment variables in the *env.* files.
1. Build the images and run the containers:

    ```sh
    $ docker-compose -f docker-compose.prod.yml up --build
    ```

    The production server will be available on [http://localhost:1337](http://localhost:1337).  
    There is no bind mounts here, only volumes, so for any changes in the code to take effect, the container must be rebuilt.
