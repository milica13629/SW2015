module language/myTaxiService
//SIGNATURES
sig Guest{}

sig User extends Guest{
	request: lone Request,
	reservations: set Reservation	
}

sig Driver extends User{
	car: one TaxiVehicle
}

sig TaxiVehicle{
	currentDriver: lone Driver
}

sig Report{}

sig SystemListOfParticipants{
	participants: set User,
	reports: set Report
}

sig Request{
	passenger: one User,
	driver: one Driver
}

sig Reservation extends Request{}

sig Admin extends Guest{
	list: one SystemListOfParticipants
}

//FACTS
fact differetDriversPerVehicle{
	no d:Driver | some t1,t2: TaxiVehicle |
	t1!=t2 and d in t1.currentDriver and d in t2.currentDriver
}
fact carDriverRelation{
	all t:TaxiVehicle | all d:Driver| t in d.car => t.currentDriver=d 
}
fact noSameCarTwoDrivers{
	no t:TaxiVehicle| some d1,d2: Driver | d1!=d2 and d1.car=t and d2.car=t
}
fact noSameCarTwoDrivers1{
	all d:Driver| all t:TaxiVehicle|  d in t.currentDriver => t in d.car
}

fact DriverCantBePassenger{
	no u:Driver| some r:Request| u in r.passenger
}

fact singleSystemListOfParticipants{
	no disj l1,l2: SystemListOfParticipants| l1!=l2
}
fact allParticipantsMustBeInList{
	all p: User | one l1:SystemListOfParticipants | p in l1.participants
}
fact reportsAreInSystemList{
	all r:Report| one l:SystemListOfParticipants| r in l.reports 
}

fact diffDriversPerRequest{
	all r1,r2:Request | some d1,d2:Driver| (d1 in r1.driver and d2 in r2.driver) => (d1!=d2)
}

fact diffUsersPerRequest{
	all r1,r2:Request | some u1,u2:User| (u1 in r1.passenger and u2 in r2.passenger) => (u1!=u2)
}

//PREDICATES
pred show{
#Guest=10
#User=8
#Driver= 4
#Admin=1
#Request= 4
#Reservation=2
#Report=2
}
run show for 15
