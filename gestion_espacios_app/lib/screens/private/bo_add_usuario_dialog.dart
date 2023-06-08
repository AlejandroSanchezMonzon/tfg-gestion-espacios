import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:gestion_espacios_app/providers/storage_provider.dart';
import 'package:gestion_espacios_app/providers/usuarios_provider.dart';
import 'package:gestion_espacios_app/widgets/alert_widget.dart';
import 'package:gestion_espacios_app/widgets/error_widget.dart';
import 'package:gestion_espacios_app/widgets/picked_image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NuevoUsuarioBODialog extends StatefulWidget {
  const NuevoUsuarioBODialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NuevoUsuarioBODialog createState() => _NuevoUsuarioBODialog();
}

class _NuevoUsuarioBODialog extends State<NuevoUsuarioBODialog> {
  String name = '';
  String username = '';
  String password = '';
  String password2 = '';
  String email = '';
  List<String> userRole = [];
  String? avatar = 'placeholder';
  int credits = 0;
  bool isActive = true;
  PickedFile? selectedImage;
  ImagePicker picker = ImagePicker();

  int tryParseInt(String value, {int fallbackValue = 0}) {
    int result;
    try {
      result = int.parse(value);
    } catch (e) {
      result = fallbackValue;
    }
    return result;
  }

  void pickImage() async {
    PickedFile? pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final usuariosProvider = Provider.of<UsuariosProvider>(context);
    final storageProvider = Provider.of<StorageProvider>(context);

    return AlertDialog(
        backgroundColor: theme.colorScheme.onBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: theme.colorScheme.onPrimary)),
        title: Text(
          'Nuevo usuario',
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
                      child: PickedImageWidget(
                        pickedImage: selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      pickImage();
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
                          onChanged: (value) => username = value,
                          cursorColor: theme.colorScheme.secondary,
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
                          onChanged: (value) => password = value,
                          cursorColor: theme.colorScheme.secondary,
                          obscureText: true,
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
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.lock_rounded,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) => password2 = value,
                          cursorColor: theme.colorScheme.secondary,
                          obscureText: true,
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
                            labelText: 'Confirmar contraseña',
                            labelStyle: TextStyle(
                                fontFamily: 'KoHo',
                                color: theme.colorScheme.onPrimary),
                            prefixIcon: Icon(Icons.lock_rounded,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) => email = value,
                          cursorColor: theme.colorScheme.secondary,
                          keyboardType: TextInputType.emailAddress,
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
                          onChanged: (value) => credits = tryParseInt(value),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Activo',
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary, fontFamily: 'KoHo')),
              value: isActive,
              onChanged: (bool? newValue) {
                setState(() {
                  isActive = newValue!;
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
            ElevatedButton.icon(
              onPressed: () {
                if (password == password2) {
                  Usuario usuario = Usuario(
                    name: name,
                    username: username,
                    email: email,
                    password: password,
                    credits: credits,
                    avatar: 'placeholder',
                    isActive: isActive,
                    userRole: userRole,
                  );

                  if (selectedImage != null) {
                    storageProvider
                        .uploadUserImage(selectedImage!)
                        .then((imageUrl) {
                      usuario.avatar = imageUrl;

                      usuariosProvider.register(usuario).then((_) {
                        Navigator.pushNamed(context, '/home-bo');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const MyMessageDialog(
                              title: 'Usuario creado',
                              description:
                                  'Se ha creado el usuario correctamente.',
                            );
                          },
                        );
                      }).catchError((error) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyErrorMessageDialog(
                                title: 'Error al crear el usuario',
                                description: error.toString().substring(
                                    error.toString().indexOf(':') + 1),
                              );
                            });
                      });
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyErrorMessageDialog(
                            title: 'Error al añadir la imagen',
                            description: error
                                .toString()
                                .substring(error.toString().indexOf(':') + 1),
                          );
                        },
                      );
                    });
                  } else {
                    usuariosProvider.register(usuario).then((_) {
                      Navigator.pushNamed(context, '/home-bo');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyMessageDialog(
                            title: 'Usuario creado',
                            description:
                                'Se ha creado el usuario correctamente.',
                          );
                        },
                      );
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyErrorMessageDialog(
                            title: 'Error al registrar el usuario',
                            description: error
                                .toString()
                                .substring(error.toString().indexOf(':') + 1),
                          );
                        },
                      );
                    });
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const MyErrorMessageDialog(
                        title: 'Error al registrar el usuario',
                        description: 'Las contraseñas no coinciden.',
                      );
                    },
                  );
                }
              },
              icon:
                  Icon(Icons.add_rounded, color: theme.colorScheme.onSecondary),
              label: Text(
                'Añadir',
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
        )));
  }
}