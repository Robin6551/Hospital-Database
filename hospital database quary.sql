
CREATE TABLE Treatments(
  treatment_id varchar PRIMARY Key,
  appointment_id varchar,
  treatment_type varchar,
  description varchar,
  cost float,
  treatment_date Date
  FOREIGN KEY (cu_id)
        REFERENCES customers(customer_id)
)

CREATE TABLE patients(
		patient_id VARCHAR PRIMARY KEY,
		first_name VARCHAR,
		last_name VARCHAR,
		gender VARCHAR,
		date_of_birth DATE,
		contact_number INT,
		address VARCHAR,
		registration_date DATE,
		insurance_provider VARCHAR,
		insurance_number VARCHAR,
		email VARCHAR

)

CREATE TABLE doctors(
		doctor_id VARCHAR PRIMARY KEY,
		first_name VARCHAR,
		last_name VARCHAR,
		specialization VARCHAR,
		phone_number INT,
		years_experience INT,
		hospital_branch	email VARCHAR

)

CREATE TABLE billing(
		bill_id VARCHAR,
		patient_id VARCHAR,
		treatment_id VARCHAR,
		bill_date DATE,
		amount FLOAT,
		payment_method VARCHAR,
		payment_status VARCHAR

);

CREATE TABLE appoinments(
		appointment_id VARCHAR PRIMARY KEY,
		patient_id VARCHAR,
		doctor_id VARCHAR,
		appointment_date DATE,
		appointment_time TIME,
		reason_for_visit VARCHAR
		status VARCHAR

)

SELECT *
FROM appointments;

SELECT *
FROM billing;

SELECT *
FROM doctors;

SELECT *
FROM patients;

SELECT *
FROM treatments;

--Find the total number of appointments per doctor.

SELECT d.doctor_id,
		d.first_name,
		d.last_name,
		count(a.appointment_id) as total_appointments
FROM appointments a LEFT JOIN doctors d
ON a.doctor_id = d.doctor_id
GROUP BY 1,2,3;


--List all treatments with patient name and doctor name.

SELECT t.treatment_id,
		d.first_name as doctor_first_name,
		d.last_name AS doctor_last_name,
		p.first_name as patients_first_name,
		p.last_name as patients_last_name
from treatments t LEFT JOIN appointments a
ON a.appointment_id = t.appointment_id LEFT JOIN doctors d
ON d.doctor_id = a.doctor_id LEFT JOIN patients p
ON p.patient_id = a.patient_id;


--Find total treatment cost per patient.

SELECT t.treatment_id,
		p.first_name as patients_first_name,
		p.last_name as patients_last_name,
		sum(t.cost) as total_cost
FROM appointments a LEFT JOIN treatments t
ON a.appointment_id = t.appointment_id LEFT JOIN patients p
ON p.patient_id = a.patient_id
GROUP BY 1,2,3;


--Find the average treatment cost by treatment type.

SELECT treatment_type,
		sum(cost) as treatment_cost
from treatments
GROUP BY 1;

--Count the number of appointments per hospital branch.

SELECT d.hospital_branch, 
	count(a.appointment_id) as total_appointments
from doctors d LEFT JOIN appointments a
ON a.doctor_id = d.doctor_id
GROUP BY 1

--List doctors who have more than 10 appointments.

SELECT d.doctor_id,
		d.first_name,
		d.last_name,
		count(a.appointment_id) as total_appointments
from doctors d LEFT JOIN appointments a
ON a.doctor_id = d.doctor_id
GROUP BY 1,2,3
HAVING count(a.appointment_id) > 10

--Find the most expensive treatment.

SELECT treatment_type,
		sum(cost) as treatment_cost
from treatments
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--Rank doctors by number of appointments.

SELECT d.doctor_id,
		d.first_name,
		d.last_name,
		count(a.appointment_id) as total_appointments,
		Rank() over(order by count(a.appointment_id) DESC) as rnk
from doctors d Left join appointments a
ON d.doctor_id = a.doctor_id
GROUP BY 1,2,3;



--Find patients whose total billing amount exceeds 1000.

SELECT p.patient_id,
		p.first_name,
		p.last_name,
		sum(b.amount) as total_billing_amount
from billing b LEFT JOIN patients p
ON p.patient_id = b.patient_id
GROUP BY 1,2,3
ORDER BY 4 Desc;

--Find the top 3 patients by total billing amount.

SELECT p.patient_id,
		p.first_name,
		p.last_name,
		sum(b.amount) as total_billing_amount
from billing b LEFT JOIN patients p
ON p.patient_id = b.patient_id
GROUP BY 1,2,3
ORDER BY 4 Desc
LIMIT 3


--Find patients with unpaid or pending bills

SELECT p.patient_id,
		p.first_name,
		p.last_name,
		b.amount,
		b.payment_status
from patients p Left JOIN billing b
ON b.patient_id = p.patient_id
WHERE b.payment_status = 'Pending' or b.payment_status = 'Failed';







