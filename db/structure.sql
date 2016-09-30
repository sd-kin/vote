--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE status AS ENUM (
    'draft',
    'ready',
    'published',
    'closed',
    'deleted'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: downvotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE downvotes (
    id integer NOT NULL,
    rating_id integer,
    rater_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: downvotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE downvotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: downvotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE downvotes_id_seq OWNED BY downvotes.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id integer NOT NULL,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    poll_id integer,
    row_order integer
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE options_id_seq OWNED BY options.id;


--
-- Name: polls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE polls (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status status DEFAULT 'draft'::status,
    vote_results text,
    current_state character varying,
    user_id integer,
    max_voters integer DEFAULT 100
);


--
-- Name: polls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE polls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: polls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE polls_id_seq OWNED BY polls.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    value integer DEFAULT 0,
    rateable_id integer,
    rateable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: upvotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE upvotes (
    id integer NOT NULL,
    rating_id integer,
    rater_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: upvotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upvotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upvotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upvotes_id_seq OWNED BY upvotes.id;


--
-- Name: user_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_votes (
    id integer NOT NULL,
    user_id integer,
    poll_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_votes_id_seq OWNED BY user_votes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying,
    activation_digest character varying,
    activated boolean DEFAULT false,
    activated_at timestamp without time zone,
    reset_digest character varying,
    reset_sent_at timestamp without time zone,
    anonimous boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY downvotes ALTER COLUMN id SET DEFAULT nextval('downvotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY options ALTER COLUMN id SET DEFAULT nextval('options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY polls ALTER COLUMN id SET DEFAULT nextval('polls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upvotes ALTER COLUMN id SET DEFAULT nextval('upvotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_votes ALTER COLUMN id SET DEFAULT nextval('user_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: downvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY downvotes
    ADD CONSTRAINT downvotes_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: polls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: upvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upvotes
    ADD CONSTRAINT upvotes_pkey PRIMARY KEY (id);


--
-- Name: user_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_votes
    ADD CONSTRAINT user_votes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_polls_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_polls_on_user_id ON polls USING btree (user_id);


--
-- Name: index_ratings_on_rateable_type_and_rateable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_rateable_type_and_rateable_id ON ratings USING btree (rateable_type, rateable_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_16e77efa22; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT fk_rails_16e77efa22 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151225233435');

INSERT INTO schema_migrations (version) VALUES ('20151227204113');

INSERT INTO schema_migrations (version) VALUES ('20151227213610');

INSERT INTO schema_migrations (version) VALUES ('20160531140023');

INSERT INTO schema_migrations (version) VALUES ('20160603184925');

INSERT INTO schema_migrations (version) VALUES ('20160605115357');

INSERT INTO schema_migrations (version) VALUES ('20160605155750');

INSERT INTO schema_migrations (version) VALUES ('20160709145804');

INSERT INTO schema_migrations (version) VALUES ('20160714233816');

INSERT INTO schema_migrations (version) VALUES ('20160715025202');

INSERT INTO schema_migrations (version) VALUES ('20160726110000');

INSERT INTO schema_migrations (version) VALUES ('20160801154134');

INSERT INTO schema_migrations (version) VALUES ('20160805205610');

INSERT INTO schema_migrations (version) VALUES ('20160818012805');

INSERT INTO schema_migrations (version) VALUES ('20160818061937');

INSERT INTO schema_migrations (version) VALUES ('20160918090302');

INSERT INTO schema_migrations (version) VALUES ('20160921101715');

INSERT INTO schema_migrations (version) VALUES ('20160921101732');

INSERT INTO schema_migrations (version) VALUES ('20160930151136');

INSERT INTO schema_migrations (version) VALUES ('20160930163031');

