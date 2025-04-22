Use CarRentalService

Create table Vehicle 
(
vehicleID int primary key, 
make varchar(50), 
model varchar(50), 
year int,  
dailyrate decimal(10, 2), 
status int check (status in (0,1)),  
passengercapacity int, 
enginecapacity int
)

Create table Customer 
(
customerID int primary key, 
firstname varchar(50), 
lastname varchar(50),  
email varchar(100), 
phonenumber varchar(15) unique
)

Create table Lease 
(
leaseID int primary key, 
vehicleID int, 
customerID int,  
startdate date, 
enddate date, 
type varchar(20) check (type in ('Daily', 'Monthly')),
foreign key (vehicleID) references Vehicle(vehicleID) on delete cascade on update cascade,  
foreign key (customerID) references Customer(customerID) on delete cascade on update cascade
)

Create table Payment 
(
paymentID int primary key, 
leaseID int, 
paymentdate date, 
amount decimal(10, 2),  
foreign key (leaseID) references Lease(leaseID) on delete cascade on update cascade
)

Insert into Vehicle 
values
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500)

Insert into Customer 
values
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321')

Insert into Lease
values
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly')

Insert into Payment 
values
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00)

--1. Update the daily rate for a Mercedes car to 68.
Update Vehicle set dailyrate = 68.00
where make = 'Mercedes'

--2. Delete a specific customer and all associated leases and payments.
Delete from Customer
where customerID = 3

--3. Rename the "paymentDate" column in the Payment table to "transactionDate".
Exec sp_rename 'Payment.paymentdate','transactiondate','column'

Select * from Payment

--4. Find a specific customer by email.
Select * from Customer
where email = 'david@example.com'

--5. Get active leases for a specific customer.
Select * from Lease
where customerID = 4 and enddate >= getdate()

--6. Find all payments made by a customer with a specific phone number.
Select paymentID,amount, Customer.firstname, Customer.lastname from Payment 
inner join Lease on Lease.leaseID = Payment.leaseID
inner join Customer on Customer.customerID = Lease.customerID
where Customer.phonenumber = '555-765-4321'

--7. Calculate the average daily rate of all available cars.
Select avg(dailyrate) as AvgDailyRate from Vehicle

--8. Find the car with the highest daily rate.
Select top 1 vehicleID,make,model,dailyrate
from Vehicle
order by dailyrate desc

--9. Retrieve all cars leased by a specific customer.
Select Lease.vehicleID, Vehicle.make, Lease.customerID, Customer.firstname, Customer.lastname
from Lease
inner join Vehicle on Vehicle.vehicleID = Lease.vehicleID
inner join Customer on Customer.customerID = Lease.customerID
where Customer.customerID = 7

--10. Find the details of the most recent lease.
Select top 1 * from Lease
order by startdate desc

--11. List all payments made in the year 2023.Select * from payment where transactiondate like '2023%'--12. Retrieve customers who have not made any payments.Select Customer.customerID,firstname,lastname,email from Customerleft join Lease on Lease.customerID = Customer.customerIDleft join Payment on Payment.leaseID = Lease.leaseIDwhere Payment.paymentID is null--13. Retrieve Car Details and Their Total Payments.Select Vehicle.vehicleID,make,model,year,dailyrate,status,passengercapacity,enginecapacity,sum(Payment.amount) as TotalPaymentfrom Vehicleleft join Lease on Lease.vehicleID = Vehicle.vehicleIDleft join Payment on Payment.leaseID = Lease.leaseIDgroup by Vehicle.vehicleID,make,model,year,dailyrate,status,passengercapacity,enginecapacity--14. Calculate Total Payments for Each Customer.Select Customer.customerID,firstname,lastname, sum(Payment.amount) as TotalPaymentfrom Customerleft join Lease on Lease.customerID = Customer.customerIDleft join Payment on Payment.leaseID = Lease.leaseIDgroup by Customer.customerID,firstname,lastname--15. List Car Details for Each Lease.Select Vehicle.vehicleID,make,model,year,dailyrate,status,passengercapacity,enginecapacity,leaseIDfrom Vehicleinner join Lease on Lease.vehicleID = Vehicle.vehicleID--16. Retrieve Details of Active Leases with Customer and Car Information.Select *from Customerinner join Lease on Lease.customerID = Customer.customerIDinner join Vehicle on Vehicle.vehicleID = Lease.vehicleIDwhere enddate >= getdate()--17. Find the Customer Who Has Spent the Most on Leases.Select top 1 Customer.customerID,firstname,lastname,sum(Payment.amount) as MoneySpentfrom Customerinner join Lease on Lease.customerID = Customer.customerIDinner join Payment on Payment.leaseID = Lease.leaseIDgroup by Customer.customerID,firstname,lastnameorder by MoneySpent desc--18. List All Cars with Their Current Lease Information.Select *from Vehicleleft join Lease on Lease.vehicleID = Vehicle.vehicleID