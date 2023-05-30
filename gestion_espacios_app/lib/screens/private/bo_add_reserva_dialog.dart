import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/espacio.dart';
import 'package:gestion_espacios_app/models/reserva.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:gestion_espacios_app/providers/espacios_provider.dart';
import 'package:gestion_espacios_app/providers/reservas_provider.dart';
import 'package:gestion_espacios_app/widgets/alert_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/error_widget.dart';

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

class NuevaReservaBODialog extends StatefulWidget {
  final Usuario usuario;

  const NuevaReservaBODialog({Key? key, required this.usuario})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NuevaReservaBODialog createState() => _NuevaReservaBODialog();
}

class _NuevaReservaBODialog extends State<NuevaReservaBODialog> {
  DateTime? selectedDay;
  String? selectedHour;
  String image = '';
  String spaceId = '';
  String spaceName = '';
  String observations = '';
  bool requiresAuthorization = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final reservasProvider = Provider.of<ReservasProvider>(context);
    final espaciosProvider = Provider.of<EspaciosProvider>(context);
    final List<Espacio> espacios = espaciosProvider.espaciosReservables;
    Usuario usuario = widget.usuario;
    final userId = usuario.uuid;
    final userName = widget.usuario.name;
    String startTime;
    String endTime;

    return AlertDialog(
      backgroundColor: theme.colorScheme.onBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.onPrimary)),
      title: Text(
        'Nueva reserva para: $userName',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
            fontFamily: 'KoHo'),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              TextField(
                onChanged: (value) => observations = value,
                cursorColor: theme.colorScheme.secondary,
                style: TextStyle(
                    color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  labelText: 'Observaciones',
                  labelStyle: TextStyle(
                      fontFamily: 'KoHo', color: theme.colorScheme.onPrimary),
                  prefixIcon: Icon(Icons.edit_rounded,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Text(
                    'Espacio a reservar',
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 18,
                        fontFamily: 'KoHo'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<Espacio>(
                    value: spaceName == ''
                        ? null
                        : espacios.firstWhere((e) => e.name == spaceName),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    onChanged: (value) {
                      setState(() {
                        image = value!.image ?? 'image_placeholder.jpeg';
                        spaceId = value.uuid ?? '';
                        spaceName = value.name;
                        requiresAuthorization = value.requiresAuthorization;
                      });
                    },
                    hint: Text(
                      'Selecciona un espacio de la lista desplegable',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontFamily: 'KoHo',
                      ),
                    ),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: theme.colorScheme.onBackground,
                    icon: Icon(Icons.expand_more_rounded,
                        color: theme.colorScheme.onPrimary, size: 15),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontFamily: 'KoHo',
                    ),
                    underline: Container(
                      height: 2,
                      color: theme.colorScheme.secondary,
                    ),
                    items: espacios
                        .map<DropdownMenuItem<Espacio>>((Espacio espacio) {
                      return DropdownMenuItem<Espacio>(
                        value: espacio,
                        alignment: Alignment.center,
                        child: Text(espacio.name,
                            style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontFamily: 'KoHo')),
                      );
                    }).toList(),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Hora de inicio/fin',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 18,
                          fontFamily: 'KoHo'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: theme.colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                          child: TableCalendar(
                            headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'KoHo',
                              ),
                              formatButtonVisible: false,
                              leftChevronIcon: Icon(
                                Icons.chevron_left_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            focusedDay: DateTime.now(),
                            firstDay: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDay:
                                DateTime.now().add(const Duration(days: 365)),
                            calendarFormat: CalendarFormat.month,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            daysOfWeekVisible: true,
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary,
                              ),
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(
                                  color: theme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'KoHo'),
                              todayDecoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                  color: theme.colorScheme.background,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'KoHo'),
                              weekendTextStyle: const TextStyle(
                                  color: Colors.grey, fontFamily: 'KoHo'),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'KoHo',
                              ),
                              weekendStyle: const TextStyle(
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
                                  this.selectedDay = selectedDay;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: horas
                                    .map((hora) => SizedBox(
                                          width: 150,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedHour = hora;
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor: hora ==
                                                      selectedHour
                                                  ? MaterialStateProperty
                                                      .all<Color>(theme
                                                          .colorScheme.secondary
                                                          .withOpacity(0.5))
                                                  : MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.transparent),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return theme
                                                        .colorScheme.secondary
                                                        .withOpacity(0.2);
                                                  }
                                                  return Colors.transparent;
                                                },
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  hora,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme.onPrimary,
                                                    fontWeight:
                                                        hora == selectedHour
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
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
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Fecha elegida: ${selectedDay != null ? DateFormat('dd/MM/yyyy').format(selectedDay!) : 'No seleccionada'}',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'KoHo',
                                    ),
                                  ),
                                  Text(
                                    'Hora elegida: ${selectedHour ?? 'No seleccionada'}',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'KoHo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    startTime =
                        '${selectedDay?.year}-${selectedDay?.month.toString().padLeft(2, '0')}-${selectedDay?.day.toString().padLeft(2, '0')}T${selectedHour?.split(' ')[0].padLeft(2, '0')}:01';
                    endTime =
                        '${selectedDay?.year}-${selectedDay?.month.toString().padLeft(2, '0')}-${selectedDay?.day.toString().padLeft(2, '0')}T${selectedHour?.split(' ')[2].padLeft(2, '0')}:01';

                    final reserva = Reserva(
                      userId: userId!,
                      spaceId: spaceId,
                      startTime: startTime,
                      endTime: endTime,
                      userName: userName,
                      spaceName: spaceName,
                      observations: observations,
                      status: requiresAuthorization ? 'PENDING' : 'APPROVED',
                      image: image,
                    );

                    reservasProvider.addReserva(reserva).then((_) {
                      Navigator.pushNamed(context, '/home-bo');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyMessageDialog(
                            title: 'Reserva creada para el usuario $userName',
                            description:
                                'Se ha realizado la reserva correctamente.',
                          );
                        },
                      );
                    }).catchError((error) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const MyErrorMessageDialog(
                              title: 'Error',
                              description:
                                  'Ha ocurrido un error al realizar la reserva.',
                            );
                          });
                    });
                  },
                  icon: Icon(Icons.add_rounded,
                      color: theme.colorScheme.onSecondary),
                  label: Text(
                    'Reservar',
                    style: TextStyle(
                      color: theme.colorScheme.onSecondary,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'KoHo',
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
