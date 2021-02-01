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

Вопрос 4. Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).

SELECT date_part('hour', avg(f.scheduled_arrival - f.scheduled_departure)) * 60 + date_part('minute', avg(f.scheduled_arrival - f.scheduled_departure))
FROM dst_project.flights_v f

Задание 4.5
Вопрос 1. Мест какого класса у SU9 больше всего?
SELECT foo.most_pop
FROM
  (SELECT s.fare_conditions most_pop,
          count(s.fare_conditions) most_pop_count
   FROM dst_project.seats s
   WHERE s.aircraft_code = 'SU9'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 1) foo
   
Вопрос 2. Какую самую минимальную стоимость составило бронирование за всю историю?

SELECT min(b.total_amount)
FROM dst_project.bookings b

Вопрос 3. Какой номер места был у пассажира с id = 4313 788533?

SELECT b.seat_no
FROM dst_project.boarding_passes b
JOIN dst_project.tickets t ON b.ticket_no=t.ticket_no
WHERE t.passenger_id='4313 788533'

Задание 5.1

Вопрос 1. Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?

  SELECT foo.flies
FROM
  (SELECT f.arrival_city,
          date_part('year', f.actual_arrival) fly_year,
          count(*) flies
   FROM dst_project.flights_v f
   GROUP BY 1,
            2
   HAVING f.arrival_city='Анапа'
   AND date_part('year', f.actual_arrival)='2017') foo
 
Вопрос 2. Сколько рейсов из Анапы вылетело зимой 2017 года?

SELECT foo.flies
FROM
  (SELECT f.departure_city,
          date_part('year', f.actual_departure) fly_year,
          count(*) flies
    FROM dst_project.flights_v f
   WHERE f.departure_city='Анапа'
     AND date_part('year', f.actual_departure)='2017'
     AND date_part('month', f.actual_departure) NOT BETWEEN 3 AND 11
   GROUP BY 1,2
   ) foo
          date_part('year', f.actual_departure) fly_year,
          count(*) flies
   FROM dst_project.flights_v f
   WHERE f.departure_city='Анапа'
     AND date_part('year', f.actual_departure)='2017'
     AND date_part('month', f.actual_departure) NOT BETWEEN 3 AND 11
   GROUP BY 1,
            2) foo
 
Вопрос 3. Посчитайте количество отмененных рейсов из Анапы за все время.

  SELECT foo.flies
FROM
  (SELECT f.departure_city,
          count(*) flies
    FROM dst_project.flights_v f
   WHERE f.departure_city='Анапа'
        and f.status='Cancelled'
   GROUP BY 1
   ) foo
 
Вопрос 4. Сколько рейсов из Анапы не летают в Москву?
SELECT foo.flies
FROM
  (SELECT f.departure_city,
          count(*) flies
    FROM dst_project.flights_v f
   WHERE f.departure_city='Анапа'
        and f.arrival_city!='Москва'
        
   GROUP BY 1
   ) foo
 
Вопрос 5. Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?

SELECT foo.model
FROM
  (SELECT a.model model,
          count(s.seat_no)
   FROM dst_project.flights_v f
   LEFT JOIN dst_project.aircrafts a ON f.aircraft_code=a.aircraft_code
   LEFT  JOIN dst_project.seats s ON f.aircraft_code=s.aircraft_code
   WHERE f.departure_city='Анапа'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 1) foo