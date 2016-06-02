SELECT 
  CLIENT.clientid,
  full_name,
  listed_company,
  city, 
  state,
  country,
  phone,
  CLIENT.email,
  people.name as sales_person,
  avg_invoice
FROM CLIENT
INNER JOIN (
	SELECT PACKAGES.clientid, avg_invoice
    FROM PACKAGES
    INNER JOIN (
      SELECT INVOICES.clientid, AVG(amount) avg_invoice FROM INVOICES
      WHERE 
        paid = 1 AND
        amount > 0
      GROUP BY INVOICES.clientid
	  HAVING AVG(amount) > 0
    ) paid_invoices
    ON paid_invoices.clientid = PACKAGES.clientid
	WHERE 
	  active != 1 AND
	  period != 0 AND
	  plan_id != 19 AND
	  PACKAGES.clientid NOT IN (
		SELECT clientid FROM ubersmith.PACKAGES
        WHERE 
          active = 1 AND
          period != 0 AND
          plan_id != 19
	  )
	GROUP BY PACKAGES.clientid
) subquery
ON subquery.clientid = CLIENT.clientid
LEFT OUTER JOIN people
ON CLIENT.salesperson = people.id
ORDER BY avg_invoice DESC
INTO OUTFILE '/tmp/cancelled_clients.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
