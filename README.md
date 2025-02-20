
# CONTACT LIST API

This is an API I built as a challenge. It is a message app that allows users to send and retrieve messages with attachments.

## Models


### User

- ```User``` model has an ```id```, a ```username``` and a  ```password``` timestamp.
- An ```username``` has to be unique and needs to exist.
- A ```password``` needs to have at least 6 characters and it needs to exist.
- Every password is filtered through a ```has_secure_password``` method that we encrypt using the ```bcrypt``` gem.

### Message

- ```Message``` has an ```id```, a ```sender```,  a ```receiver```, a ```content``` and ```files```.
- The ```sender``` and the ```receiver``` are ```Users``` identified by their respective ```id```..
- ```content``` must exists unless there is ```files``` attached.
- ```files``` are attached using Active Storage.

## Routes

### ```POST /signup```

- Signup an ```User```. The JWT ```token``` received will be the one that you gonna use in your headers
- If ```username``` already exists you will receive a 401 (Unauthorized) response


**Request:**
```bash
curl --location 'http://localhost:3000/signup' \
--header 'Content-Type: application/json' \
--data '{"username": "abc", "password": "password123"}'
```

**200 Response:**
```json
{
    "user": {
        "id": 6,
        "username": "abc",
        "created_at": "2025-02-20T17:14:22.249Z",
        "updated_at": "2025-02-20T17:14:22.249Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2fQ.zhMw6Tb7Y5CKp0CL--R4tCx_fU3eFQJYNdYb7Om1X2Q"
}
```

### ```POST /login```

- Login an already existing user.
- If ```username``` and password are wrong you will receive a 401 Unauthorized response.

**Request:**
```bash
curl --location 'http://localhost:3000/login' \
--header 'Content-Type: application/json' \
--data '{"username": "abc", "password": "password123"}'
```

**200 Response:**
```json
{
    "user": {
        "id": 6,
        "username": "abc",
        "created_at": "2025-02-20T03:13:58.752Z",
        "updated_at": "2025-02-20T03:13:58.752Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2fQ.zhMw6Tb7Y5CKp0CL--R4tCx_fU3eFQJYNdYb7Om1X2Q"
}
```

### ```GET /messages/{user_id}```

- Get ```Messages``` from an specific ```User```.
- It sends the ```token``` as a header, in case you send wrong token you will receive a 401 Unauthorized response.

**Request:**
```bash
curl --location 'http://localhost:3000/messages/6' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2fQ.zhMw6Tb7Y5CKp0CL--R4tCx_fU3eFQJYNdYb7Om1X2Q'
```

**Response:**
```json
{
    "messages": [
        {
            "id": 2,
            "sender_id": 6,
            "receiver_id": 5,
            "content": "Hello, check this file!",
            "files": [
                "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--015898750c93c772b5953458c5646f11af32c68f/pexels-kai-pilger-1341279.jpg",
                "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MiwicHVyIjoiYmxvYl9pZCJ9fQ==--60d106de9de86077e5792eb4c0e4217a3e4fe505/texto_pqec2224.pdf"
            ],
            "created_at": "2025-02-20T17:14:44.934Z"
        }
    ],
    "pagination": {
        "page": 1,
        "prev": null,
        "next": null,
        "count": 1,
        "pages": 1
    }
}
```

### ```POST /messages```

- Send a  ```Message``` from a ```User``` to other ```User```, you can attach files.
- It sends the ```token``` as a header, in case you send wrong token you will receive a 401 Unauthorized response.

**Request:**
```bash
curl --location 'http://localhost:3000/messages' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2fQ.zhMw6Tb7Y5CKp0CL--R4tCx_fU3eFQJYNdYb7Om1X2Q' \
--form 'receiver_id="5"' \
--form 'content="Hello, check this file\!"' \
--form 'files[]=@"/path/to/file1.jpg"' \
--form 'files[]=@"/Users/gabrielguerra/Desktop/ILLUSTRATOR/Capas/texturas/pexels-kai-pilger-1341279.jpg"' \
--form 'files[]=@"/Users/gabrielguerra/Desktop/ILLUSTRATOR/40%/CD - TEXTOS A4/texto_pqec2224.pdf"'
```

**Response:**

```json
{
    "id": 2,
    "sender_id": 6,
    "receiver_id": 5,
    "content": "Hello, check this file!",
    "files": [
        "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--015898750c93c772b5953458c5646f11af32c68f/pexels-kai-pilger-1341279.jpg",
        "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MiwicHVyIjoiYmxvYl9pZCJ9fQ==--60d106de9de86077e5792eb4c0e4217a3e4fe505/texto_pqec2224.pdf"
    ],
    "created_at": "2025-02-20T17:14:44.934Z"
}
```

### ```GET /metrics```

- Get metrics from the app
- It sends the ```token``` as a header, in case you send wrong token you will receive a 401 Unauthorized response.


**Request:**
```bash
curl --location 'http://localhost:3000/metrics' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2fQ.zhMw6Tb7Y5CKp0CL--R4tCx_fU3eFQJYNdYb7Om1X2Q'
```

**Response:**
```json
{
    "total_messages": 1,
    "active_users": 2
}
```


## Sidekiq

- This API uses  **Sidekiq** to triggers it's message.

## Versions :gem:
* **Ruby:** 3.3.1
* **Rails:** 7.1.3

## Setup :monorail:
1. Run `bundle install`.
2. Set up `config/database.yml`.
3. Run `rails db:drop db:create db:migrate db:seed`.
4. Run `rails s`.

## Docker :whale:

<p>This is a 100% dockerized application!</p>

#### Install Docker for Mac
<ul>
    <li>Install Docker Desktop: https://docs.docker.com/desktop/install/mac-install </li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Uninstall docker engine: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine</li>
    <li>Install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository</li>
    <li>Config docker as a non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user</li>
    <li>Config docker to start on boot: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot</li>
</ul>

#### Install Docker for Linux
<ul>
    <li>Do you use Windows? I'm sorry, docker doesn't work well on Windows. </li>
</ul>

#### Docker steps reminders

- Start terminal
- Make sure of permissions of your OS and terminal system are on point. (Don't be afraid to change the shebang in case you need)
- If you're not installing for the first time, don't overwrite archives
- If you're installing a new gem, be always sure to rebuild.
- This application use a series of shell scripts in order to simplify docker and rails commands, they're all written inside the devops folder.


### Build, up the container and start Sidekiq


```bash
  sh devops/chmod.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
```

### Start the DB

```bash
    ./devops/rails/restart.sh
```

### Run Rails console

```bash
    ./devops/rails/console.sh
```

### Update DB and Rails

```bash
    ./devops/rails/update.sh
```

### Uninstall

```bash
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
```

## DB reminders

- If you're having trouble when opening on a DB management system (like Beekeeper, DBeaver, PG Admin, etc.), don't forget that you need to run the container and use localhost as your host. 
- If any role issues appear Don't be afraid to pkill postgres and brew services stop postgresql (If you're running in homebrew).
- If you are having trouble with users accessing the DB, rebuild the container.

<h2>That's it. Happy coding :computer:</h2> 