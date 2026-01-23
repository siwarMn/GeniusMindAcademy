// Conditional export - uses web implementation on web, stub on mobile
export 'pdf_helper_stub.dart'
    if (dart.library.html) 'pdf_helper_web.dart';
