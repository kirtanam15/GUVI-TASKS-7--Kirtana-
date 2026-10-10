-- =====================================================
-- GUVI TASK 7: IMDB DATABASE
-- Purpose: Create a movie database with related tables.
-- =====================================================

-- Create the database if it does not already exist.
CREATE DATABASE IF NOT EXISTS IMDB;

-- Select the IMDB database for all upcoming operations.
USE IMDB;
-- =====================================================
-- TABLE 1: MOVIES
-- Stores the basic information about each movie.
-- =====================================================

CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    release_year YEAR,
    language VARCHAR(50),
    duration_minutes INT
);


-- =====================================================
-- TABLE 2: MEDIA
-- Stores videos or images associated with movies.
-- One movie can have multiple media records.
-- =====================================================

CREATE TABLE Media (
    media_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    media_type ENUM('Video', 'Image') NOT NULL,
    media_url VARCHAR(255) NOT NULL,

    -- Foreign key links media to its movie.
    FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id)
        ON DELETE CASCADE
);


-- =====================================================
-- TABLE 3: GENRES
-- Stores the different movie genres.
-- =====================================================

CREATE TABLE Genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);


-- =====================================================
-- TABLE 4: MOVIE_GENRES
-- Junction table for the many-to-many relationship.
-- One movie can have many genres, and one genre can
-- belong to many movies.
-- =====================================================

CREATE TABLE Movie_Genres (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,

    -- Composite primary key prevents duplicate pairs.
    PRIMARY KEY (movie_id, genre_id),

    FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id)
        ON DELETE CASCADE,

    FOREIGN KEY (genre_id)
        REFERENCES Genres(genre_id)
        ON DELETE CASCADE
);


-- =====================================================
-- TABLE 5: USERS
-- Stores users who can submit movie reviews.
-- =====================================================

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE
);


-- =====================================================
-- TABLE 6: REVIEWS
-- Stores reviews written by users for movies.
-- Each movie can have multiple reviews.
-- Each review belongs to one user and one movie.
-- =====================================================

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    user_id INT NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    review_text TEXT,
    review_date DATE NOT NULL,

    -- Ensure ratings are between 0 and 10.
    CHECK (rating >= 0 AND rating <= 10),

    FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    -- A user can submit only one review per movie.
    UNIQUE (movie_id, user_id)
);


-- =====================================================
-- TABLE 7: ARTISTS
-- Stores actors, directors and other film artists.
-- =====================================================

CREATE TABLE Artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL,
    date_of_birth DATE
);


-- =====================================================
-- TABLE 8: SKILLS
-- Stores skills such as acting, dancing and singing.
-- =====================================================

CREATE TABLE Skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(50) NOT NULL UNIQUE
);


-- =====================================================
-- TABLE 9: ARTIST_SKILLS
-- Junction table for artists and their multiple skills.
-- An artist can have multiple skills, and a skill can
-- belong to multiple artists.
-- =====================================================

CREATE TABLE Artist_Skills (
    artist_id INT NOT NULL,
    skill_id INT NOT NULL,

    PRIMARY KEY (artist_id, skill_id),

    FOREIGN KEY (artist_id)
        REFERENCES Artists(artist_id)
        ON DELETE CASCADE,

    FOREIGN KEY (skill_id)
        REFERENCES Skills(skill_id)
        ON DELETE CASCADE
);


-- =====================================================
-- TABLE 10: ROLES
-- Stores roles an artist can perform in a film.
-- Examples: Actor, Director, Producer and Singer.
-- =====================================================

CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);


-- =====================================================
-- TABLE 11: MOVIE_ARTIST_ROLES
-- Junction table connecting movies, artists and roles.
-- One artist can perform multiple roles in one movie.
-- One movie can have many artists and roles.
-- =====================================================

CREATE TABLE Movie_Artist_Roles (
    movie_id INT NOT NULL,
    artist_id INT NOT NULL,
    role_id INT NOT NULL,

    -- Allows different roles for the same artist and movie.
    PRIMARY KEY (movie_id, artist_id, role_id),

    FOREIGN KEY (movie_id)
        REFERENCES Movies(movie_id)
        ON DELETE CASCADE,

    FOREIGN KEY (artist_id)
        REFERENCES Artists(artist_id)
        ON DELETE CASCADE,

    FOREIGN KEY (role_id)
        REFERENCES Roles(role_id)
        ON DELETE CASCADE
);

-- =====================================================
-- INSERT SAMPLE MOVIES
-- =====================================================

INSERT INTO Movies (title, release_year, language, duration_minutes)
VALUES
('The Adventure', 2024, 'English', 120),
('Love Story', 2023, 'Hindi', 135),
('Space Journey', 2025, 'English', 150);


-- =====================================================
-- INSERT MEDIA FOR MOVIES
-- Demonstrates multiple media for one movie.
-- =====================================================

INSERT INTO Media (movie_id, media_type, media_url)
VALUES
(1, 'Image', 'https://example.com/adventure-poster.jpg'),
(1, 'Video', 'https://example.com/adventure-trailer.mp4'),
(1, 'Image', 'https://example.com/adventure-scene.jpg'),
(2, 'Image', 'https://example.com/love-poster.jpg'),
(3, 'Video', 'https://example.com/space-trailer.mp4');


-- =====================================================
-- INSERT GENRES
-- =====================================================

INSERT INTO Genres (genre_name)
VALUES
('Action'),
('Adventure'),
('Romance'),
('Science Fiction'),
('Drama');


-- =====================================================
-- ASSIGN MULTIPLE GENRES TO MOVIES
-- =====================================================

INSERT INTO Movie_Genres (movie_id, genre_id)
VALUES
(1, 1),  -- The Adventure: Action
(1, 2),  -- The Adventure: Adventure
(1, 5),  -- The Adventure: Drama
(2, 3),  -- Love Story: Romance
(2, 5),  -- Love Story: Drama
(3, 2),  -- Space Journey: Adventure
(3, 4);  -- Space Journey: Science Fiction


-- =====================================================
-- INSERT USERS
-- =====================================================

INSERT INTO Users (username, email)
VALUES
('kirtana', 'kirtana@example.com'),
('rahul', 'rahul@example.com'),
('priya', 'priya@example.com');


-- =====================================================
-- INSERT MOVIE REVIEWS
-- Multiple users can review the same movie.
-- =====================================================

INSERT INTO Reviews
(movie_id, user_id, rating, review_text, review_date)
VALUES
(1, 1, 8.5, 'Excellent adventure movie.', '2026-10-01'),
(1, 2, 9.0, 'Great story and visuals.', '2026-10-02'),
(2, 1, 7.5, 'A good romantic movie.', '2026-10-03'),
(2, 3, 8.0, 'Enjoyed the performances.', '2026-10-04'),
(3, 2, 9.5, 'Amazing science fiction movie.', '2026-10-05');


-- =====================================================
-- INSERT ARTISTS
-- =====================================================

INSERT INTO Artists (artist_name, date_of_birth)
VALUES
('Arjun Kumar', '1990-05-15'),
('Meera Sharma', '1995-08-20'),
('Rahul Dev', '1988-12-10');


-- =====================================================
-- INSERT SKILLS
-- =====================================================

INSERT INTO Skills (skill_name)
VALUES
('Acting'),
('Dancing'),
('Singing'),
('Directing'),
('Writing');


-- =====================================================
-- ASSIGN MULTIPLE SKILLS TO ARTISTS
-- =====================================================

INSERT INTO Artist_Skills (artist_id, skill_id)
VALUES
(1, 1),  -- Arjun Kumar: Acting
(1, 2),  -- Arjun Kumar: Dancing
(1, 3),  -- Arjun Kumar: Singing
(2, 1),  -- Meera Sharma: Acting
(2, 3),  -- Meera Sharma: Singing
(3, 1),  -- Rahul Dev: Acting
(3, 4),  -- Rahul Dev: Directing
(3, 5);  -- Rahul Dev: Writing


-- =====================================================
-- INSERT FILM ROLES
-- =====================================================

INSERT INTO Roles (role_name)
VALUES
('Actor'),
('Director'),
('Producer'),
('Singer');


-- =====================================================
-- ASSIGN ARTISTS MULTIPLE ROLES IN MOVIES
-- The same artist can have different roles in one film.
-- =====================================================

INSERT INTO Movie_Artist_Roles (movie_id, artist_id, role_id)
VALUES
(1, 1, 1),  -- Arjun Kumar: Actor in The Adventure
(1, 1, 4),  -- Arjun Kumar: Singer in The Adventure
(1, 3, 1),  -- Rahul Dev: Actor in The Adventure
(1, 3, 2),  -- Rahul Dev: Director in The Adventure
(2, 2, 1),  -- Meera Sharma: Actor in Love Story
(2, 3, 2),  -- Rahul Dev: Director in Love Story
(3, 1, 1),  -- Arjun Kumar: Actor in Space Journey
(3, 3, 3);  -- Rahul Dev: Producer in Space Journey

-- Display the currently selected database.
SELECT DATABASE();

-- List all tables in the IMDB database.
SHOW TABLES;

-- Check the structure of the Movies table.
DESCRIBE Movies;

-- Display all movie records.
SELECT * FROM Movies;

-- Display all media records.
SELECT * FROM Media;

-- Display all genres.
SELECT * FROM Genres;

-- Display all reviews.
SELECT * FROM Reviews;

-- Display all artists.
SELECT * FROM Artists;


-- Display each movie and its associated media.
SELECT
    m.title,
    md.media_type,
    md.media_url
FROM Movies AS m
INNER JOIN Media AS md
    ON m.movie_id = md.movie_id
ORDER BY m.movie_id;

-- Display each movie with all its assigned genres.
SELECT
    m.title,
    g.genre_name
FROM Movies AS m
INNER JOIN Movie_Genres AS mg
    ON m.movie_id = mg.movie_id
INNER JOIN Genres AS g
    ON mg.genre_id = g.genre_id
ORDER BY m.movie_id, g.genre_name;


-- Display movie reviews along with the reviewer's username.
SELECT
    m.title,
    u.username,
    r.rating,
    r.review_text,
    r.review_date
FROM Reviews AS r
INNER JOIN Movies AS m
    ON r.movie_id = m.movie_id
INNER JOIN Users AS u
    ON r.user_id = u.user_id
ORDER BY m.movie_id, r.review_id;

-- Display each artist and all their skills.
SELECT
    a.artist_name,
    s.skill_name
FROM Artists AS a
INNER JOIN Artist_Skills AS ast
    ON a.artist_id = ast.artist_id
INNER JOIN Skills AS s
    ON ast.skill_id = s.skill_id
ORDER BY a.artist_id, s.skill_name;



-- Display each movie, artist and role performed.
SELECT
    m.title,
    a.artist_name,
    r.role_name
FROM Movie_Artist_Roles AS mar
INNER JOIN Movies AS m
    ON mar.movie_id = m.movie_id
INNER JOIN Artists AS a
    ON mar.artist_id = a.artist_id
INNER JOIN Roles AS r
    ON mar.role_id = r.role_id
ORDER BY m.movie_id, a.artist_id, r.role_id;

