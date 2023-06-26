enum PrintResult {
  success,
  timeout,
  printerNotSelected,
  ticketEmpty,
  printInProgress,
  scanInProgress,
}

extension PrintResultExtension on PrintResult {
  int get value {
    switch (this) {
      case PrintResult.success:
        return 1;
      case PrintResult.timeout:
        return 2;
      case PrintResult.printerNotSelected:
        return 3;
      case PrintResult.ticketEmpty:
        return 4;
      case PrintResult.printInProgress:
        return 5;
      case PrintResult.scanInProgress:
        return 6;
    }
  }

  String get msg {
    switch (this) {
      case PrintResult.success:
        return 'Success';
      case PrintResult.timeout:
        return 'Error. Printer connection timeout';
      case PrintResult.printerNotSelected:
        return 'Error. Printer not selected';
      case PrintResult.ticketEmpty:
        return 'Error. Ticket is empty';
      case PrintResult.printInProgress:
        return 'Error. Another print in progress';
      case PrintResult.scanInProgress:
        return 'Error. Printer scanning in progress';
      default:
        return 'Unknown error';
    }
  }
}
