/// Polar Ohr PPI sample
class PolarOhrPpiSample {
  /// ppInMs Pulse to Pulse interval in milliseconds.
  /// The value indicates the quality of PP-intervals.
  /// When error estimate is below 10ms the PP-intervals are probably very accurate.
  /// Error estimate values over 30ms may be caused by movement artefact or too loose sensor-skin contact.
  final int ppi;

  /// ppErrorEstimate estimate of the expected absolute error in PP-interval in milliseconds
  final int errorEstimate;

  /// hr in BPM
  final int hr;

  /// blockerBit = 1 if PP measurement was invalid due to acceleration or other reason
  final bool blockerBit;

  /// skinContactStatus = 0 if the device detects poor or no contact with the skin
  final bool skinContactStatus;

  /// skinContactSupported = 1 if the Sensor Contact feature is supported.
  final bool skinContactSupported;

  /// Create a [PolarOhrPpiSample] from json
  PolarOhrPpiSample.fromJson(Map<String, dynamic> json)
      : ppi = json['ppInMs'],
        errorEstimate = json['errorEstimate'],
        hr = json['hr'],
        blockerBit = json['blockerBit'] == 1,
        skinContactStatus = json['skinContactStatus'] == 1,
        skinContactSupported = json['skinContactSupported'] == 1;
}
