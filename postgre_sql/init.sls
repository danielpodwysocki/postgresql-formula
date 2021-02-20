Add postgres repo:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main
    - file: /etc/apt/sources.list.d/postgres.list
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc

Install postgres:
  pkg.installed:
    - pkgs:
      - postgresql-12
      - postgresql-client-12

#not used atm
/mnt/db/postgresql:
  file.directory:
    - user: postgres
    - group: postgres
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - makedirs: True


#TODO: implement pillars for the below:

#create databases
   
#create database roles
#set permissions for the roles
/etc/postgresql/12/main/pg_hba.conf: #todo: this also needs to be configured from pillars 
  file.managed:
    - user: postgres
    - group: postgres
    - mode: 0644
    - source: salt://{{ sls }}/jinja/pg_hba.conf    
    - template: jinja

/etc/postgresql/12/main/postgresql.conf:
  file.managed:
    - user: postgres
    - group: postgres
    - mode: 0744
    - source: salt://{{ sls }}/jinja/postgresql.conf
    - template: jinja

postgresql:
  service.running:
    - listen:
      - file: /etc/postgresql/12/main/postgresql.conf
      - file: /etc/postgresql/12/main/pg_hba.conf

{% for db in pillar.get('postgres_databases') %}

{{ db.get('name') }}:
  postgres_database.present


{{ db.get('username') }}:
  postgres_user.present:
    - password: {{ db.get('password') }}
  
  postgres_privileges.present:
    - object_name: {{ db.get('name') }} 
    - object_type: database
    - privileges:
      - ALL

{% endfor %}
