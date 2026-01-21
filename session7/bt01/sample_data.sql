CREATE TABLE IF NOT EXISTS book (
    book_id    SERIAL PRIMARY KEY,
    title      VARCHAR(255),
    author     VARCHAR(100),
    genre      VARCHAR(50),
    price      DECIMAL(10,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============
-- Seed sample data
-- ==============
TRUNCATE TABLE book RESTART IDENTITY;
DO $$
DECLARE
    n INT := 200000;
BEGIN
    INSERT INTO book (title, author, genre, price, description, created_at)
    SELECT
        'Book ' || g,
        CASE
            WHEN g % 5000 = 0 THEN 'J.K. Rowling'
            WHEN g % 7000 = 0 THEN 'Rowling, Joanne'
            ELSE 'Author ' || substring(md5(g::text), 1, 8)
        END,
        (ARRAY['Fantasy','Sci-Fi','Romance','History','Business','Kids'])
            [1 + (random()*5)::int],
        ROUND((random()*500)::numeric, 2),
        'Description ' || md5(random()::text),
        NOW() - ((random()*3650)::int || ' days')::interval
    FROM generate_series(1, n) g;
END $$;

ANALYZE;
