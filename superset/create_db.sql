CREATE ROLE superset WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'xxxxxx';

CREATE DATABASE superset
    WITH 
    OWNER = superset
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;