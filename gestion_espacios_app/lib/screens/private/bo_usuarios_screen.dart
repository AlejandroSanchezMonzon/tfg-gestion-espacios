import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:gestion_espacios_app/providers/usuarios_provider.dart';
import 'package:gestion_espacios_app/screens/private/bo_add_usuario_dialog.dart';
import 'package:gestion_espacios_app/screens/private/bo_update_usuario_dialog.dart';
import 'package:gestion_espacios_app/widgets/user_image_widget.dart';
import 'package:provider/provider.dart';

import '../../models/colors.dart';

class UsuariosBOScreen extends StatefulWidget {
  const UsuariosBOScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UsuariosBOScreen createState() => _UsuariosBOScreen();
}

class _UsuariosBOScreen extends State<UsuariosBOScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Usuario> usuariosFiltrados = [];

  @override
  void initState() {
    super.initState();
    final usuariosProvider =
        Provider.of<UsuariosProvider>(context, listen: false);

    usuariosFiltrados = usuariosProvider.usuarios;

    usuariosProvider.fetchUsuarios().then((value) => setState(() {
          usuariosFiltrados = usuariosProvider.usuarios;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<List<Usuario>> filterUsuarios(String query) async {
    final usuariosProvider =
        Provider.of<UsuariosProvider>(context, listen: false);
    List<Usuario> usuarios = usuariosProvider.usuarios;

    return usuarios
        .where((usuario) =>
            usuario.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                cursorColor: theme.colorScheme.secondary,
                style: TextStyle(
                    color: theme.colorScheme.secondary, fontFamily: 'KoHo'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.pinkApp.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Buscar',
                  hintStyle: TextStyle(
                    fontFamily: 'KoHo',
                    color: theme.colorScheme.secondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: theme.colorScheme.secondary, size: 30),
                ),
                onChanged: (value) {
                  filterUsuarios(value).then((usuarios) {
                    setState(() {
                      usuariosFiltrados = usuarios;
                    });
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const NuevoUsuarioBODialog();
                        });
                  },
                  icon: Icon(Icons.add_rounded,
                      color: theme.colorScheme.onSecondary),
                  label: Text(
                    'Nuevo',
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
              ],
            )
          ],
        ),
      ),
      if (usuariosFiltrados.isEmpty)
        Center(
          child: CircularProgressIndicator.adaptive(
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
          ),
        ),
      if (usuariosFiltrados.isNotEmpty)
        Expanded(
          child: StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(10),
            crossAxisCount: 5,
            itemCount: usuariosFiltrados.length,
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (BuildContext context, int index) {
              final usuario = usuariosFiltrados[index];
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditarUsuarioBODialog(usuario: usuario);
                    },
                  );
                },
                child: Card(
                  color: theme.colorScheme.onBackground,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                      minHeight: 150,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: MyUserImageWidget(
                                image: usuario.avatar,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                usuario.name,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'KoHo',
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              Text('@${usuario.username}',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'KoHo',
                                    color: theme.colorScheme.onPrimary,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
    ]);
  }
}
