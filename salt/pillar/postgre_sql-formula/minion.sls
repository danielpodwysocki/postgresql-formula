postgres:
  listen_addresses: '*'

#### Define databases with a dedicated role(user) with full access to them ####
postgres_databases:
#example:
  - db_name:
    username: user
    password: password
    name: db_name

postgres_allowed_remote:
#example:
  - db_name:
    role: user
    name: db_name
    allowed_range: 0.0.0.0/0
    challenge: md5
       

postgres_allowed_local:
#example:
  - db_name:
    role: user
    name: db_name
    challenge: md5
       
