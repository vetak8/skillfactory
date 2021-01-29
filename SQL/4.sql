Задание 4.1
База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:

SELECT d.city,
       count(DISTINCT d.airport_code)
FROM dst_project.airports d
GROUP BY 1
HAVING count(DISTINCT d.airport_code)>1

Задание 4.2
Вопрос 1. Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?

SELECT 	count(DISTINCT f.status)
FROM 	dst_project.flights f

Вопрос 2. Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»).

SELECT 	count(DISTINCT f.flight_id)
FROM 	dst_project.flights f
WHERE 	f.status='Departed'
	
Вопрос 3. Места определяют схему салона каждой модели. Сколько мест имеет самолет модели  (Boeing 777-300)?

SELECT count(DISTINCT s.seat_no)
FROM dst_project.seats s
WHERE s.aircraft_code='773'

Вопрос 4. Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?

FROM dst_project.flights f
WHERE f.status = 'Arrived'
  AND f.actual_arrival::DATE BETWEEN to_date('2017-04-01', 'YYYY-MM-DD') AND to_date('2017-09-01', 'YYYY-MM-DD')
  
  
Задание 4.3  

Вопрос 1. Сколько всего рейсов было отменено по данным базы?
SELECT count(*)
FROM dst_project.flights f
WHERE f.status='Cancelled'

Вопрос 2. Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?

WITH bords AS
  (SELECT 'Boeing' AS model,
          '773' AS code
   UNION SELECT 'Boeing' AS model,
                '763' AS code
   UNION SELECT 'Boeing' AS model,
                '733' AS code
   UNION SELECT 'Sukhoi Superjet' AS model,
                'SU9' AS code
   UNION SELECT 'Airbus' AS model,
                '320' AS code
   UNION SELECT 'Airbus' AS model,
                '321' AS code
   UNION SELECT 'Airbus' AS model,
                '319' AS code)
SELECT b.model,
       count(DISTINCT a.model)
FROM dst_project.aircrafts a
JOIN bords b ON a.aircraft_code = b.code
GROUP BY 1

Вопрос 4. У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id).

SELECT f.flight_id,
       f.actual_arrival-f.scheduled_arrival
FROM dst_project.flights f
WHERE f.actual_arrival IS NOT NULL
  ORDER  BY 2 DESC
  
Задание 4.4

Вопрос 1. Когда был запланирован самый первый вылет, сохраненный в базе данных?
SELECT f.scheduled_departure
FROM dst_project.flights f
order by 1 asc
limit 1
Вопрос 2. Сколько минут составляет запланированное время полета в самом длительном рейсе?

SELECT f.flight_id,
       f.actual_arrival-f.actual_departure,
       f.scheduled_duration
FROM dst_project.flights_v f
WHERE f.actual_arrival IS NOT NULL
  ORDER  BY 2 DESC
  
Вопрос 3. Между какими аэропортами пролегает самый длительный по времени запланированный рейс?

SELECT f.flight_id,
       f.scheduled_arrival-f.scheduled_departure,
       f.departure_airport,
       f.arrival_airport
FROM dst_project.flights_v f
WHERE f.actual_arrival IS NOT NULL
  ORDER  BY 2 DESC
LIMIT 1