import 'dart:async';
import 'dart:io';

class ServerDiscovery {
  Future<String?> findServerIp() async {
    final String message = "DISCOVER_SERVER_REQUEST";
    final int port = 9999; // Port yang sama dengan server

    Completer<String?> completer = Completer();

    try {
      RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
        socket.broadcastEnabled = true;
        print('Socket created and broadcast enabled');
        socket.listen((RawSocketEvent event) {
          if (event == RawSocketEvent.read) {
            Datagram? dg = socket.receive();
            if (dg != null) {
              final String response = String.fromCharCodes(dg.data);
              print('Received response: $response');
              if (response.contains("DISCOVER_SERVER_RESPONSE")) {
                final String serverIp = dg.address.address;
                socket.close();
                completer.complete(serverIp);
              }
            }
          }
        });

        // Kirim pesan broadcast untuk mencari server
        socket.send(message.codeUnits, InternetAddress("255.255.255.255"), port);
        print('Broadcast message sent');

        // Set timeout untuk melengkapi completer jika tidak ada respons
        Future.delayed(Duration(seconds: 5), () {
          if (!completer.isCompleted) {
            socket.close();
            completer.complete(null);
            print('No response received, timed out');
          }
        });
      });
    } catch (e) {
      print('Error: $e');
      completer.complete(null);
    }

    return completer.future;
  }
}
