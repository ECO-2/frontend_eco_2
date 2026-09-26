package com.example.frontend_eco_2

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity en lugar de FlutterActivity: el diálogo de huella de
// local_auth es un BiometricPrompt, que necesita un FragmentActivity donde
// alojarse. Con FlutterActivity la autenticación falla en tiempo de ejecución.
class MainActivity : FlutterFragmentActivity()
