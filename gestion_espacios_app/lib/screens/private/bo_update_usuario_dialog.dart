import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:gestion_espacios_app/providers/storage_provider.dart';
import 'package:gestion_espacios_app/providers/usuarios_provider.dart';
import 'package:gestion_espacios_app/screens/private/bo_add_reserva_dialog.dart';
import 'package:gestion_espacios_app/widgets/alert_widget.dart';
import 'package:gestion_espacios_app/widgets/eliminar_elemento.dart';
import 'package:gestion_espacios_app/widgets/error_widget.dart';
import 'package:gestion_espacios_app/widgets/user_image_widget.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

class EditarUsuarioBODialog extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioBODialog({Key? key, required this.usuario})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditarUsuarioBODialog createState() => _EditarUsuarioBODialog();
}

class _EditarUsuarioBODialog extends State<EditarUsuarioBODialog> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController creditsController;
  late TextEditingController isActiveController;
  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.usuario.name);
    usernameController = TextEditingController(text: widget.usuario.username);
    passwordController = TextEditingController(text: widget.usuario.password);
    emailController = TextEditingController(text: widget.usuario.email);
    creditsController =
        TextEditingController(text: widget.usuario.credits.toString());
    isActiveController =
        TextEditingController(text: widget.usuario.isActive.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    creditsController.dispose();
    isActiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final usuariosProvider = Provider.of<UsuariosProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);
    final Usuario usuario = widget.usuario;
    String name = usuario.name;
    String username = usuario.username;
    String password = usuario.password;
    String email = usuario.email;
    String? avatar = usuario.avatar;
    List<String> userRole = usuario.userRole;
    int credits = usuario.credits;

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
          usuario.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
              fontFamily: 'KoHo'),
        ),
        content: SingleChildScrollView(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(children: [
            Row(
              children: [
                Column(children: [
                  if (selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.memory(
                        selectedImage!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (selectedImage == null && avatar != null)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: MyUserImageWidget(image: usuario.avatar)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final image = await ImagePickerWeb.getImageAsBytes();
                      if (image != null) {
                        setState(() {
                          selectedImage = image;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Seleccionar imagen',
                        style: TextStyle(
                            fontFamily: 'KoHo',
                            color: theme.colorScheme.onPrimary),
                        textAlign: TextAlign.center),
                  ),
                ]),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        TextField(
                          enabled: false,
                          controller: nameController,
                          onChanged: (value) => name = value,
                          cursorColor: theme.colorScheme.secondary,
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontFamily: 'KoHo'),
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
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.person_rounded,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: false,
                          controller: usernameController,
                          onChanged: (value) => username = value,
                          cursorColor: theme.colorScheme.secondary,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontFamily: 'KoHo'),
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
                            labelText: 'Nombre de usuario',
                            labelStyle: TextStyle(
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.edit_rounded,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: false,
                          controller: emailController,
                          onChanged: (value) => email = value,
                          cursorColor: theme.colorScheme.secondary,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontFamily: 'KoHo'),
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
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.edit_rounded,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: creditsController,
                          onChanged: (value) =>
                              credits = tryParseInt(value, credits),
                          cursorColor: theme.colorScheme.secondary,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontFamily: 'KoHo'),
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
                            labelText: 'Créditos disponibles',
                            labelStyle: TextStyle(
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.monetization_on_outlined,
                                color: theme.colorScheme.onPrimary),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Activo',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary, fontFamily: 'KoHo')),
              value: isActiveController.text == 'true',
              onChanged: (bool? newValue) {
                setState(() {
                  isActiveController.text = newValue!.toString();
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
                  'Roles del usuario',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontFamily: 'KoHo'),
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
                            style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontFamily: 'KoHo'),
                          ),
                          Checkbox(
                            value: userRole.contains('ADMINISTRATOR'),
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue != null && newValue) {
                                  userRole.add('ADMINISTRATOR');
                                } else {
                                  userRole.remove('ADMINISTRATOR');
                                }
                              });
                            },
                            activeColor: theme.colorScheme.onBackground,
                            checkColor: theme.colorScheme.secondary,
                            side:
                                BorderSide(color: theme.colorScheme.onPrimary),
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
                            style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontFamily: 'KoHo'),
                          ),
                          Checkbox(
                            value: userRole.contains('TEACHER'),
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue != null && newValue) {
                                  userRole.add('TEACHER');
                                } else {
                                  userRole.remove('TEACHER');
                                }
                              });
                            },
                            activeColor: theme.colorScheme.onBackground,
                            checkColor: theme.colorScheme.secondary,
                            side:
                                BorderSide(color: theme.colorScheme.onPrimary),
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
                            style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontFamily: 'KoHo'),
                          ),
                          Checkbox(
                            value: userRole.contains('USER'),
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue != null && newValue) {
                                  userRole.add('USER');
                                } else {
                                  userRole.remove('USER');
                                }
                              });
                            },
                            activeColor: theme.colorScheme.onBackground,
                            checkColor: theme.colorScheme.secondary,
                            side:
                                BorderSide(color: theme.colorScheme.onPrimary),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton.icon(
                onPressed: () {
                  Usuario usuarioActualizado = Usuario(
                      uuid: usuario.uuid,
                      name: name,
                      username: username,
                      email: email,
                      password: password,
                      avatar: avatar,
                      credits: creditsController.text == ''
                          ? usuario.credits
                          : credits,
                      isActive: isActiveController.text == 'true',
                      userRole: userRole);

                  if (selectedImage != null) {
                    storageProvider
                        .uploadUserImage(selectedImage!)
                        .then((imageUrl) {
                      usuarioActualizado.avatar = imageUrl;

                      usuariosProvider
                          .updateUsuario(usuario.uuid!, usuarioActualizado)
                          .then((_) {
                        Navigator.pushNamed(context, '/home-bo');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const MyMessageDialog(
                              title: 'Usuario actualizado',
                              description:
                                  'Se ha actualizado el usuario correctamente.',
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
                                    'Ha ocurrido un error al actualizar el usuario.',
                              );
                            });
                      });
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyErrorMessageDialog(
                            title: 'Error',
                            description:
                                'Ha ocurrido un error al subir la imagen.',
                          );
                        },
                      );
                    });
                  } else {
                    usuariosProvider
                        .updateUsuario(usuario.uuid!, usuarioActualizado)
                        .then((_) {
                      Navigator.pushNamed(context, '/home-bo');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyMessageDialog(
                            title: 'Usuario actualizado',
                            description:
                                'Se ha actualizado el usuario correctamente.',
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
                                'Ha ocurrido un error al actualizar el usuario.',
                          );
                        },
                      );
                    });
                  }
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
                    builder: (BuildContext context) => NuevaReservaBODialog(
                      usuario: usuario,
                    ),
                  );
                },
                label: Text(
                  'Añadir reserva',
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'KoHo',
                    fontSize: 20,
                  ),
                ),
                icon: Icon(Icons.add_rounded,
                    color: theme.colorScheme.onSecondary),
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
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => MyDeleteAlert(
                      title: '¿Está seguro de que desea eliminar el usuario?',
                      ruta: '/home-bo',
                      elemento: usuario,
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
          ]),
        )));
  }
}
