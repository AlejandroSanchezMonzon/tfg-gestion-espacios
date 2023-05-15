import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/colors.dart';
import 'package:gestion_espacios_app/widgets/alert_widget.dart';
import 'package:gestion_espacios_app/widgets/eliminar_elemento.dart';
import 'package:gestion_espacios_app/widgets/error_widget.dart';
import 'package:table_calendar/table_calendar.dart';

final List<String> horas = [
  '08:25 - 09:20',
  '09:20 - 10:15',
  '10:15 - 11:10',
  '11:10 - 12:05',
  '12:05 - 12:30',
  '12:30 - 13:25',
  '13:25 - 14:20',
  '14:20 - 15:15',
];

class EditarReservaScreen extends StatefulWidget {
  const EditarReservaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservaSala createState() => _ReservaSala();
}

// ignore: must_be_immutable
class _ReservaSala extends State<EditarReservaScreen> {
  bool _isDaySelected = false;
  bool _isHourSelected = false;
  DateTime? selectedDay;
  String? selectedHour;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre de la sala',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'KoHo',
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/mis-reservas');
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const MyDeleteAlert(
                  title: '¿Está seguro de que desea eliminar la reserva?',
                  ruta: '/mis-reservas',
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
            color: MyColors.pinkApp,
            iconSize: 25,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/image_placeholder.png',
                    width: 150, height: 150, fit: BoxFit.cover),
                const SizedBox(height: 20),
                const Text(
                  'Descripción de la sala',
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'KoHo',
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Fecha',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'KoHo',
                        fontWeight: FontWeight.bold,
                        color: MyColors.pinkApp,
                      ),
                    ),
                    Text(
                      'Hora',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'KoHo',
                        fontWeight: FontWeight.bold,
                        color: MyColors.pinkApp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: MyColors.pinkApp,
                      width: 2,
                    ),
                  ),
                  child: TableCalendar(
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                        color: MyColors.pinkApp,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KoHo',
                      ),
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: MyColors.pinkApp,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: MyColors.pinkApp,
                      ),
                    ),
                    focusedDay: DateTime.now(),
                    firstDay:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KoHo',
                      ),
                      isTodayHighlighted: true,
                      selectedDecoration: const BoxDecoration(
                        color: MyColors.pinkApp,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                          color: MyColors.whiteApp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'KoHo'),
                      todayDecoration: BoxDecoration(
                        color: MyColors.blackApp.shade100,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                          color: MyColors.blackApp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'KoHo'),
                      weekendTextStyle: const TextStyle(
                          color: Colors.grey, fontFamily: 'KoHo'),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: MyColors.pinkApp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KoHo',
                      ),
                      weekendStyle: TextStyle(
                        fontFamily: 'KoHo',
                        color: Colors.grey,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      final now = DateTime.now();
                      if (selectedDay.isBefore(
                              now.subtract(const Duration(days: 1))) ||
                          (selectedDay.weekday == 6 ||
                              selectedDay.weekday == 7)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const MyErrorMessageDialog(
                                title: 'Fecha incorrecta',
                                description:
                                    'Debes seleccionar una fecha no festiva posterior a hoy.');
                          },
                        );
                      } else {
                        setState(() {
                          _isDaySelected = true;
                          this.selectedDay = selectedDay;
                        });
                        _scrollController.animateTo(
                            _scrollController.position.viewportDimension,
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _isDaySelected,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: horas
                        .map((hora) => SizedBox(
                              width: 150,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isHourSelected = true;
                                    selectedHour = hora;
                                  });
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.viewportDimension,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      curve: Curves.easeInOut);
                                },
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return MyColors.pinkApp
                                            .withOpacity(0.2);
                                      }
                                      return Colors.transparent;
                                    },
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: MyColors.blackApp,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      hora,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: MyColors.blackApp,
                                        fontFamily: 'KoHo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                    visible: _isDaySelected,
                    child: Text(
                      'Fecha elegida: ${selectedDay?.day}/${selectedDay?.month}/${selectedDay?.year}',
                      style: const TextStyle(
                        color: MyColors.pinkApp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KoHo',
                      ),
                    )),
                Visibility(
                    visible: _isHourSelected,
                    child: Text(
                      'Hora elegida: $selectedHour',
                      style: const TextStyle(
                        color: MyColors.pinkApp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KoHo',
                      ),
                    )),
                const SizedBox(height: 20),
                Visibility(
                  visible: _isHourSelected,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/mis-reservas');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const MyMessageDialog(
                              title: 'Reserva actualizada',
                              description:
                                  'Se ha actualizado la reserva correctamente.',
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: MyColors.pinkApp,
                    ),
                    child: const Text('Editar reserva',
                        style: TextStyle(
                            color: MyColors.whiteApp, fontFamily: 'KoHo')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}