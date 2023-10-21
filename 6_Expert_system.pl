:- dynamic(vehicle/2).

%goods_vehicle(Vehicle, GoodsType, Distance, Capacity, Budget, TransportMode, FuelType, Mileage, PermitRequired).
goods_vehicle(cargo_truck, perishable, 1000, 10, 8000, road, diesel, 8, yes).
goods_vehicle(box_truck, fragile,500, 1, 2000, road, diesel, 7, no).
goods_vehicle(box_truck, fragile, 500, 1, 3000, road, petrol, 7, no).
goods_vehicle(refrigerated_truck, perishable, 600, 1.5, 1500, road, diesel, 6,yes).
goods_vehicle(tanker_truck, hazardous, 1200, 2, 2000, road, diesel, 6,yes).
goods_vehicle(pickup_truck, general, 100, 0.5, 1200, road, diesel, 15,no).
goods_vehicle(lorry, general, 2000, 4, 3200, road, diesel, 8, yes).
goods_vehicle(freight_train, general, 3000, 100, 1000, rail, diesel, 5, no).
goods_vehicle(tank_car, hazardous, 5000, 3, 1500, rail, diesel, 5, yes).
goods_vehicle(cargo_ship, general, 5000, 200, 4000, water, diesel, 3, yes).
goods_vehicle(container_ship, general,10000,250,6000, water, diesel, 3, yes).
goods_vehicle(cargo_airplane, general,8000, 10, 10000, air, aviation_fuel, 4, yes).

%passenger_vehicle(Vehicle,Distance, PassengerCapacity, SleeperOrSeater, Budget, TransportMode, FuelType, Mileage).
passenger_vehicle(motorcycle, 250, 2, seater, 20, road, petrol, 25).
passenger_vehicle(scooter, 200, 2, seater, 15, road, petrol, 30).
passenger_vehicle(auto, 150, 3, seater, 50, road, petrol, 20).
passenger_vehicle(auto, 150, 3, seater, 50, road, cng, 20).
passenger_vehicle(car, 700, 5, seater,80, road, petrol, 15).
passenger_vehicle(car, 700, 5, seater,80, road, cng, 15).
passenger_vehicle(van, 600, 9, seater, 100, road, diesel, 12).
passenger_vehicle(bus, 800, 60, seater, 120, road, diesel, 7).
passenger_vehicle(bus, 800, 60, seater, 100, road, diesel, 7).
passenger_vehicle(luxury_bus, 800, 30, sleeper, 150, road, diesel, 7).
passenger_vehicle(train,600, 1000, seater, 60, rail, diesel, 10).
passenger_vehicle(train,600, 1000, sleeper, 120, rail,diesel, 10).
passenger_vehicle(boat, 400, 100, seater, 200, water, diesel, 8).
passenger_vehicle(ship, 4000, 3000, seater, 350, water, diesel, 5).
passenger_vehicle(airplane, 8000, 500, seater, 500, air, aviation_fuel, 4).
passenger_vehicle(airplane, 8000, 200, sleeper, 800, air, aviation_fuel, 4).
passenger_vehicle(charter_plane, 5000, 100, seater, 900, air, aviation_fuel, 5).
passenger_vehicle(helicopter, 600, 6, seater,600, air, aviation_fuel, 6).

/* Rules */
start :-
    write('Are you transporting goods or passengers? (goods/passengers) '),
    read(TransportType),
    assert(vehicle(transport_type,TransportType)),
    process_transport_type(TransportType).

process_transport_type(goods) :-
    ask_goods_questions.

process_transport_type(passengers) :-
    ask_passenger_questions.

process_transport_type(_) :- 
    writeln('Invalid choice. Please enter "goods" or "passengers".'),
    start.

ask_goods_type :-
    write('What type of goods are you transporting (e.g., perishable, fragile, hazardous)? '),
    read(GoodsType),
    assert(vehicle(goods_type, GoodsType)).

ask_distance :-
    write('What is the distance you need to transport the goods (in kilometers)? '),
    read(Distance),
    assert(vehicle(distance, Distance)).

ask_capacity :-
    write('What is the total weight or volume of the goods (in tons or cubic meters)? '),
    read(Capacity),
    assert(vehicle(capacity, Capacity)).

ask_budget :-
    write('What is your budget for transportation? (in Rs.) '),
    read(MaxBudget),
    assert(vehicle(budget, MaxBudget)).

ask_transport_mode :-
    write('Choose a transport mode (water, road, rail, air): '),
    read(TransportMode),
    assert(vehicle(transport_mode, TransportMode)).

ask_fuel_type :-
    write('Specify the preferred fuel type (e.g., diesel,petrol,cng,aviation_fuel): '),
    read(FuelType),
    assert(vehicle(fuel_type, FuelType)).

ask_mileage :-
    write('What is the required mileage or fuel efficiency (in kilometers per unit fuel)? '),
    read(Mileage),
    assert(vehicle(mileage, Mileage)).

ask_national_permit_required :-
    write('Is a national permit required for this vehicle (yes/no)? '),
    read(PermitRequired),
    assert(vehicle(national_permit_required, PermitRequired)).

ask_passenger_capacity :-
    write('How many passengers can the vehicle accommodate? '),
    read(PassengerCapacity),
    assert(vehicle(passenger_capacity, PassengerCapacity)).

ask_sleeper_or_seater :-
    write('Do you need a sleeper or seater vehicle? (sleeper/seater) '),
    read(SleeperOrSeater),
    assert(vehicle(sleeper_or_seater, SleeperOrSeater)).

choose_goods_vehicle(Vehicle) :-
    vehicle(goods_type, GoodsType),
    vehicle(distance, Distance),
    vehicle(capacity, Capacity),
    vehicle(budget, MaxBudget),
    vehicle(transport_mode, TransportMode),
    vehicle(fuel_type, FuelType),
    vehicle(mileage, Mileage),
    vehicle(national_permit_required, PermitRequired),
    goods_vehicle(
        Vehicle,
        GoodsType,
        MaxDistance,
        MaxCapacity,
        Budget,
        TransportMode,
        FuelType,
        MaxMileage,
        PermitRequired
    ),
    Distance =< MaxDistance,
    Capacity =< MaxCapacity,
    (Distance * Capacity  * Budget) =< MaxBudget,
    Mileage =< MaxMileage.

choose_passenger_vehicle(Vehicle) :-
    vehicle(distance, Distance),
    vehicle(passenger_capacity, PassengerCapacity),
    vehicle(sleeper_or_seater, SleeperOrSeater),
    vehicle(budget, MaxBudget),
    vehicle(transport_mode, TransportMode),
    vehicle(fuel_type, FuelType),
    vehicle(mileage, Mileage),
    passenger_vehicle(
        Vehicle,
        MaxDistance,
        MaxPassengerCapacity,
        SleeperOrSeater,
        Budget,
        TransportMode,
        FuelType,
        MaxMileage
    ),
    Distance =< MaxDistance,
    PassengerCapacity =< MaxPassengerCapacity,
    (Distance * Budget) =< MaxBudget,
    Mileage =< MaxMileage.

ask_goods_questions :-
    ask_goods_type,
    ask_distance,
    ask_capacity,
    ask_budget,
    ask_transport_mode,
    ask_fuel_type,
    ask_mileage,
    ask_national_permit_required,
    choose_goods_vehicle(Vehicle),
    (Vehicle \= [] -> format('Based on your requirements, we recommend using a ~w for transporting goods.', [Vehicle])).

ask_goods_questions :-
    writeln('Could not find a suitable vehicle based on your requirements.').

ask_passenger_questions :-
    ask_passenger_capacity,
    ask_sleeper_or_seater,
    ask_distance,
    ask_budget,
    ask_transport_mode,
    ask_fuel_type,
    ask_mileage,
    choose_passenger_vehicle(Vehicle),
    (Vehicle \= [] -> format('Based on your requirements, we recommend using a ~w for passenger transport.', [Vehicle])).

ask_passenger_questions :-
    writeln('Could not find a suitable vehicle based on your requirements.').