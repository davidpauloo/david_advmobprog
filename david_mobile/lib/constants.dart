import 'package:flutter_dotenv/flutter_dotenv.dart';

final String host = (dotenv.env['HOST'] ?? 'https://advweb-backend.vercel.app');
