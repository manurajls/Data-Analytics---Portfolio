/*7. Write a query to display carton id, (len*width*height) as carton_vol and identify the
optimum carton (carton with the least volume whose volume is greater than the total
volume of all items (len * width * height * product_quantity)) for a given order whose order
id is 10006, Assume all items of an order are packed into one single carton (box). (1 ROW)
[NOTE: CARTON TABLE]*/

SELECT CRT.CARTON_ID, min(CRT.CARTON_VOL) AS OPTIMUM_VOL FROM(SELECT CARTON_ID, (LEN*WIDTH*HEIGHT) AS CARTON_VOL FROM CARTON) CRT
WHERE CRT.CARTON_VOL > (SELECT SUM(o.PRODUCT_QUANTITY*p.LEN*p.WIDTH*p.HEIGHT)
FROM ORDER_ITEMS o INNER JOIN PRODUCT p ON o.PRODUCT_ID = p.PRODUCT_ID
WHERE o.ORDER_ID = 10006);

/*8. Write a query to display details (customer id,customer fullname,order id,product
quantity) of customers who bought more than ten (i.e. total order qty) products per shipped
order.*/
SELECT C.CUSTOMER_ID, CONCAT(C.CUSTOMER_FNAME,' ',C.CUSTOMER_LNAME), I.ORDER_ID, SUM(I.PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM ORDER_ITEMS I 
INNER JOIN ORDER_HEADER O ON I.ORDER_ID = O.ORDER_ID
INNER JOIN ONLINE_CUSTOMER C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.ORDER_STATUS = 'Shipped'
group by ORDER_ID having (SUM(PRODUCT_QUANTITY)) > 10;

/* 9. Write a query to display the order_id, customer id and cutomer full name of customers
along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6
ROWS)*/

SELECT I.ORDER_ID, C.CUSTOMER_ID, CONCAT(C.CUSTOMER_FNAME,' ',C.CUSTOMER_LNAME), SUM(I.PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM ORDER_ITEMS I 
INNER JOIN ORDER_HEADER O ON I.ORDER_ID = O.ORDER_ID
INNER JOIN ONLINE_CUSTOMER C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.ORDER_STATUS = 'Shipped'
group by ORDER_ID having ORDER_ID > 10060;

/*10. Write a query to display product class description ,total quantity
(sum(product_quantity),Total value (product_quantity * product price) and show which class
of products have been shipped highest(Quantity) to countries outside India other than USA?
Also show the total value of those items.*/

SELECT PC.PRODUCT_CLASS_DESC, SUM(I.PRODUCT_QUANTITY) AS TOTAL_QTY,SUM(I.PRODUCT_QUANTITY)*P.PRODUCT_PRICE AS TOTAL_VALUE
FROM ORDER_HEADER O LEFT JOIN ONLINE_CUSTOMER C ON C.CUSTOMER_ID = O.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS I ON	I.ORDER_ID = O.ORDER_ID
LEFT JOIN PRODUCT P ON P.PRODUCT_ID =I.PRODUCT_ID
LEFT JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
LEFT JOIN ADDRESS A ON A.ADDRESS_ID = C.ADDRESS_ID
WHERE A.COUNTRY NOT IN ('INDIA', 'USA') AND O.ORDER_STATUS = 'Shipped'
GROUP BY PC.PRODUCT_CLASS_DESC
ORDER BY TOTAL_QTY DESC LIMIT 1;
