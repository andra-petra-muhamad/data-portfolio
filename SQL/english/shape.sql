/*
In mathematics, we can calculate the area of 2D shapes,
for example a triangle and a rectangle. 
We will create a stored procedure to calculate the area of a triangle and
a rectangle. This stored procedure will have 4 parameters:
a. shape_type (IN) (string), the type of shape to be calculated;
   for now, we will only calculate triangle and rectangle
b. x (IN) (float), if the shape is a triangle, x is the base; if a rectangle, x is the length
c. y (IN) (float), if the shape is a triangle, y is the height; if a rectangle, y is the width
d. area (OUT) (float), the calculated area of the shape
e. message (OUT) (string), information about whether the calculation succeeded
*/

/*
Creating Stored Procedure
We create a procedure named calculate_area with parameters:
- shape_type → type of 2D shape (triangle / rectangle / others)
- x, y → numbers (base/height or length/width)
- result → output area
- message → status of whether the calculation was successful
*/
DELIMITER $$
CREATE PROCEDURE calculate_area (
    IN shape_type VARCHAR (255),
    IN x FLOAT,
    IN y FLOAT,
    OUT result FLOAT,
    OUT message VARCHAR (255)
) BEGIN
    CASE
        WHEN shape_type = 'triangle' THEN 
            SET result = 0.5 * x * y, message = 'Calculation succeeded!';
        WHEN shape_type = 'rectangle' THEN 
            SET result = x * y, message = 'Calculation succeeded!';
        ELSE 
            SET result = NULL ; 
            SET message = 'Calculation failed. Shape not supported';
    END CASE;
END $$
DELIMITER ;

-- Calculating the area of a triangle
SET @shape_type = 'triangle'; -- or SET @shape_type = 'rectangle'
SET @x = 10 ; -- base if triangle, length if rectangle (FLOAT type)
SET @y = 20 ; -- height if triangle, width if rectangle (FLOAT type)

CALL calculate_area(@shape_type, @x, @y, @area, @message);
SELECT @shape_type, @x, @y, @area, @message;

-- Calculating the area of a rectangle
SET @shape_type = 'rectangle';
SET @x = 10 ; -- length (FLOAT type)
SET @y = 20 ; -- width (FLOAT type)

CALL calculate_area(@shape_type, @x, @y, @area, @message);
SELECT @shape_type, @x, @y, @area, @message;

-- Calculating the area of an unsupported shape (e.g., circle)
SET @shape_type = 'circle';
SET @x = 10 ; -- any float value
SET @y = 20 ; -- any float value

CALL calculate_area(@shape_type, @x, @y, @area, @message);
SELECT @shape_type, @x, @y, @area, @message;
