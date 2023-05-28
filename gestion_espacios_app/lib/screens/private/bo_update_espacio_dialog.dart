import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/espacio.dart';
import 'package:gestion_espacios_app/providers/espacios_provider.dart';
import 'package:gestion_espacios_app/widgets/alert_widget.dart';
import 'package:gestion_espacios_app/widgets/eliminar_elemento.dart';
import 'package:provider/provider.dart';

import '../../widgets/error_widget.dart';

class EditarEspacioBODialog extends StatefulWidget {
  final Espacio espacio;

  const EditarEspacioBODialog({Key? key, required this.espacio})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditarEspacioBODialog createState() => _EditarEspacioBODialog();
}

class _EditarEspacioBODialog extends State<EditarEspacioBODialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController bookingWindowController;
  late TextEditingController isReservableController;
  late TextEditingController requiresAuthorizationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.espacio.name);
    descriptionController =
        TextEditingController(text: widget.espacio.description);
    priceController =
        TextEditingController(text: widget.espacio.price.toString());
    bookingWindowController =
        TextEditingController(text: widget.espacio.bookingWindow);
    isReservableController =
        TextEditingController(text: widget.espacio.isReservable.toString());
    requiresAuthorizationController = TextEditingController(
        text: widget.espacio.requiresAuthorization.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    bookingWindowController.dispose();
    isReservableController.dispose();
    requiresAuthorizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final espaciosProvider = Provider.of<EspaciosProvider>(context);
    final Espacio espacio = widget.espacio;
    String name = espacio.name;
    String description = espacio.description;
    String? image = espacio.image;
    int price = espacio.price;
    List<String> authorizedRoles = espacio.authorizedRoles;
    String bookingWindow = espacio.bookingWindow;

    int tryParseInt(String value, int lastValue) {
      int result;
      try {
        result = int.parse(value);
      } catch (e) {
        result = lastValue;
      }
      return result;
    }

    return AlertDialog(
      backgroundColor: theme.colorScheme.onBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.onPrimary)),
      title: Text(
        espacio.name,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                onChanged: (value) => name = value,
                cursorColor: theme.colorScheme.secondary,
                style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
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
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                      fontFamily: 'KoHo', color: theme.colorScheme.onPrimary),
                  prefixIcon: Icon(Icons.edit_rounded,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                onChanged: (value) => description = value,
                cursorColor: theme.colorScheme.secondary,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
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
                  labelText: 'Descripción',
                  labelStyle: TextStyle(
                      fontFamily: 'KoHo', color: theme.colorScheme.onPrimary),
                  prefixIcon: Icon(Icons.edit_rounded,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                onChanged: (value) => price = tryParseInt(value, price),
                cursorColor: theme.colorScheme.secondary,
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
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
                  labelText: 'Valor de reserva',
                  labelStyle: TextStyle(
                      fontFamily: 'KoHo', color: theme.colorScheme.onPrimary),
                  prefixIcon: Icon(Icons.monetization_on_outlined,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Reservable',
                    style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo')),
                value: isReservableController.text == 'true',
                onChanged: (bool? newValue) {
                  setState(() {
                    isReservableController.text = newValue!.toString();
                  });
                },
                activeColor: theme.colorScheme.onBackground,
                checkColor: theme.colorScheme.secondary,
                side: BorderSide(color: theme.colorScheme.onPrimary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(
                  'Autorización requerida',
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
                ),
                value: requiresAuthorizationController.text == 'true',
                onChanged: (bool? newValue) {
                  setState(() {
                    requiresAuthorizationController.text = newValue!.toString();
                  });
                },
                activeColor: theme.colorScheme.onBackground,
                checkColor: theme.colorScheme.secondary,
                side: BorderSide(color: theme.colorScheme.onPrimary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Text(
                    'Roles autorizados',
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary, fontSize: 18, fontFamily: 'KoHo'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Administrador',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
                            ),
                            Checkbox(
                              value: authorizedRoles.contains('ADMINISTRATOR'),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null && newValue) {
                                    authorizedRoles.add('ADMINISTRATOR');
                                  } else {
                                    authorizedRoles.remove('ADMINISTRATOR');
                                  }
                                });
                              },
                              activeColor: theme.colorScheme.onBackground,
                              checkColor: theme.colorScheme.secondary,
                              side: BorderSide(
                                  color: theme.colorScheme.onPrimary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Profesor',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
                            ),
                            Checkbox(
                              value: authorizedRoles.contains('TEACHER'),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null && newValue) {
                                    authorizedRoles.add('TEACHER');
                                  } else {
                                    authorizedRoles.remove('TEACHER');
                                  }
                                });
                              },
                              activeColor: theme.colorScheme.onBackground,
                              checkColor: theme.colorScheme.secondary,
                              side: BorderSide(
                                  color: theme.colorScheme.onPrimary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Usuario',
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
                            ),
                            Checkbox(
                              value: authorizedRoles.contains('USER'),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null && newValue) {
                                    authorizedRoles.add('USER');
                                  } else {
                                    authorizedRoles.remove('USER');
                                  }
                                });
                              },
                              activeColor: theme.colorScheme.onBackground,
                              checkColor: theme.colorScheme.secondary,
                              side: BorderSide(
                                  color: theme.colorScheme.onPrimary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bookingWindowController,
                // onChanged: (value) => bookingWindow = tryParseInt(value, bookingWindow),
                onChanged: (value) => bookingWindow = value,
                cursorColor: theme.colorScheme.secondary,
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.colorScheme.onPrimary, fontFamily: 'KoHo'),
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
                  labelText: 'Ventana de reserva (en días)',
                  labelStyle: TextStyle(
                      fontFamily: 'KoHo', color: theme.colorScheme.onPrimary),
                  prefixIcon: Icon(Icons.calendar_today_outlined,
                      color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Espacio espacioActualizado = Espacio(
                      uuid: espacio.uuid,
                      name: name,
                      description: description,
                      price: price,
                      image: image,
                      isReservable: isReservableController.text == 'true',
                      requiresAuthorization:
                          requiresAuthorizationController.text == 'true',
                      authorizedRoles: authorizedRoles,
                      bookingWindow: bookingWindow,
                    );

                    Navigator.of(context).pop();

                    espaciosProvider
                        .updateEspacio(espacioActualizado)
                        .then((_) {
                      Navigator.pushNamed(context, '/home-bo');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyMessageDialog(
                            title: 'Espacio actualizado',
                            description:
                                'Se ha actualizado el espacio correctamente.',
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
                                  'Ha ocurrido un error al actualizar el espacio.',
                            );
                          });
                    });
                  },
                  icon: Icon(Icons.edit_rounded,
                      color: theme.colorScheme.onSecondary),
                  label: Text(
                    'Actualizar',
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
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => MyDeleteAlert(
                        title: '¿Está seguro de que desea eliminar el espacio?',
                        ruta: '/home-bo',
                        elemento: espacio,
                      ),
                    );
                  },
                  label: Text(
                    'Eliminar',
                    style: TextStyle(
                      color: theme.colorScheme.onSecondary,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'KoHo',
                      fontSize: 20,
                    ),
                  ),
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.onSecondary),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
