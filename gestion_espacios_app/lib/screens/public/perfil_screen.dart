import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/providers/usuarios_provider.dart';
import 'package:gestion_espacios_app/widgets/logout_widget.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    final usuarioProvider =
        Provider.of<UsuariosProvider>(context, listen: false);
    usuarioProvider.fetchActualUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuariosProvider>(context);
    final usuario = usuarioProvider.actualUsuario;
    var theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil'),
        titleTextStyle: TextStyle(
          fontFamily: 'KoHo',
          color: theme.colorScheme.surface,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        backgroundColor: theme.colorScheme.background,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profile_pic.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              usuario.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'KoHo',
              ),
            ),
            Text(
              '@${usuario.username}',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'KoHo',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  usuario.credits.toString(),
                  style: TextStyle(
                    fontFamily: 'KoHo',
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.monetization_on_outlined,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_rounded,
                          color: theme.colorScheme.onBackground,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Ajustes',
                          style: TextStyle(
                              fontFamily: 'KoHo',
                              color: theme.colorScheme.surface,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MyLogoutAlert();
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.onBackground,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            fontFamily: 'KoHo',
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
