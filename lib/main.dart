import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sisal_flutter_challenge/gallery_screen/cubits/gallery_cubit.dart';
import 'package:sisal_flutter_challenge/router/app_router.dart';

import 'gazzetta_screen/cubit/gazzetta_cubit.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Sisal Challenge',
      ),
    );
  }
}

/// per un'app più complessa, si può considerare di spostare i provider in un
/// file separato
final providers = [
  BlocProvider<GazzettaCubit>(
    create: (context) => GazzettaCubit(),
  ),
  BlocProvider<GalleryCubit>(
    create: (context) => GalleryCubit(),
  ),
];
