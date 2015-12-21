var WebSocket = require('ws');

var ws = new WebSocket(process.argv[2]);

ws.on('open', function open() {
  ws.close();
  process.exit(0);
});

ws.on('error', function(data, flags) {
  ws.close();
  process.exit(1);
});
