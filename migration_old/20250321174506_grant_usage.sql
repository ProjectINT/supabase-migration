GRANT USAGE ON SCHEMA group1_schema TO postgres;
GRANT SELECT ON ALL TABLES IN SCHEMA group1_schema TO postgres;

ALTER DEFAULT PRIVILEGES IN SCHEMA group1_schema 
GRANT SELECT ON TABLES TO postgres;