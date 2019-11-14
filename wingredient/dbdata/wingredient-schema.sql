-- method is an array of text outlining the steps of the recipe
-- imageRef holds a file path to an image
DROP TYPE IF EXISTS MeasurementTypes CASCADE;
-- Vo
CREATE TYPE MeasurementTypes as ENUM('Weight', 'Volume', 'Count', 'Tablespoon', 'Teaspoon', 'Cup');

DROP TYPE IF EXISTS Difficulty CASCADE;
CREATE TYPE Difficulty as ENUM('Easy', 'Intermediate', 'Hard');

-- Enum for different dietary traits
--DROP TYPE IF EXISTS DietaryTraits CASCADE;
-- should this be a list not an ENUM  or you can have multiple?
--CREATE TYPE DietaryTraits as ENUM('None', 'Vegan', 'Vegetarian', 'Caeliac');

-- Dietary bits
--0000 = none
--0001 = vegetarian
--0011 = vegan
--0100 = gluten
--1000 = dairy

-- cook time stored in minutes
DROP TABLE IF EXISTS Recipe CASCADE;
CREATE TABLE Recipe (
    id          integer,
    name        varchar(256) not null,
    time        integer,
    difficulty  Difficulty,
    serving     integer,
    notes       text,
    description text,
    cuisine_tags text,
    dietary_tags bit(4),
    imageRef    text default null,
    url         text,
    method      text,
    primary key (id)
);

-- Priority is the importance of the ingredient for cooking
DROP TABLE IF EXISTS Ingredient CASCADE;
CREATE TABLE Ingredient (
    id          integer,
    name        varchar(256),
    primary key (id)
);

DROP TABLE IF EXISTS RecipeToIngredient;
CREATE TABLE RecipeToIngredient (
    recipe              integer references Recipe(id),
    ingredient          integer references Ingredient(id),
    quantity            numeric,
    measurement_type    MeasurementTypes,
    description         text,
    notes               text,
    optional            boolean,
    primary key         (recipe, ingredient, quantity)
);

DROP TABLE IF EXISTS Equipment CASCADE;
CREATE TABLE Equipment (
    id          integer,
    name        varchar(256),
    primary key (id)
);

-- relationship between recipe and equipment
DROP TABLE IF EXISTS RecipeToEquipment;
CREATE Table RecipeToEquipment (
    recipe      integer references Recipe(id),
    equipment   integer references Equipment(id)
);

DROP TABLE IF EXISTS Account CASCADE;
CREATE TABLE Account (
    username    varchar(32),
    pwhash      bytea,
    pwsalt      bytea,
    details     text,
    primary key (username)
);

DROP TABLE IF EXISTS ShoppingList;
CREATE TABLE ShoppingList (
    account     varchar(32) references Account(username),
    ingredient  integer references Ingredient(id),
    quantity    integer,
    primary key (account, ingredient)
);

DROP TABLE IF EXISTS Pantry;
CREATE TABLE Pantry (
    account     varchar(32) references Account(username),
    ingredient  integer references Ingredient(id),
    quantity    integer,
    primary key (account, ingredient)
);

DROP TABLE IF EXISTS Favourites;
CREATE TABLE Favourites (
    account     varchar(32) references Account(username),
    recipe      integer references Recipe(id),
    primary key (account, recipe)
);

DROP TABLE IF EXISTS Recipe_Votes CASCADE;
CREATE TABLE Recipe_Votes (
    account     varchar(32) references Account(username),
    recipe      integer references Recipe(id),
    vote      integer CHECK (vote = 0 OR vote = 1),
    primary key (account, recipe)
);

-- modifications made to the database to assist with SQL queries
CREATE OR REPLACE VIEW compulsory_recipetoingredient as
select *
from recipetoingredient
where optional = 'false'
;


CREATE OR REPLACE VIEW ingredient_counts as
select
  recipe,
  count(recipe) AS compulsory_ingredient_count
from compulsory_recipetoingredient
group by recipe
;

CREATE OR REPLACE VIEW recipe_rating AS
SELECT
  r.id AS recipe,
  sum(rv.vote)::float / count(r.id)::float AS rating
FROM Recipe r
    LEFT JOIN Recipe_Votes rv ON r.id = rv.recipe
GROUP BY r.id
ORDER BY rating DESC
;
