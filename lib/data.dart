List<Car> cars = [
  Car(id: 1, name: 'Chevrolet Capitiva', type: 'SUV'),
  Car(id: 2, name: 'Chery QQ', type: 'Compacto'),
  Car(id: 3, name: 'Chery Tiggo', type: 'SUV'),
  Car(id: 4, name: 'Ford Fiesta Sedã', type: 'Sedã'),
  Car(id: 5, name: 'Chevrolet Celta', type: 'Compacto'),
  Car(id: 6, name: 'Chevrolet Prisma', type: 'Sedã'),
];

class Car {
  final int id;
  final String name, type;

  Car({required this.id, required this.name, required this.type});
}
